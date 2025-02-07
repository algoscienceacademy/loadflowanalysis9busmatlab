clc;
clear;

% Input Data based on Student ID: ET223104

Pmax = 40; % Maximum active power generation (MW)
Qmax = 20; % Maximum reactive power generation (MVAr)
Pd = 110;  % Active power demand at load buses (MW)
Qd = 12;   % Reactive power demand at load buses (MVAr)
R = 0.02;  % Line resistance (pu)
X = 0.04;  % Line reactance (pu)

% Bus Data
bus_data = [
    1 3 0   0      1.0   0; % Slack Bus
    2 2 0   0      1.05  0; % Generator Bus
    3 1 Pd  Qd     1.05   0; % Load Bus
    4 1 Pd  Qd     1.05   0; % Load Bus
    5 2 0   0      1.05  0; % Generator Bus
    6 1 Pd  Qd     1.05  0; % Load Bus
    7 2 0   0      1.05  0; % Generator Bus
    8 1 Pd  Qd     1.05   0; % Load Bus
    9 1 Pd  Qd     1.05  0; % Load Bus
];

% Line Data
line_data = [
    1 2 R X 0; % Line from Bus 1 to Bus 2
    1 4 R X 0; % Line from Bus 1 to Bus 4
    2 3 R X 0; % Line from Bus 2 to Bus 3
    3 4 R X 0; % Line from Bus 3 to Bus 4
    4 5 R X 0; % Line from Bus 4 to Bus 5
    5 6 R X 0; % Line from Bus 5 to Bus 6
    6 7 R X 0; % Line from Bus 6 to Bus 7
    7 8 R X 0; % Line from Bus 7 to Bus 8
    8 9 R X 0; % Line from Bus 8 to Bus 9
    9 1 R X 0; % Line from Bus 9 to Bus 1
];

% Convert data to Matpower format
mpc.version = '2';
mpc.baseMVA = 100;

% Bus Matrix
mpc.bus = [
    bus_data(:,1), ... % Bus Number
    bus_data(:,2), ... % Bus Type
    bus_data(:,3), ... % Pd
    bus_data(:,4), ... % Qd
    zeros(size(bus_data,1),1), ... % Gs
    zeros(size(bus_data,1),1), ... % Bs
    ones(size(bus_data,1),1)*100, ... % Area
    bus_data(:,5), ... % Vm
    bus_data(:,6), ... % Va
    ones(size(bus_data,1),1)*230, ... % BaseKV
    ones(size(bus_data,1),1), ... % Zone
    1.1*ones(size(bus_data,1),1), ... % Vmax
    0.9*ones(size(bus_data,1),1) ... % Vmin
];

% Generator Matrix
gen_bus = find(bus_data(:,2) == 2);
mpc.gen = [
    gen_bus, ... % Bus Number
    Pmax*ones(size(gen_bus)), ... % Pg
    zeros(size(gen_bus)), ... % Qg
    Qmax*ones(size(gen_bus)), ... % Qmax
    -Qmax*ones(size(gen_bus)), ... % Qmin
    ones(size(gen_bus)), ... % Vg
    100*ones(size(gen_bus)), ... % mBase
    ones(size(gen_bus)), ... % Status
    Pmax*ones(size(gen_bus)), ... % Pmax
    zeros(size(gen_bus)), ... % Pmin
];

% Branch Matrix
mpc.branch = [
    line_data(:,1:2), ... % From and To Buses
    line_data(:,3), ... % R
    line_data(:,4), ... % X
    line_data(:,5), ... % B
    999*ones(size(line_data,1),1), ... % RateA
    zeros(size(line_data,1),1), ... % RateB
    zeros(size(line_data,1),1), ... % RateC
    ones(size(line_data,1),1), ... % Tap
    zeros(size(line_data,1),1), ... % Shift Angle
    ones(size(line_data,1),1), ... % Branch Status
    -360*ones(size(line_data,1),1), ... % Minimum Angle Difference
    360*ones(size(line_data,1),1) ... % Maximum Angle Difference
];

% Call Power Flow Solver
results = runpf(mpc);

% Display Results
disp('Power Flow Results:');
disp(results);
