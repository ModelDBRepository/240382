% This program generates the equilibrium state attained by the mesocortical
% circuit for a particular value of the free parameters R_DA and D1Rsens
% when run for a sufficiently long time with the inclusion of 
% Additive Noise using the Euler Maruyama method 

% The resultant values obtained for the variables is further used 
% for the analysis of the Potential Landscape

D1Rsens=3; % D1R sensitivity  (A.U.)                         FIX THIS VALUE
R_DA=1000*0.00576;% Dopamine Releasability per seconds       FIX THIS VALUE

Ti=0;% seconds
Tf=300; % Sufficiently long time for equilibrium             FIX THIS VALUE
N=(Tf*1000)+1;
dt=(Tf-Ti)/(N-1);
Sqrt_dt=sqrt(dt);
clearvars Ti Tf;

% Constants
c1=0.009852;% no units
c2=0.018259;% no units
c3=0.001052;% no units
c4=9.375000;% no units

% Synaptic Weights
WPP_0=8.5077e03;% Hz per second
WIP=5.1613e03;% Hz per second
WPI_0=6.4570e03;% Hz per second
WPD=3.2790e03;%Hz per second

% Time Constants
tauPN=0.02;% second
tauIN_0=0.0068;% second
tauDN=0.01;% second
tauDA=0.8;% second

% Basal activities of the various neuronal populations and basal DA
% concentration in cortex
aPN_b=3;% Hz
aIN_b=9;% Hz
aDN_b=3;% Hz
DA_b=0.2;% nM

N1=1000000;% No. of samples in the ensemble

% These Initial values are the unstable equlibrium points of the variables
% which have been obtained from the Nullcline.m program


% Initial conditions
aPN=5.484567;% Unstable fixed-point value                    FIX THIS VALUE
aIN=9.213290;% Unstable fixed-point value                    FIX THIS VALUE
aDN=3.802494;% Unstable fixed-point value                    FIX THIS VALUE
DA=0.203906;% Unstable fixed-point value                     FIX THIS VALUE
D1Ract=0.109780;% Unstable fixed-point value                 FIX THIS VALUE

aPN=aPN*ones(N1,1);
aIN=aIN*ones(N1,1);
aDN=aDN*ones(N1,1);
DA=DA*ones(N1,1);
D1Ract=D1Ract*ones(N1,1);

daPN=aPN-aPN_b;
daIN=aIN-aIN_b;
daDN=aDN-aDN_b;
dDA=DA-DA_b;

% Noise Intensities associated with the aPN,aIN and aDN populations together with DA concentration respectively
Sigma_1=0.76125;
Sigma_2=0.08215;
Sigma_3=0.14256;
Sigma_4=0.0008;
    
for i=1:N-1
        f1=dt*(-(daPN./tauPN)+(WPP_0*(0.12*D1Ract+0.68).*tanh(c1*daPN))-(WIP*tanh(c2*daIN)));
        f2=dt*(-(daIN./(tauIN_0*(0.24*D1Ract+0.26)))+(WPI_0*(0.12*D1Ract+0.68).*tanh(c1*daPN)));
        f3=dt*(-(daDN./tauDN)+(WPD*tanh(c1*daPN)));
        f4=dt*(-(dDA./tauDA)+(R_DA*tanh(c3*daDN)));
            
        aPN=aPN+f1+(Sqrt_dt*Sigma_1*randn(N1,1));
        aIN=aIN+f2+(Sqrt_dt*Sigma_2*randn(N1,1));
        aDN=aDN+f3+(Sqrt_dt*Sigma_3*randn(N1,1));
        DA=DA+f4+(Sqrt_dt*Sigma_4*randn(N1,1));
            
        D1Ract=D1Rsens*tanh(c4*DA);      
end

