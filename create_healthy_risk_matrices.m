function [healthy_orig, risk_orig] = create_healthy_risk_matrices(path_to_patient)
%To create healthy and risk matrices for bradycardia. Risk zone is taken
%as the time 15 minutes before the occurrance of an arrhythmia

%inputs:path_to_patient-path tothe patient data

%outputs:healthy_orig - healthy matrix
%        risk_orig - risk matrix

if(isempty(path_to_patient))
    path_to_patient = '~/Desktop/SHUKTI_new/Patients/WG 015.mat';
end
matObj = matfile(path_to_patient);

brady = 1000*matObj.arrBradycardia_x; %tested only for bradycardia
MSpos = 1000*matObj.MSmodelsX;
beatpos = 1000*matObj.beatpos;
models = matObj.MSmodels;

bradyPos = zeros(length(brady),1);
MSbradyPos = zeros(length(brady),1);

for i = 1:length(brady)
    bradyPos(i) = beatpos(beatpos==brady(i));
    MSbradyPos(i) = MSpos(MSpos>brady(i)-20 & MSpos<brady(i)+20); 
    %works for patient WG 015, needs tobe made more generic for other patients
end

x = find(isnan(MSpos));
MSpos(x) = []; models(:,x) = [];
MSinterval = [[1;MSbradyPos] [MSbradyPos;MSpos(end)+1]];
heal_pos = []; risk_pos = [];
for i = 1:length(MSinterval)
    h_pos = find(MSpos>MSinterval(i,1) & MSpos<(MSinterval(i,2)-900000*(i<=length(MSbradyPos))));
    heal_pos = [heal_pos h_pos];
    if (i<=length(MSbradyPos))
        r_pos = find(MSpos>=(MSbradyPos(i)-900000) & MSpos<MSbradyPos(i));
        %small bug: needs to be fixed - two of the brady positions have
        %small duration (<900000ms) between them, this results in
        %repetition of beats and also inclusion of the previous arrhythmia
        %position
        risk_pos = [risk_pos r_pos];        
    end
end
heal_pos = unique(heal_pos); 
risk_pos = unique(risk_pos); %solves the problem of repetitions 
%but inclusion of the previous arrhythmis needs to be addressed

healthy_orig = models(1:100,heal_pos);
risk_orig = models(1:100,risk_pos);

end

