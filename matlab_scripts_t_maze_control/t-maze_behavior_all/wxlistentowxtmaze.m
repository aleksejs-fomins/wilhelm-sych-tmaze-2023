%% wxlistentowxtmaze
 % Get relevant information from wxtmaze
 % JL Alatorre-Warren

function [pathRoot,...
          pathData,...
          pathRois,...
          pathTrials,...
          pathTrialList,...
          structureOfTrials,...
          listOfTrials,...
          trialName,...
          pathCurrentTrial,...
          mouseName,...
          experimentName,...
          timestampVector,...
          dateString,...
          timeString] = wxlistentowxtmaze %#ok<*STOUT>
 
% Get main directories
[pathRoot, ...
 pathData, ...
 pathRois, ...
 pathTrials, ...
 pathTrialList] = wxmaindirectories;

% Get current trial
structureOfTrials = dir(pathTrialList);
listOfTrials      = ({structureOfTrials(3:end).name})';
trialName         = char(listOfTrials(end));
pathCurrentTrial  = [pathTrialList '/' trialName];

% Load relevant workspace from the wxtmaze MATLAB session
load([pathCurrentTrial '/' 'variables.mat'],...
     'mouseName',...
     'experimentName',...
     'timestampVector',...
     'dateString',...
     'timeString');