# This script specifies the following user inputs for auto_motion_fmriprep.R:
# * confoundDir = path to the fmriprep confounds files
# * summaryDir = path to the output directory for summary csv files
# * rpDir = path to output directory to write new rp_txt files
# * plotDir = path to output directory to write plots
# * study = study name
# * oldfmriprep = use TRUE if using version 1.1.8 or earlier; FALSE if 1.1.2 or later
# * noRP = suppress new realignment parameter (rp_txt) text files; use TRUE or FALSE
# * noPlots = suppress plots for each subject run; use TRUE or FALSE
# * noEuclidean = do not use the Euclidean distance; use the raw realigment parameters instead
#   when exporting rp_txt files; use TRUE or FALSE. If FALSE, rp_txt files will incude the following columns:
#   Euclidean distance translation, Euclidean distance rotation, Euclidean distance derivative translation, 
#   Euclidean distance derivative rotation, trash. If TRUE, rp_txt files will incude the following columns: 
#   X, Y, Z, RotX, RotY RotZ, trash.
# * figIndicators = motion indicators to print in plot
# * figFormat = file format for plot
# * figHeight = plot height in inches
# * figWidth = plot width in inches
# * figDPI = plot resolution in dots per inch

# paths
confoundDir = '/Users/jennlewis/Desktop/confounds3/'
summaryDir = '/Users/jennlewis/Documents/GitHub/TPOT_Scripts/fMRI/ppc/auto-motion-fmriprep/summary'
plotDir = '/Users/jennlewis/Documents/GitHub/TPOT_Scripts/fMRI/ppc/auto-motion-fmriprep/plots'
rpDir = '/Users/jennlewis/Documents/GitHub/TPOT_Scripts/fMRI/ppc/auto-motion-fmriprep/rp_txt'

# variables
study = 'TPOT'
oldfmriprep = FALSE
noRP = FALSE
noPlot = FALSE
noEuclidean = FALSE
figIndicators = c('FramewiseDisplacement', 'GlobalSignal', 'stdDVARS')
figFormat = '.png'
figHeight = 5.5
figWidth = 7
figDPI = 250
