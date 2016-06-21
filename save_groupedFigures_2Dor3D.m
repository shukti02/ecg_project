function save_groupedFigures_2Dor3D(healthy,out_heal_cell,risk,out_risk_cell,param1,param2,param3)
%To save 2D or 3D grouped plots of healthy and risk data after outlier
%removal
%inputs: --healthy - matrix containing healthy data (rows: features,
%                    columns:instances)
%        --risk - matrix containing risk data
%        --out_heal_cell, out_risk_cell: cells containing outliers for each
%        parameter from the healthy and risk data, computed by the function
%        correct_for_outliers.
%        --param1,param2,param3: Specify parameters to plot for; if param3
%        is missing the plot is automatically 2D.
clf; close all

if(nargin<7)
    out_risk_rem = cat(2,out_risk_cell{param1},out_risk_cell{param2});
    out_heal_rem = cat(2,out_heal_cell{param1},out_heal_cell{param2});
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
    saveas(gcf,strcat('~/Desktop/SHUKTI_new/task6SVM/figs/pairwise_plot_params_',num2str(param1),'_',num2str(param2),'.jpg'));
else
    out_risk_rem = cat(2,out_risk_cell{param1},out_risk_cell{param2},out_risk_cell{param3});
    out_heal_rem = cat(2,out_heal_cell{param1},out_heal_cell{param2},out_heal_cell{param3});
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
    title(strcat('3D\_plot\_params\_',num2str(param1),'\_',num2str(param2),'\_',num2str(param3)));
    saveas(gcf,strcat('~/Desktop/SHUKTI_new/task6SVM/figs/3D_plot_params_',num2str(param1),'_',num2str(param2),'_',num2str(param3),'.jpg'));
end

end

