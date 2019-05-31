%% NULLCLINE PLOT
% This program generates the aPN and D1Ract nullcline plot

%% PARAMETERS
% Free Parameters
R_DA=0.00576e3;%nM per second                               FIX THIS VALUE
D1Rsens=3;% D1 Receptor Sensitivity (A.U.)                  FIX THIS VALUE

N=25001;% Number of discrete points

aPN_b=3;% basal pyramidal neuron activity in Hz

aPN=linspace(aPN_b,25,N); 
D1Ract=linspace(0,2,N);

aPN_eqm=zeros(1,N);

% Constants
c1=0.009852;% no units
c2=0.018259;% no units
c3=0.001052;% no units
c4=9.375000;% no units

WPP_0=8.5077e03;% Hz per second
WIP=5.1613e03;% Hz per second
WPI_0=6.4570e03;% Hz per second
WPD=3.2790e03;%Hz per second


tauPN=0.02;% second
tauIN_0=0.0068;% second
tauDN=0.01;% second
tauDA=0.8;% second

daPN=aPN-aPN_b;% Hz

%% aPN NULLCLINE

for i=1:length(D1Ract)
    
    Neg=(daPN./tauPN)+WIP*tanh(c2*(tauIN_0*(0.24*D1Ract(i)+0.26))*(WPI_0*(0.12*D1Ract(i)+0.68))*(tanh(c1*daPN)));
    Pos=(WPP_0*(0.12*D1Ract(i)+0.68))*tanh(c1*daPN);
    
    A_PN=Pos-Neg;
    clearvars Pos Neg;
    Y_pos=find(A_PN>=0);
    Y=numel(Y_pos);
    
    if Y>1
    aPN_eqm(i)=daPN(Y_pos(end));                       % Tells us the position number, As Y(1)=2 The point is one number behind
    end                                             % Here we know only 2 points of intersection exists 0 and the point being calculated
    
end

aPN_nullcline=aPN_eqm+aPN_b;

%% D1Ract NULLCLINE

Index_temp=max(find(D1Ract<=D1Rsens-0.001));                % To keep infinity in check
D1Ract_temp=D1Ract(1:Index_temp);

D1Ract_nullcline=((1/c1)*atanh((1/(c3*tauDN*WPD))*atanh((1/(c4*tauDA*R_DA))*atanh(D1Ract_temp/D1Rsens))))+aPN_b; % values of aPN

%% PLOT

plot(D1Ract,aPN_nullcline,'b');
hold on;box off;
plot(D1Ract_temp,D1Ract_nullcline,'g')
axis([0 2 0 25])
xlabel('D1 Receptor Activation D1R_{act} (A.U.)','FontWeight','bold','FontSize',9);
ylabel('Activity of Pyramidal population a_{PN} (Hz)','FontWeight','bold','FontSize',9);
title('Equilibrium points for D1R_{sens} 3','FontWeight','bold','FontSize',9);
