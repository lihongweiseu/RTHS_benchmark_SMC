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
Rx=rms_noise_DT/dt_rths;
Ax=[0 1;-a]; Bx=[0;1]; Cx=[1,0]; Dx=0;
% Ax=[0 1;-a]; Bx=[0;1]; Cx=eye(2); Dx=zeros(2,1);
% [KESTx,Lx,Px] = kalman(ss(Ax,[Bx zeros(2,1)],Cx(1,:),[Dx(1,:) 0]),0,Rx,0);
% Axf=Ax-Lx*Cx(1,:); Bxf=[Bx-Lx*Dx(1),Lx]; Cxf=Cx; Dxf=[Dx,zeros(2,1)];
xinitial=zeros(2,1);

% Phase lead design
compn=[2*dt_rths 1];
compd=[dt_rths 1];
