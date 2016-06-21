function save_groupedFigures_2Dor3D(healthy,risk,param1,param2,param3)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

out_heal_mat = correct_for_outliers(healthy);
out_risk_mat = correct_for_outliers(risk);


if(nargin<5)
    out_risk_rem = cat(2,out_risk_mat{param1},out_risk_mat{param2});
    out_heal_rem = cat(2,out_heal_mat{param1},out_heal_mat{param2});
    healthy(:,out_heal_rem) = [];
    risk(:,out_risk_rem) = [];
    
    num = randperm(length(healthy),length(risk)); %to reflect same number of points from both
    x = [healthy(param1,num),risk(param1,:)]';
    y = [healthy(param2,num),risk(param2,:)]';
    group = [1*ones(length(risk),1);2*ones(length(risk),1)];
    gscatter(x,y,group);
    legend('healthy','risk');
    xlabel(strcat('param\_',num2str(param1)));
    ylabel(strcat('param\_',num2str(param2)));
    title(strcat('pairwise\_plot\_params\_',num2str(param1),'\_',num2str(param2)));
    saveas(gcf,strcat('pairwise_plot_params_',num2str(param1),'_',num2str(param2),'.jpg'));
else
    out_risk_rem = cat(2,out_risk_mat{param1},out_risk_mat{param2},out_risk_mat{param3});
    out_heal_rem = cat(2,out_heal_mat{param1},out_heal_mat{param2},out_heal_mat{param3});
    healthy(:,out_heal_rem) = [];
    risk(:,out_risk_rem) = [];
    
    num = randperm(length(healthy),length(risk)); %to reflect same number of points from both
    x = [healthy(param1,num),risk(param1,:)]';
    y = [healthy(param2,num),risk(param2,:)]';
    z = [healthy(param3,num),risk(param3,:)]';
    group = [1*ones(length(risk),1);2*ones(length(risk),1)];
    h = gscatter(x,y,group);
    gu = unique(group);
    for k = 1:numel(gu)
        set(h(k), 'ZData', z( group == gu(k) ));
    end
    view(3)
    legend('healthy','risk');
    xlabel(strcat('param\_',num2str(param1)));
    ylabel(strcat('param\_',num2str(param2)));
    zlabel(strcat('param\_',num2str(param3)));
    title(strcat('pairwise\_plot\_params\_',num2str(param1),'\_',num2str(param2),'\_',num2str(param3)));
    saveas(gcf,strcat('3D_plot_params_',num2str(param1),'_',num2str(param2),'_',num2str(param3),'.jpg'));
end

end

