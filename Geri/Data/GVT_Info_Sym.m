%% Outputs GVT parameters
% This script contains the parameters of the experiment and saves them
% as a structure Info
% 
% Info has following fields
%   - Fs:= Sampling frequency of the experiment
%   - Run2Accel:= run-by-2 matrix with Run2Accel(i,j) providing
%         the accelerometer number for measurement j of run i.
%   - Accel2Run: Naccel-by-2 matrix with Accel2Run(i,1:2) providing
%         the [Run #, Measurement #] for accelometer i.
%   - AccelPos:= Naccel-by-2 matrix where  AccelPos(i,1) and
%         AccelPos(i,2) are the (X,Y) positions of accel i measured
%         in inches.  The coordinates are located at the aircraft nose
%         with Y pointing aft and X pointing left (Hence Z is up).
%   - ShakerPos:= 1-by-2 matrix where ShakerPos(1) and ShakerPos(2) are
%       the (X,Y) positions of the shaker attachment point.  The 
%       coordinates are located at the aircraft nose with Y pointing aft
%       and X pointing left (Hence Z is up).
%   - Nrun := Number of runs in the experiment
%   - Nmeas := Number of measurements in each run
%   - Naccel := Number of total acceelerations measurements
%   - Force_V2lb := Conversion factor from measured voltage to force (Lbs)
%   - Accel_V2g := Conversion factor from measured voltage to acceleration
%       (g)
%   - FreqWin+Hz := Target frequency window of the experiment
%   - ForwardAccel := Order of the accelerometers on the leading edge from
%      left wing tip to the right wing tip
%   - AftAccel := Order of the accelerometers on the trailing edge from the
%       left wing tip to the right wing tip

%% Sample Info
Fs = 2000;                      % Sampling freq, Hz

%% Calibrations
% Force: 0.4684 V/lb , Accels: 1.028 V/g
Force_V2lb = 0.4684;
Accel_V2g = 1.018;

%% Accel Mapping
% The data consists of Nrun experiments with each experiment providing
% Nmeas accelerometer measurements.  The total number of accelerometer
% measruements is thus Naccel=Nrun*Nmeas.   The accels are numbered
% from 1 to Naccel and the position of each accelerometer is provided
% in the array AccelPos below.  The mapping between accel numbering
% and experiment is provided by two variables:
%   A) Run2Accel := Nrun-by-2 matrix with Run2Accel(i,j) providing
%         the accelerometer number for measurement j of run i.
%   B) Accel2Run := Naccel-by-2 matrix with Accel2Run(i,1:2) providing
%         the [Run #, Measurement #] for accelometer i.
Run2Accel = [1 11;
             2 12;
             3 13;
             4 14;
             5 15;
             6 16;
             7 17;
             8 18;
             9 19;
             10 20;
             23 26;
             24 27;
             25 28;
             22 21;
             ];

[Nrun,Nmeas] = size(Run2Accel);
Naccel= Nrun*Nmeas;
Accel2Run = zeros(Naccel,2);

for i=1:Naccel;
    [ridx,cidx]=find(Run2Accel==i);
    Accel2Run(i,:) = [ridx cidx];
end


%% Accel Positions
% As noted above, the accelerometer measurements recorded in all
% experimental runs are numbered from 1 to Naccel.  The positions
% of these accelerometers is provided by:
%     AccelPos := Naccel-by-2 matrix where  AccelPos(i ,1) and
%         AccelPos(i,2) are the (X,Y) positions of accel i measured
%         in inches.  The coordinates are located at the aircraft nose
%         with Y pointing aft and X pointing left (Hence Z is up).


AccelPos = [15.00 18.00;
            15.00 24.25;
            26.00 22.25;
            26.00 28.50;
            35.00 26.00;
            35.00 32.25;
            44.25 29.75;
            44.25 36.00;
            53.375 33.50;
            53.375 39.75;
            -15.00 18.00;
            -15.00 24.25;
            -26.00 22.50;
            -26.00 28.75;
            -35.00 26.25;
            -35.00 32.50;
            -44.25 29.75;
            -44.25 36.00;
            -53.375 33.50;
            -53.375 39.75;
            0.00 2.50;
            0.00 23.50;
            57.375 34.375;
            57.375 40.625;
            59.75 46.00;
            -57.375 34.500;
            -57.375 40.825;
            -59.75 46.00;
            ];
        


%% Shaker Position
% The shaker position remains same for all the runs for this particular
% experiment.
%       ShakerPos := 1-by-2 matrix where ShakerPos(1) and ShakerPos(2) are
%       the (X,Y) positions of the shaker attachment point.  The 
%       coordinates are located at the aircraft nose with Y pointing aft
%       and X pointing left (Hence Z is up).
ShakerPos = [0.0 30.375];

%% Frequency Range
% The target frequency range for which the experiment was conducted. This
% is usually different from the actual range of the input frequencies
% because the aircraft needs to settle down to a steady state before a
% proper reading can be taken. For example for a traget range of  [3, 35]
% Hz, the actual input range might be [1, 35] Hz.


FreqWin_Hz = [3 35];

%% Accel order
% Defines the order of the accelerometers on the aircarft
%       ForwardAccel := Accelerometer positions on the leading edge from
%          the left wing tip to the right wing tip
%       AftAccel := Accelerometer positions on the trailing edge from the
%          left wing tip to the right wing tip

ForwardAccel = [26 19:-2:11 21 1:2:9 23];
AftAccel = [28 27 20:-2:12 22 2:2:10 24 25];

%% Store Experiment Info

Info.Fs = Fs;
Info.Run2Accel = Run2Accel;
Info.Accel2Run = Accel2Run;
Info.AccelPos = AccelPos;
Info.ShakerPos = ShakerPos;
Info.Nrun = Nrun;
Info.Nmeas = Nmeas;
Info.Naccel = Naccel;
Info.Force_V2lb = Force_V2lb;
Info.Accel_V2g = Accel_V2g;
Info.FreqWin_Hz = FreqWin_Hz;
Info.ForwardAccel = ForwardAccel;
Info.AftAccel = AftAccel;
