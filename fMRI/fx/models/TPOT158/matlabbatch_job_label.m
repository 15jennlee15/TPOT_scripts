%-----------------------------------------------------------------------
% Job saved on 15-Aug-2018 14:05:36 by cfg_util (rev $Rev: 6942 $)
% spm SPM - SPM12 (7219)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

%% select run 1 files
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/projects/adapt_lab/shared/TPOT/bids_data/derivatives/fmriprep/sub-TPOT158/ses-1/func'};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = 'sm6_sub-TPOT158_ses-1_task-affect_acq-1_run-01_space-MNI152NLin2009cAsym_desc-preproc_bold.nii';
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';

%% expand the frames of run 1 files
matlabbatch{2}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (sm6_sub-TPOT158_ses-1_task-affect_acq-1_run-01_space-MNI152NLin2009cAsym_desc-preproc_bold.nii)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{2}.spm.util.exp_frames.frames = Inf;

%% specify the model
matlabbatch{3}.spm.stats.fmri_spec.dir = {'/projects/adapt_lab/shared/TPOT/out/fx/models/affect/sub-TPOT158'};
matlabbatch{3}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{3}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{3}.spm.stats.fmri_spec.timing.fmri_t = 72;
matlabbatch{3}.spm.stats.fmri_spec.timing.fmri_t0 = 36;
matlabbatch{3}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('Expand image frames: Expanded filename list.', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{3}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{3}.spm.stats.fmri_spec.sess(1).multi = {'/projects/adapt_lab/shared/TPOT/TPOT_Scripts/AL/vecs/7conds/sub-TPOT158_run1_7conds.mat'};
matlabbatch{3}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{3}.spm.stats.fmri_spec.sess(1).multi_reg = {'/projects/adapt_lab/shared/TPOT/TPOT_Scripts/fMRI/ppc/auto-motion-fmriprep/rp_txt/rp_TPOT158_1_affect_acq-1_1.txt'};
matlabbatch{3}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{3}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
matlabbatch{3}.spm.stats.fmri_spec.volt = 1;
matlabbatch{3}.spm.stats.fmri_spec.global = 'None';
matlabbatch{3}.spm.stats.fmri_spec.mthresh = -Inf;
matlabbatch{3}.spm.stats.fmri_spec.mask(1) = {'/projects/adapt_lab/jlewis5/ERdissertation/spm12/canonical/MNI152_T1_1mm_brain_mask.nii'}; 
matlabbatch{3}.spm.stats.fmri_spec.cvi = 'FAST';

%% estimate the model (i.e. solve for the betas)
matlabbatch{4}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{4}.spm.stats.fmri_est.method.Classical = 1;

%% specify the contrasts of interest
matlabbatch{5}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{5}.spm.stats.con.consess{1}.tcon.name = '1_View>Blur';
matlabbatch{5}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 0 0 0 1 0 1 0 1 0 -3 0 0 0];
matlabbatch{5}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{2}.tcon.name = '2_ViewHappy>Blur';
matlabbatch{5}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 1 0 0 0 0 0 -1 0 0 0];
matlabbatch{5}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{3}.tcon.name = '3_ViewAngry>Blur';
matlabbatch{5}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0 0 0 0 0 1 0 0 0 -1 0 0 0];
matlabbatch{5}.spm.stats.con.consess{3}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{4}.tcon.name = '4_ViewSad>Blur';
matlabbatch{5}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0];
matlabbatch{5}.spm.stats.con.consess{4}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{5}.tcon.name = '5_ViewHappy>ViewAngry';
matlabbatch{5}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{5}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{6}.tcon.name = '6_ViewAngry>ViewSad';
matlabbatch{5}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 0 0 0 1 0 -1 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{6}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{7}.tcon.name = '7_ViewSad>ViewHappy';
matlabbatch{5}.spm.stats.con.consess{7}.tcon.weights = [0 0 0 0 0 0 -1 0 0 0 1 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{7}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{8}.tcon.name = '8_Label>Blur';
matlabbatch{5}.spm.stats.con.consess{8}.tcon.weights = [1 0 1 0 1 0 0 0 0 0 0 0 -3 0 0 0];
matlabbatch{5}.spm.stats.con.consess{8}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{9}.tcon.name = '9_LabelHappy>Blur';
matlabbatch{5}.spm.stats.con.consess{9}.tcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 0];
matlabbatch{5}.spm.stats.con.consess{9}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{10}.tcon.name = '10_LabelAngry>Blur';
matlabbatch{5}.spm.stats.con.consess{10}.tcon.weights = [0 0 1 0 0 0 0 0 0 0 0 0 -1 0 0 0];
matlabbatch{5}.spm.stats.con.consess{10}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{11}.tcon.name = '5_LabelSad>Blur';
matlabbatch{5}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 1 0 0 0 0 0 0 0 -1 0 0 0];
matlabbatch{5}.spm.stats.con.consess{11}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{12}.tcon.name = '12_LabelHappy>LabelAngry';
matlabbatch{5}.spm.stats.con.consess{12}.tcon.weights = [1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{12}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{13}.tcon.name = '13_LabelAngry>LabelSad';
matlabbatch{5}.spm.stats.con.consess{13}.tcon.weights = [0 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{13}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{14}.tcon.name = '14_LabelSad>LabelHappy';
matlabbatch{5}.spm.stats.con.consess{14}.tcon.weights = [-1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{14}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{15}.tcon.name = '15_Label>View';
matlabbatch{5}.spm.stats.con.consess{15}.tcon.weights = [1 0 1 0 1 0 -1 0 -1 0 -1 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{15}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{16}.tcon.name = '7_LabelHappy>ViewHappy';
matlabbatch{5}.spm.stats.con.consess{16}.tcon.weights = [1 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{16}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{17}.tcon.name = '17_LabelAngry>ViewAngry';
matlabbatch{5}.spm.stats.con.consess{17}.tcon.weights = [0 0 1 0 0 0 0 0 -1 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{17}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{18}.tcon.name = '18_LabelSad>ViewSad';
matlabbatch{5}.spm.stats.con.consess{18}.tcon.weights = [0 0 0 0 1 0 0 0 0 0 -1 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{18}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{19}.tcon.name = '19_ViewHappy>IB';
matlabbatch{5}.spm.stats.con.consess{19}.tcon.weights = [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{19}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{20}.tcon.name = '20_ViewAngry>IB';
matlabbatch{5}.spm.stats.con.consess{20}.tcon.weights = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{20}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{21}.tcon.name = '21_ViewSad>IB';
matlabbatch{5}.spm.stats.con.consess{21}.tcon.weights = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{21}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{22}.tcon.name = '22_LabelHappy>IB';
matlabbatch{5}.spm.stats.con.consess{22}.tcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{22}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{23}.tcon.name = '23_LabelAngry>IB';
matlabbatch{5}.spm.stats.con.consess{23}.tcon.weights = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{23}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.consess{24}.tcon.name = '24_LabelSad>IB';
matlabbatch{5}.spm.stats.con.consess{24}.tcon.weights = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
matlabbatch{5}.spm.stats.con.consess{24}.tcon.sessrep = 'replsc';
matlabbatch{5}.spm.stats.con.delete = 0;