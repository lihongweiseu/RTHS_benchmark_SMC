function CC = CC_mat(n, MM, zetas, fi, frecs)
% CC Constructs a proportional DAMP matrix. CC is a nxn matrix where n 
%    are the horizontal DOF in a condensed model .
 
%% NOTE: This portion of the file should not be modified.
mod_damp = .01*ones(1,n);
mod_damp(1,1:3) = zetas;
zetas = mod_damp;
% fi = fi(:,ind);
Mn = diag(fi'*MM*fi);

CC = inv(fi')*diag([2*zetas(1)*frecs(1,1)*Mn(1) 2*zetas(2)*frecs(2,2)*Mn(2) 2*zetas(3)*frecs(3,3)*Mn(3) ])*inv(fi);