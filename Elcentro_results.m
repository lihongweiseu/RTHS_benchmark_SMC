clc, clear, close all

real_time = 'n';
eq_intensity = .4;           % EQ Intensity 
                             %   1: El centro, 2: Kobe, 3: Morgan,  4: Chirp input
f_ini = 0;                   % Chirp initial freq. [Hz] 
f_end = 10;                  % Chirp end freq. [Hz]

fs = 4096;              % Sampling frequency [Hz]
dt_rths = 1/fs;         % Sampling period [sec]
num_add = 0;
num_t = 1+num_add;
E_sw=1; Building_c=4; ii=1;
F1_input_file

load_system('vRTHS_MDOF_SimRT_PI.slx')
load_system('vRTHS_MDOF_SimRT.slx')
switch lower(real_time)
    case 'y'
        set_param('vRTHS_MDOF_SimRT_PI/Real-Time Synchronization','Commented','off')
        set_param('vRTHS_MDOF_SimRT_PI/Missed Ticks','Commented','off')
        set_param('vRTHS_MDOF_SimRT/Real-Time Synchronization','Commented','off')
        set_param('vRTHS_MDOF_SimRT/Missed Ticks','Commented','off')
    case 'n'
        set_param('vRTHS_MDOF_SimRT_PI/Real-Time Synchronization','Commented','on')
        set_param('vRTHS_MDOF_SimRT_PI/Missed Ticks','Commented','on')
        set_param('vRTHS_MDOF_SimRT/Real-Time Synchronization','Commented','on')
        set_param('vRTHS_MDOF_SimRT/Missed Ticks','Commented','on')
end
F2_controller_PI

set_param(bdroot,'SolverType','Fixed-step','Solver','ode4','StopTime','tend','FixedStep','dt_rths')
sim ('vRTHS_MDOF_SimRT_PI')
RTHS_PI=Num_resp.Data; y_gcPI=y_gc;

sw=0; % 0 means without boundary layer; 1 means with.
F2_controller
set_param(bdroot,'SolverType','Fixed-step','Solver','ode4','StopTime','tend','FixedStep','dt_rths')
sim ('vRTHS_MDOF_SimRT')
u0=u; y_gc0=y_gc;

sw=1; % 0 means without boundary layer; 1 means with.
F2_controller
sim ('vRTHS_MDOF_SimRT')
RTHS_SMC=Num_resp.Data;
Ref_Resp = lsim(sys_r,EQ_input,t);

%% plots
E=v-vd+lambda*(x-xd);
figure; set(gcf,'Position',[0 0 900 520]);
subplot(2,1,1);
plot(t,E,'b','linewidth',1); grid on;
subplot(2,1,2);
plot(t,E,'b','linewidth',1.5); hold on;
plot(t,Phi,'r','linewidth',1); grid on;
plot(t,-Phi,'r','linewidth',1);

for i=1:2
    subplot(2,1,i);
    xlim([0,40]);
    axesH = gca;
    set(axesH,'fontsize',16,'TickLabelInterpreter','latex');
    %axesH.XAxis.TickLabelFormat ='\\textbf{%g';axesH.YAxis.TickLabelFormat ='\\textbf{%g';
    ylabel('Compact error (m/s)','interpreter','latex');
end
xlabel('Time (s)','interpreter','latex');
% ylim([-0.06,0.06]); set(gca,'YTick',-0.06:0.03:0.06);
legend({'{\it E}-trajectory','Boundary layer'},'interpreter','latex','location','NorthEast');
subplot(2,1,1);
ylim([-6e-16,6e-16]); set(gca,'YTick',-6e-16:3e-16:6e-16);
legend({'{\it E}-trajectory'},'interpreter','latex','location','NorthEast');
% title('{\it E}-trajectory and time-varying boundary layer','fontsize',14,'interpreter','latex');
% print -depsc F_E_trajectory;

%%
figure; set(gcf,'Position',[0 0 900 450]);
subplot(2,2,1:2);
plot(t,u0,'b','linewidth',1); hold on;
plot(t,u,'--r','linewidth',1); grid on;
axesH = gca;
set(axesH,'fontsize',16,'TickLabelInterpreter','latex');
%axesH.XAxis.TickLabelFormat ='\\textbf{%g';axesH.YAxis.TickLabelFormat ='\\textbf{%g';
ylabel('Ajusted command','interpreter','latex');
xlabel('Time (s)','interpreter','latex');
xlim([0,40]);
ylim([-240,240]); set(gca,'YTick',-240:120:240);
legend({'Without boundary layer','With boundary layer'},'interpreter','latex','location','NorthEast');
subplot(2,2,3);
plot(t,u0,'b','linewidth',1); hold on;
plot(t,u,'--r','linewidth',1); grid on;
xlim([14,15]);
subplot(2,2,4);
plot(t,u0,'b','linewidth',1); hold on;
plot(t,u,'--r','linewidth',1); grid on;
xlim([24,25]);

