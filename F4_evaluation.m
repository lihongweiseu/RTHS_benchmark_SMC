%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Evaluation Measurement                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: This portion of the file should not be modified.
if ii == 1
    test{ii,1} = strcat('Nominal');
else
    test{ii,1} = strcat('Perturbed_ ',num2str(ii-1));
end

N = 1:50;
for jj = N
    R1 = corr(X_m.Data(jj:end,1),Num_resp.Data(1:end-jj+1,1));
    r1(jj) = R1;
%     R4 = corr(X_m.Data(jj:end,1),Ref_Resp(1:end-jj+1,1));
%     r4(jj) = R4;
end

% 1. Tracking time delay from cross correlation
[Y,I] = max(r1);
del1 = (N-1)*dt_rths;
    J1(ii,1) = round(10000*del1(I))/10;

% 2. Normalized root mean square of experimental tracking error
    J2(ii,1) = round(10000*std(X_m.Data(:,1)-Num_resp.Data(:,1))/std(Num_resp.Data(:,1)))/100;
% 3. Tracking peak error
    J3(ii,1) = round(10000*max(abs(X_m.Data(:,1)-Num_resp.Data(:,1)))/max(abs(Num_resp.Data(:,1))))/100;
% 4. Displacement normalized root mean square error (1st floor)
    J4(ii,1) = round(10000*(std(X_m.Data(:,1)-Ref_Resp(:,1))/std(Ref_Resp(:,1))))/100;
% 5. Displacement peak error (1st floor)
    J5(ii,1) = round(10000*max(abs(X_m.Data(:,1)-Ref_Resp(:,1)))/max(abs(Ref_Resp(:,1))))/100;
% 6. Displacement normalized root mean square error (2nd floor)
    J6(ii,1) = round(10000*(std(Num_resp.Data(:,2)-Ref_Resp(:,2))/std(Ref_Resp(:,2))))/100;
% 7. Displacement normalized root mean square error (3nd floor)
    J7(ii,1) = round(10000*(std(Num_resp.Data(:,3)-Ref_Resp(:,3))/std(Ref_Resp(:,3))))/100;
% 8. Displacement peak error   (2nd floor)
    J8(ii,1) = round(10000*max(abs(Num_resp.Data(:,2)-Ref_Resp(:,2)))/max(abs(Ref_Resp(:,2))))/100;
% 9. Displacement peak error   (3nd floor)
    J9(ii,1) = round(10000*max(abs(Num_resp.Data(:,3)-Ref_Resp(:,3)))/max(abs(Ref_Resp(:,3))))/100;
    
eval_crit = [J1(ii,1) J2(ii,1) J3(ii,1) J4(ii,1) J5(ii,1) J6(ii,1) J7(ii,1) J8(ii,1) J9(ii,1)];

%% NOTE: This portion of the file should not be modified.

time = clock;
time_test = strcat(num2str(time(1)),'_',... % Returns year 
    num2str(time(2)),'_',... % Returns month 
    num2str(time(3)),'_',... % Returns day 
    num2str(time(4)),'_',... % returns hour 
    num2str(time(5)),'_',... % returns min 
    num2str(fix(time(6)))) ; 

if ii == 1
    save(strcat('.\Results\Data_',time_test,'_Nom_'),'t', 'Ref_Resp','Num_resp','X_m','eval_crit');
else
    save(strcat('.\Results\Data_',time_test,'_Pert_',num2str(ii-1)),'t', 'Ref_Resp','Num_resp','X_m','eval_crit');
end


% if max(abs(Force_act.Data)) >= 8900
%     clc, error('ERROR. The actuator capacity was exceeded.')
% end