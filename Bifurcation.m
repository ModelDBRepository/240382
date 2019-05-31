
run('Nullcline.m');
clearvars -except aPN_nullcline D1Ract;
close all;

%% PARAMETERS
% Free Parameter
D1Rsens=3; % D1 Receptor Sensitivity (A.U.)                 FIX THIS VALUE

R_DA=1000*linspace(0,0.05,5001); % nM per second 

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

%% VARIABLES

Index_temp=max(find(D1Ract<=D1Rsens-0.001));                % So that infinity is kept in check
D1Ract_temp=D1Ract(1:Index_temp);
aPN_eqm_temp=aPN_nullcline(1:Index_temp);

% Storing the three equlibrium points as lower, mid and upper which
% represents the lower stable, unstable and higher stable points respectively  
aPN_lower_eqm=aPN_b*ones(1,length(R_DA));
aPN_mid_eqm=zeros(1,length(R_DA));
aPN_upper_eqm=zeros(1,length(R_DA));

D1Ract_lower_eqm=zeros(1,length(R_DA));
D1Ract_mid_eqm=zeros(1,length(R_DA));
D1Ract_upper_eqm=zeros(1,length(R_DA));

%% BIFURCATION SCHEME

for i=1:length(R_DA)
    D1Ract_nullcline=((1/c1)*atanh((1/(c3*tauDN*WPD))*atanh((1/(c4*tauDA*R_DA(i)))*atanh(D1Ract_temp/D1Rsens))))+aPN_b;% values of aPN
    Differ=aPN_nullcline-D1Ract_nullcline;
    Index_pos=find(Differ>=0);
    
    if length(Index_pos)>1
        aPN_mid_eqm(i)=aPN_nullcline(Index_pos(2));
        aPN_upper_eqm(i)=aPN_nullcline(Index_pos(end));
        
        D1Ract_mid_eqm(i)=D1Ract(Index_pos(2));
        D1Ract_upper_eqm(i)=D1Ract(Index_pos(end));
    end
end


R_DA_trunctd=R_DA;

Index_trunc=max(find(aPN_mid_eqm==0));
R_DA_trunctd(1:Index_trunc)=[];
aPN_mid_eqm(1:Index_trunc)=[];
aPN_upper_eqm(1:Index_trunc)=[];
D1Ract_mid_eqm(1:Index_trunc)=[];
D1Ract_upper_eqm(1:Index_trunc)=[];


daPN_mid_eqm=aPN_mid_eqm-aPN_b;
aIN_mid_eqm=((tauIN_0*(0.24*D1Ract_mid_eqm+0.26)).*(WPI_0*(0.12*D1Ract_mid_eqm+0.68)).*tanh(c1*daPN_mid_eqm))+aIN_b;
daDN_mid_eqm=tauDN*WPD*tanh(c1*daPN_mid_eqm);
aDN_mid_eqm=daDN_mid_eqm+aDN_b;
DA_mid_eqm=(tauDA*(R_DA_trunctd.*tanh(c3*daDN_mid_eqm)))+DA_b;


daPN_upper_eqm=aPN_upper_eqm-aPN_b;
aIN_upper_eqm=((tauIN_0*(0.24*D1Ract_upper_eqm+0.26)).*(WPI_0*(0.12*D1Ract_upper_eqm+0.68)).*tanh(c1*daPN_upper_eqm))+aIN_b;
daDN_upper_eqm=tauDN*WPD*tanh(c1*daPN_upper_eqm);
aDN_upper_eqm=daDN_upper_eqm+aDN_b;
DA_upper_eqm=(tauDA*(R_DA_trunctd.*tanh(c3*daDN_upper_eqm)))+DA_b;

R_DA_trunctd=R_DA_trunctd/1000;

Matrix=[R_DA_trunctd' aPN_mid_eqm' aIN_mid_eqm' aDN_mid_eqm' DA_mid_eqm' D1Ract_mid_eqm' aPN_upper_eqm' aIN_upper_eqm' aDN_upper_eqm' DA_upper_eqm' D1Ract_upper_eqm'];

aIN_lower_eqm=aIN_b*ones(1,length(R_DA));
aDN_lower_eqm=aDN_b*ones(1,length(R_DA));
DA_lower_eqm=DA_b*ones(1,length(R_DA));
%% BIFURCATION PLOTS
% Equlibrium Points for the Pyramidal Population Activity aPN is presented
% against the Bifurcation Parmeter R_DA
figure(1);
plot(R_DA,aPN_lower_eqm,'k','LineStyle','--');
hold on;box off;
plot(Matrix(:,1),Matrix(:,2),'g','LineStyle','--');
plot(Matrix(:,1),Matrix(:,7),'g','LineStyle','-');
xlabel('R_{DA} (nM.ms^{-1})','FontWeight','bold','FontName','Arial');
ylabel('a_{PN} (Hz)','FontWeight','bold','FontName','Arial');
axis([0 0.05 0 27])

figure(2);
plot(R_DA,aIN_lower_eqm,'k','LineStyle','--');
hold on;box off;
plot(Matrix(:,1),Matrix(:,3),'g','LineStyle','--');
plot(Matrix(:,1),Matrix(:,8),'g','LineStyle','-');
xlabel('R_{DA} (nM.ms^{-1})','FontWeight','bold','FontName','Arial');
ylabel('a_{IN} (Hz)','FontWeight','bold','FontName','Arial');
axis([0 0.05 8.5 14])

figure(3);
plot(R_DA,aDN_lower_eqm,'k','LineStyle','--');
hold on;box off;
plot(Matrix(:,1),Matrix(:,4),'g','LineStyle','--');
plot(Matrix(:,1),Matrix(:,9),'g','LineStyle','-');
xlabel('R_{DA} (nM.ms^{-1})','FontWeight','bold','FontName','Arial');
ylabel('a_{DN} (Hz)','FontWeight','bold','FontName','Arial');
axis([0 0.05 2.5 11])

figure(4);
plot(R_DA,DA_lower_eqm,'k','LineStyle','--');
hold on;box off;
plot(Matrix(:,1),Matrix(:,5),'g','LineStyle','--');
plot(Matrix(:,1),Matrix(:,10),'g','LineStyle','-');
xlabel('R_{DA} (nM.ms^{-1})','FontWeight','bold','FontName','Arial');
ylabel('[DA] (nM)','FontWeight','bold','FontName','Arial');
axis([0 0.05 0.19 0.35])

figure(5);
plot(R_DA,D1Ract_lower_eqm,'k','LineStyle','--');
hold on;box off;
plot(Matrix(:,1),Matrix(:,6),'g','LineStyle','--');
plot(Matrix(:,1),Matrix(:,11),'g','LineStyle','-');
xlabel('R_{DA} (nM.ms^{-1})','FontWeight','bold','FontName','Arial');
ylabel('D1R_{act} (A.U.)','FontWeight','bold','FontName','Arial');
axis([0 0.05 0 2])