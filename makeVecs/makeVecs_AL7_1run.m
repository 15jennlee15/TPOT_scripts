DIR.out = '~/Dropbox/AL_output2/output/';
DIR.in =  '~/Documents/GitHub/TPOT_scripts/fMRI/fx/multiconds/affect/';
DIR.vec = '~/Documents/GitHub/TPOT_scripts/AL/vecs';
DIR.thisFunk = '~/Documents/GitHub/TPOT_scripts/makeVecs/';

outputList = dir([DIR.out,'tp*output.txt']);
subList = [];
for i=1:length(outputList)
    subList(i) = str2num(outputList(i).name(3:5));
end
subList = unique(subList);

nRuns = 2;
studyCode = 'tp';
taskCode = 'al';
modelCode = '7conds';
maxTrialLength = 6; % 100% making this up

% Saving SPM-ready names, onsets, and durations to .mat

DIR.vecModel = [DIR.vec filesep modelCode];
if ~exist(DIR.vecModel)
    mkdir(DIR.vecModel)
end

names = {'Happy' 'Angry' 'Sad' 'CB_Happy' 'CB_Angry' 'CB_Sad' 'Blurry'};
nConds = length(names);

for s = subList
    
    if s<10
        placeholder = '00';
    elseif s<100
        placeholder = '0';
    else
        placeholder = '';
    end
    subjectCode = [studyCode placeholder num2str(s)];
    
    for r=1:nRuns
        filenames.out = [DIR.out filesep subjectCode '_' taskCode '_run' num2str(r) '.mat'];
        filenames.vec = [DIR.vecModel filesep subjectCode '_run' num2str(r) '_' modelCode];
        onsets = cell(1,nConds);
        durations = cell(1,nConds);
        
        if ~exist(filenames.out,'file')
            warning('No output file found for subject %d, run %d.\n',s,r);
        else
            
            % import output file to determine actual onsets/durations DO THIS
            load(filenames.out)
            % Add column for time between onset + next onset - use for
            % duration for NR cond
            task.output.raw(:,6) =  [task.output.raw(2:end,3);task.output.raw(end,3)+maxTrialLength] - task.output.raw(:,3);
            
            
             % Get event indices
             isNR = isnan(task.output.raw(:,4)); % find non-response trials
             isHappy = task.output.raw(:,2)==1 & ~isNR;
             isAngry = task.output.raw(:,2)==2 & ~isNR;
             isSad = task.output.raw(:,2)==3 & ~isNR;
             isCBHappy = task.output.raw(:,2)==4 & ~isNR;
             isCBAngry = task.output.raw(:,2)==5 & ~isNR;
             isCBSad = task.output.raw(:,2)==6 & ~isNR;
             isBlur = task.output.raw(:,2)==7 & ~isNR;
             
             
             % Get data from task.output.raw
             onsets{1} = task.output.raw(isHappy,3);
             onsets{2} = task.output.raw(isAngry,3);
             onsets{3} = task.output.raw(isSad,3);
             onsets{4} = task.output.raw(isCBHappy,3);
             onsets{5} = task.output.raw(isCBAngry,3);
             onsets{6} = task.output.raw(isCBSad,3);
             onsets{7} = task.output.raw(isBlur,3);
             
             % is this right???
             durations{1} = task.output.raw(isHappy,4);
             durations{2} = task.output.raw(isAngry,4);
             durations{3} = task.output.raw(isSad,4);
             durations{4} = task.output.raw(isCBHappy,4);
             durations{5} = task.output.raw(isCBAngry,4);
             durations{6} = task.output.raw(isCBSad,4);
             durations{7} = task.output.raw(isBlur,4);
              
            % save vec file for this run
            save(filenames.vec,'names','onsets','durations');
        end
    end
    
end

cd(DIR.thisFunk)
