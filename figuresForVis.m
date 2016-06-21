clf; close all

healthy = healthy_orig;
risk = risk_orig;
healthy(:,outR_dash_tau_heal) = [];
risk(:,outR_dash_tau_risk) = [];
num = randperm(length(healthy),length(risk));
x = [healthy(1,num),risk(1,:)]';
y = [healthy(4,num),risk(4,:)]';
z = [healthy(100,num),risk(100,:)]';
group = [1*ones(length(risk),1);2*ones(length(risk),1)];
h = gscatter(x,y,group); 

%------------------3D scatter plot-------------------------
gu = unique(group);
for k = 1:numel(gu)
      set(h(k), 'ZData', z( group == gu(k) ));
end
view(3)
legend('healthy','risk');
xlabel('QRS angle');
ylabel('R" tau');
zlabel('length in ms');