import os
from datetime import datetime
from bidsQC_classes import Sequence
from bidsQC_classes import TimePoint

######################## CONFIGURAGBLE PART BELOW ########################

# Set study info (change these for your study)
# These variables are used only in this file for path names.
# They can be removed if desired.
group = 'adapt_lab'
study = 'TPOT'
#sub_prefix = 'sub-'
sub_prefix = 'sub-TPOT' # adam's way
# extra_files_delete_criteria = "first" # set to "first" or "smallest"
extra_files_delete_criteria = "smallest" # set to "first" or "smallest"

# Set directories (Check these for your study)
# These variables are used in the main script and need to be defined here. 
# They need to exist prior to running the script.
logdir = os.path.join(os.getcwd(), 'logs_bidsQC')  # Where log files will go
bidsdir = os.path.join(os.sep, 'projects', group, 'shared', study, 'bids_data')  # Where your subjects' nifti directories are
#bidsdir = os.path.join(os.sep, '/Users/laurenkahn/Desktop', study, 'bids_data')  # Where your subjects' nifti directories are


# Create a dictionary (the thing below) for each timepoint in your study where the pairs are 'sequence_directory_name' : 'expected_number_runs'
# Each unique version of a sequence gets its own entry, e.g. 'gng_acq-1' and 'gng_acq-2'

# alphabetized to be consistent with searching thru folders; should make more flexible ***
sequence1 = Sequence('anat', {'T1w':1})
sequence2 = Sequence('dwi', {'acq-lr':1, 'acq-rl':1})
sequence3 = Sequence('fmap', {'dir-ap':1, 'dir-pa':1})
sequence4 = Sequence('func', {'affect_acq-1': 1, 'affect_acq-2': 1, 'rest': 2, 'video': 1})
# each func sequence should correspond to the search terms used in study_config for dcm2bids

timepoint1 = TimePoint('ses-1', [sequence1, sequence2, sequence3, sequence4])
expected_timepoints = [timepoint1]

# Files g-zipped or not? 
# NOTE: All files must be either zipped or unzipped. 
# A mixture won't work properly.
gzipped = True


# Do we want runs based on sequence order? Yes = True
# This is for tasks that use counterbalancing (of e.g. stimulus blocks) and for which we want to identify the content
# with the 'acq-' label and order administered with the 'task-' label.
order_sequences = True
tasks_to_order = 'affect', #comma makes it a tuple instead of a string
# note: tasks_to_order can be a different classification than the different func sequence groupings


# Paths that are required and that should not be changed
tempdir = os.path.join(bidsdir, 'tmp_dcm2bids')  # holding folder for undesired files
outputlog = os.path.join(logdir, 'outputlog_bidsQC' + datetime.now().strftime('%Y%m%d-%H%M%S') + '.txt')
errorlog = os.path.join(logdir, 'errorlog_bidsQC' + datetime.now().strftime('%Y%m%d-%H%M%S') + '.txt')
outputmat_json = os.path.join(logdir, 'outputmat_json_bidsQC' + datetime.now().strftime('%Y%m%d-%H%M%S') + '.txt')
outputmat_nii = os.path.join(logdir, 'outputmat_nii_bidsQC' + datetime.now().strftime('%Y%m%d-%H%M%S') + '.txt')
runmat = os.path.join(logdir, 'runmat_bidsQC' + datetime.now().strftime('%Y%m%d-%H%M%S') + '.txt')
derivatives = os.path.join(bidsdir, 'derivatives')  # Where processed data will go