for i=3:4
    subplot(2,2,i);
    axesH = gca;
    set(axesH,'fontsize',16,'TickLabelInterpreter','latex');
    %axesH.XAxis.TickLabelFormat ='\\textbf{%g';axesH.YAxis.TickLabelFormat ='\\textbf{%g';
    ylabel('Ajusted command','interpreter','latex');
    xlabel('Time (s)','interpreter','latex');
end
ylim([-100,100]); set(gca,'YTick',-100:50:100);
subplot(2,2,3);
ylim([-180,180]); set(gca,'YTick',-180:90:180);
% print -depsc F_adjusted_command;

%%
figure; set(gcf,'Position',[0 0 900 450]);
subplot(2,1,1);
plot(t,y_gc0,'b','linewidth',1); hold on;
plot(t,y_gc,'--r','linewidth',1); grid on;
xlim([0,40]); set(gca,'XTick',[0 5 7 8 10 20 30 40]);
ylim([-1,1]); set(gca,'YTick',-1:0.5:1);
line([7,7],[-1,1],'linestyle','-','Color','m','linewidth',1.5);
line([8,8],[-1,1],'linestyle','-','Color','m','linewidth',1.5);
legend({'Without boundary layer','With boundary layer'},'interpreter','latex','location','NorthEast');
subplot(2,1,2);
plot(t,y_gc,'--r','linewidth',1); grid on;
xlim([0,40]); set(gca,'XTick',[0 5 7 8 10 20 30 40]);
ylim([-1e-2,1e-2]); set(gca,'YTick',-1e-2:0.5e-2:1e-2);
line([7,7],[-1,1],'linestyle','-','Color','m','linewidth',1.5);
line([8,8],[-1,1],'linestyle','-','Color','m','linewidth',1.5);
legend({'With boundary layer'},'interpreter','latex','location','NorthEast');

for i=1:2
    subplot(2,1,i);
    axesH = gca;
    set(axesH,'fontsize',16,'TickLabelInterpreter','latex');
    %axesH.XAxis.TickLabelFormat ='\\textbf{%g';axesH.YAxis.TickLabelFormat ='\\textbf{%g';
    ylabel('Actual command','interpreter','latex');
    xlabel('Time (s)','interpreter','latex');
end

axes('position',[.33 .62 .2 .08]);
box on;
plot(t,y_gc0,'b','linewidth',1); hold on;
plot(t,y_gc,'--r','linewidth',1); grid on;
xlim([7,8]);
set(gca,'ytick',[]);
set(gca,'xtick',[]);
annotation('arrow',[0.32 0.29],[0.66 0.66],'linestyle','-','Color','m','linewidth',1.5);

axes('position',[.33 .14 .2 .08]);
box on;
plot(t,y_gc,'--r','linewidth',1); grid on;
xlim([7,8]);
set(gca,'ytick',[]);
set(gca,'xtick',[]);
annotation('arrow',[0.32 0.29],[0.18 0.18],'linestyle','-','Color','m','linewidth',1.5);
% print -depsc F_actual_command;

%%
figure; set(gcf,'Position',[0 0 900 520]);
for i=1:3
    subplot(3,1,i);
    plot(t,Ref_Resp(:,4-i)*1000,'k','linewidth',2); hold on;
    plot(t,RTHS_PI(:,4-i)*1000,'--m','linewidth',1.5); grid on;
    plot(t,RTHS_SMC(:,4-i)*1000,':c','linewidth',2);
    xlim([6,20]);
    axesH = gca;
    set(axesH,'fontsize',16,'TickLabelInterpreter','latex');
    %axesH.XAxis.TickLabelFormat ='\\textbf{%g';axesH.YAxis.TickLabelFormat ='\\textbf{%g';
end

subplot(3,1,1);
set(gca,'YTick',-10:5:10);
ylabel('$3^{rd}$ floor (mm)','fontsize',16,'interpreter','latex');
subplot(3,1,2);
set(gca,'YTick',-10:5:10);
ylabel('$2^{nd}$ floor (mm)','fontsize',16,'interpreter','latex');
subplot(3,1,3);
ylim([-6,6]);set(gca,'YTick',-6:3:6);
ylabel('$1^{st}$ floor (mm)','fontsize',16,'interpreter','latex');
xlabel('Time (s)','fontsize',16,'interpreter','latex');
legend({'Reference model','PI-P','SMC'},...
    'fontsize',16,'interpreter','latex','location','Northeast','orientation','horizontal');
% print -depsc F_ELcentro_results;
