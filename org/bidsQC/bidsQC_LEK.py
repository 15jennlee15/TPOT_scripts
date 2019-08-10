# Import libraries
import fnmatch
import os
import os.path
import shutil
from datetime import datetime
import config_bidsQC_LEK as cfg
import json
import sys
import re
import multiprocessing as mp
import numpy as np
import scipy
from scipy import stats as ss


# Main function
def main():
    """
    Run the things.
    """
    folders_tocheck = cfg.bidsdir, cfg.derivatives, cfg.logdir, cfg.tempdir
    check_dirs(folders_tocheck)
    logfile_fullpaths = cfg.errorlog, cfg.outputlog
    create_logfiles(logfile_fullpaths)
    subjectdirs = get_subjectdirs()
    write_to_outputlog("\nScript ran on %i subject directories\n" % (len(subjectdirs)))
    
    qcMat_json,qcMat_nii,idx = initiate_qc_mats(subjectdirs)

    for i_sub,subject in enumerate(subjectdirs):
        write_to_errorlog("\n" + "-"*20 + "\n" + subject + "\n" + "-"*20)
        write_to_outputlog("\n" + "-"*20 + "\n" + subject + "\n" + "-"*20)
        timepoints = get_timepoints(subject)
        check_timepoint_count(timepoints, cfg.expected_timepoints, subject)
        for timepoint in timepoints:
            sequence_folder_names = get_sequences(subject, timepoint)
            expected_timepoint = [etp for etp in cfg.expected_timepoints if etp.name == timepoint]
            if len(expected_timepoint) == 1:
                check_sequence_folder_count(sequence_folder_names, expected_timepoint[0].sequences, subject, timepoint)
            else:
                write_to_errorlog("TIMEPOINT WARNING! %s missing or user entered duplicate or non-existant timepoint." % (timepoint))
            # for i_seq,sequence_folder_name in enumerate(sequence_folder_names):
            # changed to loop thru expected sequences rather than ones that actually exist
            for i_seq,sequence_folder_name in enumerate(expected_timepoint[0].sequences):
                # but then for each seq you have to get the name field cuz it's an obj
                sequence_folder_name = sequence_folder_name.name
                # how many of the expected sequences match the current name? can't be 0 anymore, could be > 1
                expected_sequence = [es for es in expected_timepoint[0].sequences if es.name == sequence_folder_name]
                actual_sequence = [a_s for a_s in sequence_folder_names if a_s == sequence_folder_name] # can be 0 or 1
                if len(actual_sequence) == 1:
                    if len(expected_sequence) == 1:
                        sequence_fullpath,nFound_json_array,nFound_nii_array = check_sequence_files(subject, timepoint, sequence_folder_name, expected_sequence[0])
                        #i_seq = find(sequence_folder_name,expected_timepoint[0].sequences)
                        startIdx = idx[i_seq]
                        endIdx = startIdx+nFound_json_array.size
                        qcMat_json[i_sub,startIdx:endIdx] = nFound_json_array
                        qcMat_nii[i_sub,startIdx:endIdx] = nFound_nii_array
                    else:
                        write_to_errorlog("SEQUENCE DIRECTORY WARNING! %s missing or user entered duplicate or non-existant sequence folder name." % (sequence_folder_name))
                    # print(qcMat_json)
                    # print(qcMat_nii)
                np.savetxt(cfg.outputmat_nii,qcMat_nii,delimiter='\t')
                np.savetxt(cfg.outputmat_json,qcMat_json,delimiter='\t')
                if cfg.order_sequences and sequence_folder_name=="func":
                    write_to_outputlog('\n' + '-'*20 + ' assign ordered run numbers ' + '-'*20)
                    files_all_target_tasks = append_series_number(sequence_fullpath, cfg.bidsdir, cfg.tasks_to_order)
                    files_torename = drop_runnum(files_all_target_tasks, cfg.tasks_to_order, sequence_fullpath)
                    rename_tasks_ordered(files_torename, sequence_fullpath, cfg.tasks_to_order, subject)


