function [out_cell] = correct_for_outliers(matrix_orig)
%correcting for each parameter separately, based on relevance
%inputs: matrix_orig: matrix containing rows as parameters(features) from MS models 
%        and columns as instances  

%outputs: out_cell: contains indices of outliers

out_cell = cell(99,1);

%tau cannot be larger that the max spacing between two beats
tau_vector = [2 3 4 5 18 19 24 25 26 27];

for i = 1 : length(tau_vector)
    out_cell{tau_vector(i)} = find(abs(matrix_orig(tau_vector(i),:))>max(matrix_orig(100,:)));
end

%widths of gaussians cannot be larger than the max spacing between two
%beats
w_vector = [10:17,22,23,32:39];

for i = 1 : length(w_vector)
    out_cell{w_vector(i)} = find(abs(matrix_orig(w_vector(i),:))>max(matrix_orig(100,:)));
end


%amplitudes represent the voltage of the signal in mV. This definitely
%cannot be higher than 100V.
M_vector = [6:9,20,21,28:31,40:99];

for i = 1 : length(M_vector)
    out_cell{M_vector(i)} = find(abs(matrix_orig(M_vector(i),:))>10^5);
end
end