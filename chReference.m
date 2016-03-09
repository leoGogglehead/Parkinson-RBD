%%
% This script i) downloads the EEG, EKG, EMG and EOG channels from the Chahine
% Parkinson Study by blocks. There are 8 channels in total, including 2 references.
% ii) references the other 6 eeg channels to the 2 references A1 and A2
% iii) saves the referenced eeg channels and ekg, emg and eog into a new
% file by blocks. 

%%
% DOWNLOAD DATA
% Clear console and workspace
clc; clear all;

% List of RB number that use F3F4
% RB = [1, 4, 8, 9, 11:13, 18:20, 23, 24, 30:36, 38:43, 45:50, 52, 53, 59,61];
RB = [4, 9, 11:13, 18, 19, 23,24, 31:36, 39:43, 46:53, 57, 61, 63, 68, 70:74, 76:80, 85, 88:92, 95, 96, 98:106, 110:113]; 

% for i = 1 : length(RBNum)
for subj = 1
    % Make subj dataset name
    dataset = sprintf('RB%03d01',RB(subj))
    % Open sessions
    % Test w subj 1
    addpath(genpath('F:\Grad School\Github'));
    session = IEEGSession(dataset,'gogglehead','gog_ieeglogin.bin');
    
    % Get sampling rate and duration in seconds
    samplingRateEEG = session.data.channels(1).sampleRate;
    dataEEGDuration = session.data.channels(1).get_tsdetails.getDuration;
    durationSec = dataEEGDuration/ 1e6;
    
%     % Set Block duration in seconds and calculate the leftover time (which will
%     % stored in the last block)
%     blockDuration = 30*60;
%     numBlocks = floor(durationSec/blockDuration) ;
%     lastBlockSec = durationSec - numBlocks * blockDuration;
%     
%     block = 1;
%     while block < length(numBlocks) + 1
        % Get channels and store in 4 types of arrays EEG, EKG, EMG and EOG. Order
        % of channels: A1(1),A2(2), C3(4), C4(5), EKG1(9), EKG2(10), EMG1(11),
        % EMG2(12), F7(13), F8(14), L-EOG(17), O1(21), O2(22), R-EOG(26).
        % NOTE: For now, we'll just use EEG.
%          EEGPreRef = session.data.getvalues((block-1)*blockDuration*samplingRateEEG +1 ...
%             :block*blockDuration*samplingRateEEG ,[1,2,4,5,13,14, 21, 22]);
    
    % NOTE: Matlab can load up to 6 channels at a time from ieeg.org ~
    % 8 hours worth
        chRef = session.data.getvalues(1 : dataEEGDuration / 1e6 * 128 ,1:2);
        chA1  = chRef(:,1);
        chA2  = chRef(:,2);
        
        chPreRef = session.data.getvalues(1 : dataEEGDuration / 1e6 * 128, [4:5,13:14,21:22]);
        chPostRef= [chPreRef(:,1)-chA2 chPreRef(:,2)-chA1 chPreRef(:,3)-chA2 ... 
                    chPreRef(:,4)-chA1 chPreRef(:,5)-chA2 chPreRef(:,6)-chA1];
                
%         chF7F8 = session.data.getvalues(1 : dataEEGDuration / 1e6 * 128, 13:14);
%         chO1O2 = session.data.getvalues(1 : dataEEGDuration / 1e6 * 128, 21:22);
        
%         C3C4Ref = [chC3C4(:,1)-chA1A2(:,2) chC3C4(:,2)-chA1A2(:,1)];
%         F7F8Ref = [chF7F8(:,1)-chA1A2(:,2) chF7F8(:,2)-chA1A2(:,1)];
%         O1O2Ref = [chO1O2(:,1)-chA1A2(:,2) chO1O2(:,2)-chA1A2(:,1)];
        
    %%
    % Reference the odd number channels to A2 and even number channels to A1 by
    % subtracting.
    % C3-A2:
%     EEGRef(:,1) = EEGPreRef(:,3) - EEGPreRef(:,2);
%     % C4-A1:
%     EEGRef(:,2) = EEGPreRef(:,4) - EEGPreRef(:,1);
%     % F7-A2:
%     EEGRef(:,3) = EEGPreRef(:,5) - EEGPreRef(:,2);
%     % F8-A1:
%     EEGRef(:,4) = EEGPreRef(:,6) - EEGPreRef(:,1);
%     % O1-A2:
%     EEGRef(:,5) = EEGPreRef(:,7) - EEGPreRef(:,2);
%     % O2-A1:
%     EEGRef(:,6) = EEGPreRef(:,8) - EEGPreRef(:,1);
%     
%     block = block + 1;
    %%
    % Save the referenced channel into a text file
    
    clear session
end