def initiate_qc_mats(subjectdirs):
    # assumes one timpoint despite for loop right now ***
    nSubs = len(subjectdirs)
    for tpt in cfg.expected_timepoints:
        # nSeqTypes = len(tpt.sequences)
        nScans = 0
        idx = [1] #first seq starts at idx=1
        for i_seq,s in enumerate(tpt.sequences):
            nScans = nScans + len(s.files)
            if i_seq<len(tpt.sequences)-1:
                idx.append(idx[-1]+len(s.files))
        # qcMat = np.empty((nSubs,(nSeqTypes)))
        qcMat = np.empty((nSubs,(nScans)))
        qcMat.fill(np.nan)
    subnumstrings = list(map(lambda x: x.replace(cfg.sub_prefix,''),subjectdirs))
    subnums = list(map(int,subnumstrings))
    subnumarray = np.array(subnums).reshape(nSubs,1)
    qcMat = np.concatenate((subnumarray,qcMat),1) # horizontally concatenate
    qcMat_nii = np.copy(qcMat)
    qcMat_json = np.copy(qcMat)
    return qcMat_json,qcMat_nii,idx

def drop_runnum(files_all_target_tasks, tasks_to_order, sequence_fullpath):
    for task in tasks_to_order:
        target_files = [f for f in files_all_target_tasks if str(task) in f and str('_run-') in f]
        for target_file in target_files:
            run_index = target_file.index("_run-")
            targetfile_fullpath = os.path.join(sequence_fullpath, target_file)
            os.rename(targetfile_fullpath, targetfile_fullpath.replace(target_file[run_index:run_index + 7], ''))
            write_to_outputlog('Dropped runnum from ' + target_file)
    sequence_files = sorted(os.listdir(sequence_fullpath))
    files_torename = [sequence_file for sequence_file in sequence_files for task in tasks_to_order if str(task) in sequence_file]
    return files_torename
    

def atoi(text):
    return int(text) if text.isdigit() else text

def natural_keys(text):
    '''
    alist.sort(key=natural_keys) sorts in human order
    http://nedbatchelder.com/blog/200712/human_sorting.html
    (See Toothy's implementation in the comments)
    '''
    return [ atoi(c) for c in re.split('(\d+)', text) ]


def rename_tasks_ordered(files_torename:list, sequence_fullpath:str, tasks_to_order:list, subject:str):    
    write_to_outputlog('Appending run number based on sequence acquisition order.')
    for task in tasks_to_order:
        files_one_task = [f for f in files_torename if str(task) in f]
        extensions = '.nii.gz', '.json'
        write_to_outputlog('    Task: %s' % (task))
        for extension in extensions:
            task_files_oftype = [f for f in files_one_task if f.endswith(extension)]
            task_files_oftype.sort(key=natural_keys)
            i = 1
            for target_file in task_files_oftype:
                bold_index = target_file.index('_bold')
                start_str = target_file[0:bold_index]
                end_str = target_file[bold_index:]
                runnum = str(i).zfill(2)
                new_file_name = start_str + '_run-' + runnum + end_str
                write_to_outputlog('        File: %s\n          Series number: %s\n          New run number: %s' %(target_file, target_file.split('_')[0], runnum))
                os.rename(os.path.join(sequence_fullpath, target_file), os.path.join(sequence_fullpath, new_file_name.split('_', 1)[-1]))
                i = i + 1


def append_series_number(sequence_fullpath:str, bidsdir:str, tasks_to_order: list):
    """
    Pull SeriesNumber from the JSON file and append it as a prefix to the appropriate json and nifti files.
    """
    write_to_outputlog('Appending sequence numbers')
    sequence_files = sorted(os.listdir(sequence_fullpath))
    #files_all_target_tasks = [sequence_file for sequence_file in sequence_files for task in tasks_to_order if str(task) in sequence_file]
    files_all_target_tasks = [sequence_file for sequence_file in sequence_files if any(str(task) in sequence_file for task in tasks_to_order)]
    extensions = '.nii.gz', '.json'
    json_files = [f for f in files_all_target_tasks if f.endswith('.json')]
    for json_file in json_files:
        file_basename = get_file_basename(json_file)
        json_fullpath = os.path.join(sequence_fullpath, json_file)
        with open(json_fullpath) as f:
            data = json.load(f)
            series_number = data["SeriesNumber"]
        extensions = '.nii.gz', '.json'
        for extension in extensions:
            new_file_name = str(series_number) + '_' + file_basename + extension
            os.rename(os.path.join(sequence_fullpath, file_basename + extension), os.path.join(sequence_fullpath, new_file_name))
    sequence_files = sorted(os.listdir(sequence_fullpath))
    files_all_target_tasks = [sequence_file for sequence_file in sequence_files if any(str(task) in sequence_file for task in tasks_to_order)]
    return files_all_target_tasks


def get_file_basename(json_file:str):
    file_base_name = json_file.split('.')[0:-1]
    return str(file_base_name[0])


