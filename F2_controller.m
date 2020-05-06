%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Controller algorithm design                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sliding control parameters
a = 53354;
b = 221.64;
c = 54290;
d = 0.00010595;
e = 0.021072;
bc=0.36; cc=0.1; % uncertainties

lambda=150; eta=0.1;
Para=[b c b*bc c*cc lambda eta];

% Kalman filter design
[Ax,Bx,Cx,Dx] = tf2ss([0 1;1 0],[1 b c]);
Rx=rms_noise_DT/dt_rths;
[KESTx,Lx,Px] = kalman(ss(Ax,zeros(2,1),Cx(1,:),0),0,Rx,0);
Axf=Ax-Lx*Cx(1,:); Bxf=[Bx-Lx*Dx(1),Lx]; Cxf=Cx; Dxf=[Dx,zeros(2,1)];
xinitial=zeros(2,0);

% Phase lead design
compn=[2*dt_rths 1];
compd=[dt_rths 1];
