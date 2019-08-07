# This script wil take a list made from the lcni directory
# and will strip the excess leaving all the names
import os
import re
from itertools import groupby

# Set study info (may need to change for your study)
# These variables are used only in this file for paths. Can omit if wanted.
group = "adapt_lab"
study = "TPOT"
PI = "Allen"
scriptsFolder = "TPOT_Scripts"

# The following variables are used in the main script and need to be defined here. 
# They need to exist prior to running the script

# Directories
dicomdir = os.path.join(os.sep, "projects", "lcni", "dcm", group, "Allen", study)
parentdir = os.path.join(os.sep, "projects", group, "shared", study) # folder that contains bidsdir and codedir
codedir = os.path.join(parentdir, scriptsFolder, "org", "conversion") 

subjectdir_contents = os.listdir(dicomdir)
subjectdir_contents.sort()

# filter subject directory for anything less than 16 characters (this is study specific)
subjectdir_contents = list(filter(lambda k: [len(k) < 16 or len(k) == 24], subjectdir_contents))

exclusion = ['physio','hantom','Blogs','lcni','ppp','pumpkin','trigger',"TEST","test"]

test = [directory for directory in subjectdir_contents if any(sub in directory for sub in exclusion)]

subjectdir_contents = list(set(subjectdir_contents)-set(test))

subjectdir_contents.sort()

subject_num = [[int(''.join(i)) for is_digit, i in groupby(subject, str.isdigit) if is_digit][0] for subject in subjectdir_contents]

# [x for x in subject_num if subject_num.count(x) >= 2]

concat_func = lambda x,y: x + ",TPOT" + str("{:03d}".format(y) + ",1")

subjectdir_contents = list(map(concat_func,subjectdir_contents,subject_num))


with open(os.path.join(codedir,"subject_list.txt"), mode="w+") as outfile:  # also, tried mode="rb"
    for subject in subjectdir_contents:
        outfile.write("%s\n" % subject)