# Define a function to create files
def touch(path:str):
    """
    Create a new file
    
    @type path:     string
    @param path:    path to - including name of - file to be created
    """
    with open(path, 'a'):
        os.utime(path, None)

# Check and create directories
def check_dirs(dir_fullpaths:list):
    """
    Check if a directory exists. If not, create it.

    @type dir_fullpaths:        list
    @param dir_fullpaths:       Paths to directorys to check
    """
    for dir_fullpath in dir_fullpaths:
        if not os.path.isdir(dir_fullpath):
            os.mkdir(dir_fullpath)

# Create logs
def create_logfiles(logfile_fullpaths:list):
    """
    Check if a logfile exists. If not, make one.

    @type logfile_fullpaths:         list
    @param logfile_fullpaths:        Paths to logfiles to check
    """
    for logfile_fullpath in logfile_fullpaths:
        if not os.path.isfile(logfile_fullpath):
            touch(logfile_fullpath)

# Functions to write to log files
def write_to_outputlog(message):
    """
    Write a log message to the output log. Also print it to the terminal.

    @type message:          string
    @param message:         Message to be printed to the log
    """
    with open(cfg.outputlog, 'a') as logfile:
        logfile.write(message + os.linesep)
    print(message)

def write_to_errorlog(message):
    """
    Write a log message to the error log. Also print it to the terminal.

    @type message:          string
    @param message:         Message to be printed to the log
    """
    with open(cfg.errorlog, 'a') as logfile:
        logfile.write(message + os.linesep)
    print(message)

# Check for subject directories
def get_subjectdirs() -> list:
    """
    Returns subject directory names (not full path) based on the bidsdir (bids_data directory).

    @rtype:  list
    @return: list of bidsdir directories that start with the prefix sub
    """
    bidsdir_contents = sorted(os.listdir(cfg.bidsdir))
    has_sub_prefix = [subdir for subdir in bidsdir_contents if subdir.startswith(cfg.sub_prefix)]
    subjectdirs = [subdir for subdir in has_sub_prefix if os.path.isdir(os.path.join(cfg.bidsdir, subdir))]
    subjectdirs.sort()
    return subjectdirs

# Get the timepoints
def get_timepoints(subject: str) -> list:
    """
    Returns a list of ses-wave directory names in a participant's directory.

    @type subject:  string
    @param subject: subject folder name

    @rtype:  list
    @return: list of ses-wave folders in the subject directory
    """
    subject_fullpath = os.path.join(cfg.bidsdir, subject)
    subjectdir_contents = sorted(os.listdir(subject_fullpath))
    return [f for f in subjectdir_contents if not f.startswith('.')]

# Check subjects' sessions
def check_timepoint_count(timepoints: list, expected_timepoints: list, subject: str):
    """
    Compare the expected number of ses-wave directories to the actual number and print the result to the output or errorlog.

    @type timepoints:                       list
    @param timepoints:                      list of ses-wave folders in the subject directory
    @type expected_timepoints:              list
    @param expected_timepoints:             Number of timepoint folders each subject should have
    @type subject:                          string
    @param subject:                         subject folder name
    """
    number_timepoints_exist = len(timepoints)
    log_message =  "%s has %s ses-wave directories." % (subject, str(number_timepoints_exist))
    if len(expected_timepoints) != number_timepoints_exist:
        write_to_errorlog("\nTIMEPOINT WARNING! %s Expected %s \n" % (log_message, str(len(expected_timepoints))))
    else:
        write_to_outputlog("\n EXISTS: %s \n" % (log_message))

# Get sequences
def get_sequences(subject: str, timepoint: str) -> list:
    """
    Returns a list of sequence directory names (e.g. anat, fmap, etc.) in a participant's directory at a given timepoint.

    @type subject:              string
    @param subject:             Subject folder name
    @type timepoint:            string
    @param timepoint:           Timepoint folder name

    @rtype:                     list
    @return:                    list of sequence folders that exist in the subject directory
    """
    timepoint_fullpath = os.path.join(cfg.bidsdir, subject, timepoint)
    timepoint_contents = sorted(os.listdir(timepoint_fullpath))
    return [f for f in timepoint_contents if not f.startswith('.')]

