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

sw=0; % 0 means without boundary layer; 1 means with.
F2_controller
set_param(bdroot,'SolverType','Fixed-step','Solver','ode4','StopTime','tend','FixedStep','dt_rths')
sim ('vRTHS_MDOF_SimRT')
u0=u;

sw=1; % 0 means without boundary layer; 1 means with.
F2_controller
sim ('vRTHS_MDOF_SimRT')
u1=u;
%%
figure; set(gcf,'Position',[0 0 900 450]);
subplot(2,2,1:2);
plot(t,u0,'b','linewidth',1); hold on;
plot(t,u1,'--r','linewidth',1); grid on;
axesH = gca;
set(axesH,'fontsize',16,'TickLabelInterpreter','latex');
axesH.XAxis.TickLabelFormat ='\\textbf{%g}';axesH.YAxis.TickLabelFormat ='\\textbf{%g}';
ylabel('\textbf{Command (m)}','interpreter','latex');
xlabel('\textbf{Time (s)}','interpreter','latex');
xlim([0,40]);
ylim([-240,240]); set(gca,'YTick',-240:120:240);
legend({'\textbf{Without boundary layer}','\textbf{With boundary layer}'},'interpreter','latex','location','NorthEast');
subplot(2,2,3);
plot(t,u0,'b','linewidth',1); hold on;
plot(t,u1,'--r','linewidth',1); grid on;
xlim([14,15]);
subplot(2,2,4);
plot(t,u0,'b','linewidth',1); hold on;
plot(t,u1,'--r','linewidth',1); grid on;
xlim([24,25]);

for i=3:4
    subplot(2,2,i);
    axesH = gca;
    set(axesH,'fontsize',16,'TickLabelInterpreter','latex');
    axesH.XAxis.TickLabelFormat ='\\textbf{%g}';axesH.YAxis.TickLabelFormat ='\\textbf{%g}';
    ylabel('\textbf{Command (m)}','interpreter','latex');
    xlabel('\textbf{Time (s)}','interpreter','latex');
end
ylim([-100,100]); set(gca,'YTick',-100:50:100);
subplot(2,2,3);
ylim([-180,180]); set(gca,'YTick',-180:90:180);

% print -depsc F_Command;

%%
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
    axesH.XAxis.TickLabelFormat ='\\textbf{%g}';axesH.YAxis.TickLabelFormat ='\\textbf{%g}';
    ylabel('\textbf{Compact error (m/s)}','interpreter','latex');
end
xlabel('\textbf{Time (s)}','interpreter','latex');
% ylim([-0.06,0.06]); set(gca,'YTick',-0.06:0.03:0.06);
legend({'\textbf{{\it E}-trajectory}','\textbf{Boundary layer}'},'interpreter','latex','location','NorthEast');
subplot(2,1,1);
ylim([-6e-16,6e-16]); set(gca,'YTick',-6e-16:3e-16:6e-16);
legend({'\textbf{{\it E}-trajectory}'},'interpreter','latex','location','NorthEast');
% title('\textbf{{\it E}-trajectory and time-varying boundary layer}','fontsize',14,'interpreter','latex');
% print -depsc F_E_trajectory;
