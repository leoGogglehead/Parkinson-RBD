% This script load data and annotations from the portal, analyzes the data,
% performs clustering, then uploads the results back to the portal.

clearvars -except session allData;
close all force; clc; tic;
% addpath('C:\Users\jtmoyer\Documents\MATLAB\');
% addpath(genpath('C:\Users\jtmoyer\Documents\MATLAB\libsvm-3.18'));
addpath(genpath('F:\Grad School\Github\ieeg-matlab-1.8.3'));

%% Define constants for the analysis
study = 'chahine';  % 'dichter'; 'jensen'; 'pitkanen'
runThese = [1:3]; % training data = 2,3,19,22,24,25,26; 1:5,7:12,14:34
params.channels = 2:7;
params.label = 'sleep';
params.technique = 'powerbands';
params.startTime = '1:01:30:00';  % day:hour:minute:second, in portal time
params.endTime = '1:09:25:00'; % day:hour:minute:second, in portal time
params.lookAtArtifacts = 0; % lookAtArtifacts = 1 means keep artifacts to see what's being removed

eventDetection = 1;
unsupervisedClustering = 0;
addAnnotations = 0;  
scoreDetections = 0;
boxPlot = 0;

%% Load investigator data key
switch study
  case 'dichter'
    rootDir = 'Z:\public\DATA\Animal_Data\DichterMAD';  % where original data is sotred
    runDir = 'C:\Users\jtmoyer\Documents\MATLAB\P05-Dichter-data';  % investigator specific directory, for .xls, .doc files etc.
  case 'jensen'
    rootDir = 'Z:\public\DATA\Animal_Data\Frances_Jensen';  % where original data is sotred
    runDir = 'C:\Users\jtmoyer\Documents\MATLAB\P04-Jensen-data';
  case 'chahine'
%     rootDir = 'Z:\public\DATA\Human_Data\SleepStudies';   
    runDir = 'F:\Grad School\Github\P03-Chahine-data';
  case 'pitkanen'
    addpath(genpath('C:\Users\jtmoyer\Documents\MATLAB\P01-Pitkanen-data')); 
end
addpath(genpath(runDir));
fh = str2func(['f_' study '_data_key']);
dataKey = fh();
fh = str2func(['f_' study '_params']);
params = fh(params)
fh = str2func(['f_' study '_define_features']);
featFn = fh();


%% Establish IEEG Sessions
% Establish IEEG Portal sessions.
% Load session if it doesn't exist.
if ~exist('session','var')  % load session if it does not exist
  addpath(genpath('F:\Grad School\Github'));
  session = IEEGSession(dataKey.portalId{runThese(1)},'gogglehead','gog_ieeglogin.bin');
%   session = IEEGSession(dataKey.portalId{runThese(1)},'jtmoyer','jtm_ieeglogin.bin','qa');
for r = 1 : length(runThese)
    session.openDataSet(dataKey.portalId{runThese(r)});
end
else    % clear and throw exception if session doesn't have the right datasets
  if (~strcmp(session.data(1).snapName, dataKey.portalId{runThese(1)})) || ...
      (length(session.data) ~= length(runThese))
    clear all;
    error('Need to clear session data.  Re-run the script.');
  end 
end

%% Feature detection 
fig_h = 1;
if eventDetection
%    
%   for r = 1:length(runThese)
for r = 1 : length(runThese)
    fprintf('Running %s_%s on: %s\n',params.label, params.technique, session.data(r).snapName);
    if r == 2
        params.endTime = '1:10:00:00';
    end 
    if r == 3
        params.channels = 1 : 6;
    end 

    f_eventDetection(session.data(r), params, runDir, dataKey(runThese(r),:));
    if addAnnotations
      f_addAnnotations(session.data(r), params, runDir); 
    end;
    toc
  end
end