# Check subjects' sessions
def check_sequence_folder_count(sequence_folder_names: list, expected_sequences: list, subject: str, timepoint: str):
    """
    Compare the expected number of ses-wave directories to the actual number and print the result to the output or errorlog.

    @type sequence_folder_names:            list
    @param sequence_folder_names:           List of sequence folders in the subject directory (e.g. anat, fmap, etc.)
    @type expected_sequences:               list
    @param expected_sequences:              Number of sequence folders each subject should have within the timepoint
    @type subject:                          string
    @param subject:                         Subject folder name
    @type timepoint:                        string
    @param timepoint:                       Timepoint folder name
    """
    number_sequences_exist = len(sequence_folder_names)
    log_message =  "%s %s has %s total sequence directories" % (subject, timepoint, str(number_sequences_exist))
    if len(expected_sequences) != number_sequences_exist:
        write_to_errorlog("\n SEQUENCE DIRECTORY WARNING! %s Expected %s.\n" % (log_message, str(len(expected_sequences))))
    else:
        write_to_outputlog("\n EXISTS: %s. \n" % (log_message))

# Check files
def check_sequence_files(subject: str, timepoint: str, sequence: str, expected_sequence: object):
    """
    Compare the contents of a given sequence folder to the expected contents.

    @type subject:                          string
    @param subject:                         Subject folder name
    @type timepoint:                        string
    @param timepoint:                       Name of timepoint
    @type sequence:                         str
    @param sequence:                        Name of sequence folder (e.g. anat, fmap, etc.)
    @type expected_sequence:                object
    @param expected_sequence:               The expected sequence
    """
    extension_json = "json"
    extension_nifti = "nii.gz" if cfg.gzipped else ".nii"
    sequence_fullpath = os.path.join(cfg.bidsdir, subject, timepoint, sequence)
    if not os.path.isdir(sequence_fullpath):
        write_to_errorlog("\n FOLDER WARNING! %s folder missing for %s \n" % (sequence, subject))
    else:
        write_to_outputlog("\n EXISTS: %s folder for subject %s \n" % (sequence, subject))
    validate_sequencefilecount(expected_sequence, sequence_fullpath, extension_json, timepoint, subject)
    validate_sequencefilecount(expected_sequence, sequence_fullpath, extension_nifti, timepoint, subject)
    write_to_outputlog('-'*20 + ' checking number of files ' + '-'*20)
    nFound_json_array = np.empty((1,len(expected_sequence.files.keys())));
    nFound_nii_array = np.empty((1,len(expected_sequence.files.keys())));
    for i_key,key in enumerate(expected_sequence.files.keys()):
        nFound_json_array[0,i_key] = fix_files(sequence_fullpath, key, expected_sequence.files[key], extension_json, subject, timepoint)
        nFound_nii_array[0,i_key] = fix_files(sequence_fullpath, key, expected_sequence.files[key], extension_nifti, subject, timepoint)
    return sequence_fullpath,nFound_json_array,nFound_nii_array

# Validate sequence files
def validate_sequencefilecount(expected_sequence: object, sequence_fullpath: str, extension: str, timepoint: str, subject: str):
    """
    Compare the number of files of a given sequence type to the number of expected files \
    for that sequence, specified in the configuration file.    
    """
    sequence_files = sorted(os.listdir(sequence_fullpath))
    found_allfiles = [file for file in sequence_files if file.endswith(extension)]
    if len(found_allfiles) > expected_sequence.get_filecount():
        write_to_errorlog("WARNING! Too many %s files in %s %s %s" % (extension, subject, timepoint, os.path.basename(sequence_fullpath)))
        
