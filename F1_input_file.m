%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                Entire 3-story Building Information                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose a partitioning case:
%     There are 4 default cases in the Building cases folder. However, 
%     the user may create its own cases using Reference_def.m 
% NOTE: This portion of the file should not be modified.

if ii == 1
%     disp('-------------------------')
%     disp('Processing ...')
    load(strcat('./Building cases/Case_',num2str(Building_c)))
    nom = 0;
else
    nom = 1;
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Partitioning of RTHS                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: This portion of the file should not be modified.
m_e     = 29.13;
k_e     = 1190e3;
z_e     = .0097; 
ME = zeros(n);
ME(1,1) = m_e;
KE      = zeros(n);
KE(1,1) = k_e + 50e3 *nom *randn(1,1);
CE = zeros(n);
c_e = 2*z_e*m_e*sqrt(KE(1,1)/m_e);
CE(1,1) = c_e;

% NUMERICAL SUBSTRUCTURE
MN = M-ME;
KN = K-KE;
CN = C-CE;   

% State Space form  
iota = ones(n,1);
A_ns = [...
    zeros(n) eye(n);
    -MN\KN -MN\CN];
B_ns = [...
    zeros(n,1)      zeros(n); 
    -(MN\M)*iota    -inv(MN)];
C_ns = [...
    eye(n)              zeros(n);
    zeros(n)            eye(n);
    -MN\KN              -MN\CN];

%%%%%% D_ns is changed by Hongwei Li %%%%%%%%%
% D_ns = [...
%     zeros(n,1)            zeros(n); 
%     zeros(n,1)            zeros(n); 
%     (-MN\M + eye(n))*iota    -inv(MN)];     % for TOTAL acc

D_ns = [...
    zeros(n,1)      zeros(n); 
    zeros(n,1)      zeros(n); 
    -(MN\M)*iota    -inv(MN)];     % for relative acc
%%%%%% D_ns is changed by Hongwei Li %%%%%%%%%

sys_num = ss(A_ns,B_ns,C_ns,D_ns);

% damp(sys_num);
% save('SYS_num.mat','sys_num')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Actuator parameters                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: This portion of the file should not be modified.

mm2m = 1/1000;
gain = 1.0261;
a1_beta0 = 2.1283e+13;
a2 = 4.2297e+06;

% Generate values from a normal distribution with mean (nominal) 
% value and standard deviation.  Seed the random number to produce a 
% predictable sequence of numbers. Otherwise, use rng('shuffle').
                     
if ii == 1, seed = rng(123);
else
    seed = rng('shuffle'); 
end

beta1   = 425        + 3.3   * nom *randn(1,1);
beta2   = 9.9976e+04 + 3.3e3 * nom *randn(1,1);
a3      = 3.3        + 1.3   * nom *randn(1,1);

s = tf('s');
Gest = tf([1],[ME(1,1) CE(1,1) KE(1,1)]);
Ga = tf([1],[1 a3]);
Gs = tf([a1_beta0],[1 beta1 beta2]);
Gcsi = a2*s;
G0 = feedback(Ga*Gest,Gcsi,-1);
G_plant = gain*feedback(Gs*G0,1,-1);

G_pp = ss(G_plant);
Ga_d = ss(Ga);
Gs_d = ss(Gs);

% save('Plant','G_plant','dt_rths')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     General Simulation Parameter                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% NOTE: This portion of the file should not be modified.

switch E_sw
    case 1
        load('ElCentroAccelNoScaling')              % UNITS: [m/s^2]
        tend = ElCentroAccel(1,end);                % Earthquake Ending Time
%         set_param('vRTHS_MDOF_SimRT2014a/GROUND ACCELERATION/RECORD /Chirp Signal','Commented','on')
    case 2
        load('KobeAccelNoScaling')                  % UNITS: [m/s^2]
        tend = KobeAccel(1,end);                    % Earthquake Ending Time
%         set_param('vRTHS_MDOF_SimRT2014a/GROUND ACCELERATION/RECORD /Chirp Signal','Commented','on')
    case 3
        load('MorganAccelNoScaling')                % UNITS: [m/s^2]
        tend = MorganAccel(1,end);                  % Earthquake Ending Time
%         set_param('vRTHS_MDOF_SimRT2014a/GROUND ACCELERATION/RECORD /Chirp Signal','Commented','on')
    otherwise
%         set_param('vRTHS_MDOF_SimRT2014a/GROUND ACCELERATION/RECORD /Chirp Signal','Commented','off')
        f_ini = .1;                                 % Chirp initial freq. [Hz] 
        f_end = 40;                                 % Frequency at target time [Hz]
        tend  = 90;                                 % Target time [sec]
end

% Note: A zero vector of aroud 10 sec has been added to each earthquake to
%       to obtain a attenuated response of the system.        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Sensor RMS noise (Displacement transducer)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rms_noise_DT = 6.25e-14;         % 
Seed_snr = rng(seed);           % Random number generator for noise
Gsnsr_DT = 1;                   % Sensor Gain


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set Sensor RMS noise (Force transducer)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rms_noise_FT = 1.16e-3;            % 
Seed_snr = rng(seed);           % Random number generator for noise
Gsnsr_FT = 1;                   % Sensor Gain


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SET UP A/D and D/A CONVERTERS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Saturation limits 
sat_limit_upper = +3.8;         % Volts
sat_limit_lower = -3.8;         % Volts
% Quantization interval
quantize_int = 1 / 2^18;        % 18 bit channel

