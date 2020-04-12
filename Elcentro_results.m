clc, clear, close all

real_time = 'n';
eq_intensity = .4;           % EQ Intensity 
                             %   1: El centro, 2: Kobe, 3: Morgan,  4: Chirp input
f_ini = 0;                   % Chirp initial freq. [Hz] 
f_end = 10;                  % Chirp end freq. [Hz]

fs = 4096;              % Sampling frequency [Hz]
dt_rths = 1/fs;         % Sampling period [sec]
load_system('vRTHS_MDOF_SimRT.slx')           
switch lower(real_time)
    case 'y'
        set_param('vRTHS_MDOF_SimRT/Real-Time Synchronization','Commented','off')
        set_param('vRTHS_MDOF_SimRT/Missed Ticks','Commented','off')      
    case 'n'
        set_param('vRTHS_MDOF_SimRT/Real-Time Synchronization','Commented','on')
        set_param('vRTHS_MDOF_SimRT/Missed Ticks','Commented','on')
end

num_add = 0;
num_t = 1+num_add;
E_sw=1; Building_c=4; ii=1;
F1_input_file
F2_controller

set_param(bdroot,'SolverType','Fixed-step','Solver','ode4','StopTime','tend','FixedStep','dt_rths')
sim ('vRTHS_MDOF_SimRT')
RTHS_SMC=Num_resp.Data;
Ref_Resp = lsim(sys_r,EQ_input,t);

load_system('vRTHS_MDOF_SimRT_PI.slx')           
switch lower(real_time)
    case 'y'
        set_param('vRTHS_MDOF_SimRT_PI/Real-Time Synchronization','Commented','off')
        set_param('vRTHS_MDOF_SimRT_PI/Missed Ticks','Commented','off')      
    case 'n'
        set_param('vRTHS_MDOF_SimRT_PI/Real-Time Synchronization','Commented','on')
        set_param('vRTHS_MDOF_SimRT_PI/Missed Ticks','Commented','on')
end
F2_controller_PI

set_param(bdroot,'SolverType','Fixed-step','Solver','ode4','StopTime','tend','FixedStep','dt_rths')
sim ('vRTHS_MDOF_SimRT_PI')
RTHS_PI=Num_resp.Data;

%% plots
figure; set(gcf,'Position',[0 0 900 520]);
for i=1:3
    subplot(3,1,i);
    plot(t,Ref_Resp(:,4-i)*1000,'k','linewidth',2); hold on;
    plot(t,RTHS_PI(:,4-i)*1000,'--r','linewidth',1.5); grid on;
    plot(t,RTHS_SMC(:,4-i)*1000,':c','linewidth',2);
    xlim([6,20]);
    axesH = gca;
    set(axesH,'fontsize',16,'TickLabelInterpreter','latex');
    axesH.XAxis.TickLabelFormat ='\\textbf{%g}';axesH.YAxis.TickLabelFormat ='\\textbf{%g}';
end

subplot(3,1,1);
set(gca,'YTick',-10:5:10);
ylabel('\textbf{${\bf 3^{rd}}$ floor (mm)}','fontsize',16,'interpreter','latex');
subplot(3,1,2);
set(gca,'YTick',-10:5:10);
ylabel('\textbf{${\bf 2^{nd}}$ floor (mm)}','fontsize',16,'interpreter','latex');
subplot(3,1,3);
ylim([-6,6]);set(gca,'YTick',-6:3:6);
ylabel('\textbf{${\bf 1^{st}}$ floor (mm)}','fontsize',16,'interpreter','latex');
xlabel('\textbf{Time (s)}','fontsize',16,'interpreter','latex');
legend({'\textbf{Reference model}','\textbf{PI-P}','\textbf{SMC}'},...
    'fontsize',16,'interpreter','latex','location','Northeast','orientation','horizontal');
% print -depsc F_ELcentro_results;
