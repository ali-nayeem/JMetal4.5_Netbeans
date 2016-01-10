% --- Called when data scaling is necessary
% Summary: Scales each dimension's highest value to 1 and its lowest to 0
% Description:
%%%% -For each dimension, find the min and max value and scale the rest to
%%%% the ratio
function AN=scaletominmax(A)    
[mlength,dimnum]=size(A);                                                   %%Create dimensions
AN = zeros(mlength,dimnum);                                                 %%Preallocate scaled matrix
    for n = 0 : dimnum-1                                                    %%Scale data
        AN(:,n+1)=(A(:,n+1)-min(A(:,n+1)))/(max(A(:,n+1))-min(A(:,n+1)));
    end