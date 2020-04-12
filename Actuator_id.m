a1=2.13e13; a2=4.23e6; me=29.1; ce=114.6;
a3=3.3; b1=425; b2=10e4; ke=1.19e6;
t3=ce+me*a3;
A4=t3+me*b1;
t1=ke*a3;
t2=ke+ce*a3+a2;
A0=t1*b2+a1;
A1=t1*b1+t2*b2;
A2=t1+t2*b1+t3*b2;
A3=t2+t3*b1+me*b2;

input=2*pi*(0:0.01:30)';
N=length(input);
magw_e = freqs(a1,[me,A4,A3,A2,A1,A0],input);
MagdB_e=db(magw_e);
Phase_e=-abs(angle(magw_e)); % rad
Time_delay_e=Phase_e./input; % sec
Time_delay_e(1)=Time_delay_e(2);
Time_delay_e=Time_delay_e*1000;
DC=magw_e(1);
tt=0.02*(0:N-1)';
output=zeros(N,1);

uncer=1.6; % probability integral with normal distribution: 89.04%
a3=[3.3-uncer*1.3,3.3+uncer*1.3]; % normal value
b1=[425-uncer*3.3,425+uncer*3.3];
b2=[10e4-uncer*3.31e3,10e4+uncer*3.31e3]; % normal value
ke=[1.19e6-uncer*5e4,1.19e6+uncer*5e4];

magw=zeros(N,16);
MagdB=zeros(N,16);
Phase=zeros(N,16);
Time_delay=zeros(N,16);

for a3i=1:2
    t3=ce+me*a3(a3i);
    for b1i=1:2
        A4=t3+me*b1(b1i);
        for kei=1:2
            t1=ke(kei)*a3(a3i);
            t2=ke(kei)+ce*a3(a3i)+a2;
            for b2i=1:2
                A0=t1*b2(b2i)+a1;
                A1=t1*b1(b1i)+t2*b2(b2i);
                A2=t1+t2*b1(b1i)+t3*b2(b2i);
                A3=t2+t3*b1(b1i)+me*b2(b2i);
                i=(((a3i-1)*2+b1i-1)*2+kei-1)*2+b2i;
                magw(:,i) = freqs(a1,[me,A4,A3,A2,A1,A0],input);
                MagdB(:,i)=db(magw(:,i));
                Phase(:,i)=-abs(angle(magw(:,i))); % rad
                Time_delay(:,i)=Phase(:,i)./input; % sec
            end
        end
    end
end
Time_delay=Time_delay*1000; % msec
MagdB_u=max(MagdB,[],2);
MagdB_l=min(MagdB,[],2);
Phase_u=max(Phase,[],2);
Phase_l=min(Phase,[],2);
Time_delay_u=max(Time_delay,[],2);
Time_delay_l=min(Time_delay,[],2);
Time_delay_u(1)=Time_delay_u(2);
Time_delay_l(1)=Time_delay_l(2);

% b = 223.55;
% c = 54516;
% d = 0.00010597;
% e = 0.02107;
% a = DC*c; % 53529

a = 53354;
b = 221.64;
c = 54290;
d = 0.00010595;
e = 0.021072;
%%
TF_delay=tf(a,[1,b,c])*tf([d,1],[e,1]);
magw2_e=zeros(N,1);
for i=1:N
    magw2_e(i) = evalfr(TF_delay,1i*input(i));
end
MagdB2_e=db(magw2_e);
Phase2_e=-abs(angle(magw2_e)); % rad
Time_delay2_e=Phase2_e./input; % sec
Time_delay2_e(1)=Time_delay2_e(2);
Time_delay2_e=Time_delay2_e*1000;

%%
a_ = a*[1-0.00,1+0.00];
b_ = b*[1-0.36,1+0.36];
c_ = c*[1-0.1,1+0.1];

magw2=zeros(N,8);
MagdB2=zeros(N,8);
Phase2=zeros(N,8);
Time_delay2=zeros(N,8);

for ai=1:2
    for bi=1:1:2
        for ci=1:1:2
            i=((ai-1)*2+bi-1)*2+ci;
            TF_delay=tf(a_(ai),[1,b_(bi),c_(ci)])*tf([d,1],[e,1]);
            for j=1:1:N
                magw2(j,i) = evalfr(TF_delay,1i*input(j));
            end
            MagdB2(:,i)=db(magw2(:,i));
            Phase2(:,i)=-abs(angle(magw2(:,i))); % rad
            Time_delay2(:,i)=Phase2(:,i)./input; % sec
        end
    end
end