# Fix files
def fix_files(sequence_fullpath: str, file_group: str, expected_numfiles: int, extension: str, subject: str, timepoint: str):
    """
    Compare the contents of a given sequence folder to the expected contents. \
    If more than the expected number of runs of a file exist, move the appropriate \
    number of files with the lowest run numbers to the tmp__dcm2bids folder. \
    Then, change the run numbers for the remaining files.

    @type sequence_fillpath:                string
    @param sequence_fullpath:               The full path to to the sequence folder
    @type filegroup:                        string
    @param filegroup:                       Name of files (e.g. T1w, taskname) to check
    @type expected_numfiles:                integer
    @param expected_numfiles:               The expected number of runs for the filegroup
    @type: extension:                       string
    @param extension:                       File extension
    @type subject:                          string
    @param subject:                         Subject folder name
    @type timepoint:                        string
    @param timepoint:                       Name of timepoint
    """
    sequence_files = os.listdir(sequence_fullpath)
    found_files = [file for file in sequence_files if file_group in file and file.endswith(extension)]
    if len(found_files) == expected_numfiles:
        write_to_outputlog("OK: %s has correct number of %s %s files in %s." % (subject, file_group, extension, timepoint))
        return len(found_files)
    if len(found_files) < expected_numfiles:
        write_to_errorlog("FILE WARNING! %s MISSING %s %s files in %s." % (subject, file_group, extension, timepoint))
        return len(found_files)
    if len(found_files) > expected_numfiles:
        difference = len(found_files) - expected_numfiles
        found_files.sort()
        write_to_outputlog("\n FIXING FILES: %s \n" % (extension))
        if cfg.extra_files_delete_criteria == "first":
            for found_file in found_files:
                try:
                    run_index = found_file.index("_run-")
                    run_number = found_file[run_index + 5:run_index + 7]
                    run_int = int(run_number) 
                    targetfile_fullpath = os.path.join(sequence_fullpath, found_file)
                    if run_int <= difference: 
                        move_files_tmp(targetfile_fullpath, subject, timepoint)
                    elif run_int > difference:
                        if expected_numfiles == 1:
                            os.rename(targetfile_fullpath, targetfile_fullpath.replace(found_file[run_index:run_index + 7], ''))
                            write_to_outputlog("RENAMED: %s, dropped run from filename" % (targetfile_fullpath))
                        elif expected_numfiles > 1:
                            new_int = run_int - difference
                            int_str = str(new_int)
                            new_runnum = int_str.zfill(2)
                            new_runstr = 'run-' + new_runnum
                            os.rename(targetfile_fullpath, targetfile_fullpath.replace(found_file[run_index + 1:run_index + 7], new_runstr))
                            write_to_outputlog("RENAMED: %s with run-%s" % (targetfile_fullpath, new_runnum))
                except ValueError:
                    write_to_errorlog('VALUE ERROR in fix_files:\n    Subject: %s\n     File: %s' %(subject, found_file))
        elif cfg.extra_files_delete_criteria == "smallest":
            found_file_paths = list(map(lambda f:os.path.join(sequence_fullpath,f),found_files))
            if extension==".json":
                found_file_paths = list(map(lambda p:p.replace(".json",".nii.gz"),found_file_paths))
            file_sizes = list(map(os.path.getsize,found_file_paths))
            file_size_ranks = ss.rankdata(file_sizes,method="min")
            file_size_ranks = len(file_size_ranks)-file_size_ranks+1 #flip ranks
            delete_bool = file_size_ranks>expected_numfiles
            new_int=0
            for i_file,found_file in enumerate(found_files):
                try:
                    run_index = found_file.index("_run-")
                    run_number = found_file[run_index + 5:run_index + 7]
                    run_int = int(run_number) 
                    targetfile_fullpath = os.path.join(sequence_fullpath, found_file)
                    if sum(delete_bool)>difference:
                        write_to_outputlog("\nWARNING: Too many files removed: %i removed, %i expected; due to tie in file size\n" % (sum(delete_bool),difference))
                    if delete_bool[i_file]:
                    # delete (move) it!
                        move_files_tmp(targetfile_fullpath, subject, timepoint)
                    else: # don't delete! but get rid of runnum or correct it
                        if expected_numfiles == 1:
                            os.rename(targetfile_fullpath, targetfile_fullpath.replace(found_file[run_index:run_index + 7], ''))
                            write_to_outputlog("RENAMED: %s, dropped run from filename" % (targetfile_fullpath))
                        elif expected_numfiles > 1:
                            new_int = new_int+1
                            int_str = str(new_int)
                            new_runnum = int_str.zfill(2)
                            new_runstr = 'run-' + new_runnum
                            os.rename(targetfile_fullpath, targetfile_fullpath.replace(found_file[run_index + 1:run_index + 7], new_runstr))
                            write_to_outputlog("RENAMED: %s with run-%s" % (targetfile_fullpath, new_runnum))
                except ValueError:
                    write_to_errorlog('VALUE ERROR in fix_files:\n    Subject: %s\n     File: %s' %(subject, found_file))


    return len(found_files)


def move_files_tmp(target_file:str, subject:str, timepoint:str):
    """
    Move files to a holding directory.

    @type target_file:      string
    @param target_file:     The full path to the file to be moved.
    @type subject:          string
    @param subject:         Subject folder name.
    @type timepoint:        string
    @param timepoint:       Name of timepoint.            
    """
    tempdir_fullpath = os.path.join(cfg.tempdir, subject + "_" + timepoint)
    if not os.path.isdir(tempdir_fullpath):
        os.mkdir(tempdir_fullpath)
    shutil.move(target_file, tempdir_fullpath)
    target_filename = os.path.basename(target_file)
    write_to_outputlog("MOVED: %s to %s" % (target_filename, tempdir_fullpath))


# Call main
main()