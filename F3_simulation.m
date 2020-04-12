%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Start simulation                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: This portion of the file should not be modified.

set_param(bdroot,'SolverType','Fixed-step','Solver','ode4','StopTime','tend','FixedStep','dt_rths')
sim ('vRTHS_MDOF_SimRT')

Ref_Resp = lsim(sys_r,EQ_input,t);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Data Analysis: RTHS vs Reference Structure                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: This portion of the file should not be modified. 

scrsz = get(0,'ScreenSize');
b_d = [0 0.4471 0.7412];  y_d = [0.9294  0.6941    0.1255];   % Color definition

switch lower(plot_on)
    case 'y'
        figure('Name','Virtual RTHS simulation','Position',...
            [40+scrsz(1) scrsz(4)*(1/20) scrsz(3)*(2/3-1/20) scrsz(4)*(.85)])
        for i=1:3
        sp(i)= subplot(3,1,i); grid on, hold on
            plot(t,Ref_Resp(:,i),'-','color',y_d,'linewidth',1.5)
            plot(t,Num_resp.Data(:,i),':','color',b_d,'linewidth',1.5)
            set(sp(i),'fontsize',10)
            xlim([0,tend])
        end
        ylabel(sp(1),'x_1 (m)','fontsize',12,'fontweight','bold');
        ylabel(sp(2),'x_2 (m)','fontsize',12,'fontweight','bold');
        ylabel(sp(3),'x_3 (m)','fontsize',12,'fontweight','bold');

        xlabel(sp(3),'Time (sec)','fontsize',12,'fontweight','bold');
        l = legend(sp(2),{'Reference model','RTHS simulation'},'fontsize',10,'location','north', 'Orientation','horizontal');
        set(l,'Position',[0.33 0.93 0.3816 0.05000])
end

% xd=Num_resp.data(:,1);
% vd=Num_resp.data(:,4);
% ad=Num_resp.data(:,7);
% E=v-vd+lambda*(x-xd);
% figure; plot(t,Phi,'r',t,-Phi,'r',t,E,'b');