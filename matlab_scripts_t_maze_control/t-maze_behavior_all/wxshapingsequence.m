%% wxshapingsequence
 % Runs the shaping sequence for a given side of the T-maze
 % JL Alatorre-Warren
 
function [daqDevice, ...
          daqSession, ...
          mainLogbook, ...
          startTimeForcedRun, ...
          endTimeForcedRun] = wxshapingsequence(currentSide, ...
                                                cameraNumber, ...
                                                mainLogbook, ...
                                                daqDevice, ...
                                                daqSession, ...
                                                roi01, ...
                                                roi02, ...
                                                roi06, ...
                                                secondsInsideStartBoxAfterForcedRun, ...
                                                optionWhiteNoiseInsideStartBoxAfterForcedRun, ...  
                                                optionUseStartGateAfterFreeingTheMouse, ...
                                                optionLickToOpenValve, ...
                                                laserSelection, ...
                                                pathFlags, ...
                                                currentInhibitionStatus)
                                                                                           
% Get timestamp: start of forced run
startTimeForcedRun = clock;

% Setup inhibition options at InhibitionStageStart
mainLogbook = wxinhibitionsetup(laserSelection, ...
                                'InhibitionStageStart', ...
                                pathFlags, ...
                                currentInhibitionStatus, ...
                                mainLogbook);
                                         
% Set the mouse free
mainLogbook = wxsetthemousefree(currentSide, mainLogbook);

% Detect mouse in ROI02 (main corridor)
mainLogbook = wxroidetection(cameraNumber,roi02,'roi02',mainLogbook);

 % Close start gate if optionIgnoreStartGateAfterFreeingTheMouse is 0
if optionUseStartGateAfterFreeingTheMouse == 1
  mainLogbook = wxservo('start','close',mainLogbook);
end                                        
% If optionLickToOpenValve is 1, the mouse opens the valve by licking it
if optionLickToOpenValve == 1
  mainLogbook = wxlickingdetection(daqSession,currentSide,mainLogbook);
end

% Open valve of the next side
% Add and remove channels from NI box
[daqDevice, daqSession, mainLogbook] = wxopenvalve(currentSide, ...
                                                   daqDevice, ...
                                                   daqSession, ... 
                                                   mainLogbook);

% Detect mouse licking in valves
mainLogbook = wxlickingdetection(daqSession,currentSide,mainLogbook);

% Detect mouse in ROI06 (main corridor)
mainLogbook = wxroidetection(cameraNumber,roi06,'roi06',mainLogbook);

% Setup inhibition options at InhibitionStageVertex
mainLogbook = wxinhibitionsetup(laserSelection, ...
                                'InhibitionStageVertex', ...
                                pathFlags, ...
                                currentInhibitionStatus, ...
                                mainLogbook);

% Open start gate if optionIgnoreStartGateAfterFreeingTheMouse is 0
if optionUseStartGateAfterFreeingTheMouse == 1
  mainLogbook = wxservo('start','open',mainLogbook);
end

% Detect mouse in ROI02 (main corridor)
mainLogbook = wxroidetection(cameraNumber,roi02,'roi02',mainLogbook);

% Close the gate of the current arm side
mainLogbook = wxservo(currentSide,'close',mainLogbook);

% Detect mouse in ROI01 (start box)
mainLogbook = wxroidetection(cameraNumber,roi01,'roi01',mainLogbook);

% Close start gate
mainLogbook = wxservo('start','close',mainLogbook);

% Get timestamp: end of forced run
endTimeForcedRun = clock;

% Keep the mouse inside the start box after the forced run and play white noise in the speakers
wxdelayperiod(secondsInsideStartBoxAfterForcedRun,optionWhiteNoiseInsideStartBoxAfterForcedRun);