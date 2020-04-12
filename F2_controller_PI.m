%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Controller algorithm design                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% DEFINE CONTROLLER CHARACTERISTICS
%  NOTE: Participants should replace this portion of the file to modify
%        the basic sample controllers.

load('./Controllers/Controller_2018_6_11_15_20_29')

% PID tracking controller
%  Gc = ss(pid_1);
G_C = ss(pid_1);

% Phase compensator 
pre_ss = ss(G_T);

%% CHECK STABILITY
% NOTE: This portion of the file should not be modified.

G_CL = feedback(G_C*G_pp,1,-1);

% CHECK STABILITY OF CONTROLLER
if max(real(eig(G_C.a))) > 0 
	disp('UNSTABLE CONTROLLER !')
	return
end
% CHECK STABILITY OF CLOSED LOOP SYSTEM (w/CONTROLLER)
if max(real(eig(G_CL.a))) > 0 
	disp('CLOSED LOOP UNSTABLE !')
	return
end

%  Convert to Discrete Form 
[Acd,Bcd,Ccd,Dcd]         = c2dm(G_C.a,G_C.b,G_C.c,G_C.d,dt_rths,'tustin');
[Apred,Bpred,Cpred,Dpred] = c2dm(pre_ss.a,pre_ss.b,pre_ss.c,pre_ss.d,dt_rths,'tustin');