Time_delay2=Time_delay2*1000; % msec
MagdB2_u=max(MagdB2,[],2);
MagdB2_l=min(MagdB2,[],2);
Phase2_u=max(Phase2,[],2);
Phase2_l=min(Phase2,[],2);
Time_delay2_u=max(Time_delay2,[],2);
Time_delay2_l=min(Time_delay2,[],2);
Time_delay2_u(1)=Time_delay2_u(2);
Time_delay2_l(1)=Time_delay2_l(2);
%
%%
h=figure; set(gcf,'Position',[0 0 900 480]);
hAxis(1)=subplot(3,2,1);
plot(input/2/pi,MagdB_e,'r','linewidth',2); hold on;
plot(input/2/pi,MagdB2_e,'c--','linewidth',2); grid on;
ylim([-15,0]);
ylabel('\textbf{Gain~(dB)}','fontsize',12,'interpreter','latex');
hAxis(3)=subplot(3,2,3);
plot(input/2/pi,Phase_e,'r','linewidth',2); hold on;
plot(input/2/pi,Phase2_e,'c--','linewidth',2); grid on;
ylim([-3,0]);
ylabel('\textbf{Phase~(Rad)}','fontsize',12,'interpreter','latex');
hAxis(5)=subplot(3,2,5);
plot(input/2/pi,Time_delay_e,'r','linewidth',2); hold on;
plot(input/2/pi,Time_delay2_e,'c--','linewidth',2); grid on;
ylim([-30,-10]);
ylabel('\textbf{Time delay~(msec)}','fontsize',12,'interpreter','latex');
xlabel('\textbf{Frequency~(Hz)}','fontsize',12,'interpreter','latex');
legend({'\textbf{Original model (nominal)}','\textbf{Reduced model (nominal)}'},...
    'fontsize',12,'interpreter','latex','location','Southeast');

hAxis(2)=subplot(3,2,2);
area2=fill([input;input(N:-1:1)]/2/pi,[MagdB_u;MagdB_l(N:-1:1)],'r'); hold on; 
set(area2,'LineStyle','none');     set(area2,'facealpha',1)
area1=fill([input;input(N:-1:1)]/2/pi,[MagdB2_u;MagdB2_l(N:-1:1)],'c'); grid on;
set(area1,'LineStyle','none');     set(area1,'facealpha',0.5);
ylim([-15,0]);
hAxis(4)=subplot(3,2,4);
area2=fill([input;input(N:-1:1)]/2/pi,[Phase_u;Phase_l(N:-1:1)],'r'); hold on; 
set(area2,'LineStyle','none');     set(area2,'facealpha',1)
area1=fill([input;input(N:-1:1)]/2/pi,[Phase2_u;Phase2_l(N:-1:1)],'c'); grid on;
set(area1,'LineStyle','none');     set(area1,'facealpha',0.5);
ylim([-3,0]);
hAxis(6)=subplot(3,2,6);
area2=fill([input;input(N:-1:1)]/2/pi,[Time_delay_u;Time_delay_l(N:-1:1)],'r'); hold on; 
set(area2,'LineStyle','none');     set(area2,'facealpha',0.5)
area1=fill([input;input(N:-1:1)]/2/pi,[Time_delay2_u;Time_delay2_l(N:-1:1)],'c'); grid on;
set(area1,'LineStyle','none');     set(area1,'facealpha',0.5);
ylim([-30,-10]);
xlabel('\textbf{Frequency~(Hz)}','fontsize',12,'interpreter','latex');
legend({'\textbf{Original model with uncertainty}','\textbf{Reduced model with uncertainty}'},...
    'fontsize',12,'interpreter','latex','location','Southeast');

for i=1:6
    subplot(3,2,i);
    axesH = gca;
    set(axesH,'fontsize',12,'TickLabelInterpreter','latex');
    axesH.XAxis.TickLabelFormat ='\\textbf{%g}';axesH.YAxis.TickLabelFormat ='\\textbf{%g}';
end

pos2 = get( hAxis(2), 'Position' );
pos4 = get( hAxis(4), 'Position' );
pos6 = get( hAxis(6), 'Position' );

xposition=pos2(1)-0.06;
pos2(1)=xposition; pos4(1)=xposition; pos6(1)=xposition;
set(hAxis(2),'Position', pos2);
set(hAxis(4),'Position', pos4);
set(hAxis(6),'Position', pos6);

% set(gcf,'renderer','Painters'); set(h, 'InvertHardCopy', 'on'); print -dpdf -fillpage F_model;
% set(h,'Units','Inches');
% pos = get(h,'Position');
% set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% print(h,'F_model','-dpdf','-r0')