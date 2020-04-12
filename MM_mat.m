function [MM_12, mm_lat] = MM_mat(Ms)

% 12 DOF mass matrix
MM_12 = diag(Ms);
MM_12(4:12,4:12) = zeros(9);

% 3 DOF mass matrix (rotational DOF are removed) 
mm_lat = diag(Ms);       % [kg]
