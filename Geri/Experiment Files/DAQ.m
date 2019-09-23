
%% Constant
rad2deg = 180/pi;
deg2rad = 1/rad2deg;
hz2rps = 2*pi;
rps2hz = 1/hz2rps;

pathSave = '../Data/';
fileSave = fullfile(pathSave, 'Geri_run28.mat');
pointDefList = {NaN, 2, 25, 28}; % Predefined GVT nodes for Force, Accel1, and Accel2

% DAQ Setup - This is for the cDAQ Chasis with 9269 and 9229
chanOutNameList = {'DriveOut'};
chanOutNumList = [0];
chanInNameList = {'DriveIn', 'Force', 'Accel1', 'Accel2'};
chanInNumList = [0, 1, 2, 3];
chanInMult = [1, 10, 100, 100];

% Define the Excitation
timeDuration_s = 120;
freqExcStart_Hz = 1;
freqExcEnd_Hz = 35;
phaseZero_deg = 0;
ampExcStart_V = 1;
ampExcEnd_V = 1;
ampExcOffset = 0;

% Create the Excitation
freqSample_Hz = 2000;
timeSample_s = 1/freqSample_Hz;
timeExc_s = [0 : timeSample_s : timeDuration_s]';

ampExc_V = ((ampExcEnd_V - ampExcStart_V) * (timeExc_s / timeDuration_s)) + ampExcStart_V;
% ampExc_V = ((ampExcStart_V - ampExcEnd_V)/2 * cos(pi * timeExc_s / timeDuration_s)) + (ampExcStart_V + ampExcEnd_V)/2;

freqExc_hz = ((freqExcEnd_Hz - freqExcStart_Hz) * (timeExc_s / (2 * timeDuration_s))) + freqExcStart_Hz;
signalExc = ampExcOffset + ampExc_V .* sin((freqExc_hz * hz2rps) .* timeExc_s + (phaseZero_deg * deg2rad));

figure; plot(timeExc_s, signalExc)

%%
devListObj = daq.getDevices;
daqSessionObj = daq.createSession('ni');
%daqSessionObj = daq.createSession('National Instruments');

daqSessionObj.Rate = freqSample_Hz;

% Setup the DAQ Channels
daqSessionObj.addAnalogOutputChannel(devListObj(1).ID, chanOutNumList, 'Voltage');
daqSessionObj.addAnalogInputChannel(devListObj(2).ID, chanInNumList, 'Voltage');


%% Create the output signal

% Put the data in the output queue
queueOutputData(daqSessionObj, signalExc);

% Create listeners
lstnOutHandle = addlistener(daqSessionObj, 'DataRequired', @(src, event) src.queueOutputData(signalExc));
lstnInHandle = addlistener(daqSessionObj, 'DataAvailable', @plotData);
% fid1 = fopen('log.bin', 'a');
% lstnInHandle = addlistener(daqSessionObj, 'DataAvailable', @(src, event)logData(src, event, fid1));


%% Run the DAQ
prepare(daqSessionObj); pause(1);
[signalIn, timeIn_s] = startForeground(daqSessionObj);
% startBackground(daqSessionObj);


%% Cleanup
% save a file
save(fileSave, 'timeIn_s', 'signalIn', 'chanInNameList', 'pointDefList', '-mat');

% for indxSig = 1:length(chanInNameList)
%     assignin('base', chanInNameList{indxSig}, signalIn(:,indxSig)); 
% end


% Cleanup
delete(lstnOutHandle);
delete(lstnInHandle);
release(daqSessionObj)


%%
figure; plot(timeIn_s, signalIn);

%%
if 1

    freqSampleIn_Hz = round(1/mean(diff(timeIn_s)));
    winType = 'cosi'; smoothFactor = 9;
     [xxP1, ~, freq] = PsdEst(signalIn, freqSampleIn_Hz, winType, smoothFactor);
     [freq, gain_dB, phase_deg, xyC, xyT, xxP, yyP, xyP] = TransFunc(signalIn(:,2), signalIn(:,3:4), [], freqSampleIn_Hz, winType, smoothFactor);

%     PsdPlot(freq, xxP, 'Hz');
    PsdPlot(freq, xxP1, 'Hz');
    xlim([1, 100]); legend(chanInNameList, 'Interpreter', 'none')
    
    BodePlot(freq, gain_dB, phase_deg, xyC);
    xlim([1, 100]); legend(chanInNameList{3:4}, 'Interpreter', 'none')
    
end
