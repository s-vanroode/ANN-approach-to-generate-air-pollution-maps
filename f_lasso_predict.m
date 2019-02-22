function y = f_lasso_predict(x_new,coord_new,coord,mdl,varargin)

% INPUTS
% x_new                 New predictor input values of each new point, spe-
%                       cified as a matrix,it must have the same number of   
%                       variables (columns) as was used to create mdl. 
%
%                       Example:
%                       x_new = [x_s1,x_s2,...,x_sn] where x_sn is the mea-
%                       sured value in station n.
%
% coord_new             New predictor input coordinates or grid references,  
%                       spedified as a matrix,it must have (x_coord,y_coord)
%                       of each new point.
%       
% coord                 Grid references where columns are (x_coord,y_coord)
%                       it must have the same number of variables (columns)
%                       as was used to create mdl.
%
%                       Example:
%                       coord = 
%                         [x_coord_s1,y_coord_s1;...;x_coord_sn,y_coord_sn]
%                       where x_coord_sn and y_coord_sn are the X and Y
%                       coordinates of station n.
%                          
% 
% OUTPUTS
% y_new                 Predicted reponse values evaluated at x_new, retur-
%                       ned as a numeric vector. It is the same size as
%                       x_new.
% 
% VARARGIN
% 'InteractionPar'      Add to the new database a variable type that is an
%                       interaction between the measured variable and the 
%                       distance. It is false by default.
% 
%-------------------------------------------------------------------------%
% VARARGIN
p = inputParser;

addParameter(p, 'InteractionPar', false, @islogical);

parse(p,varargin{:});
disp(p.Results);


%-------------------------------------------------------------------------%
[nrow,~] = size(x_new);

B = mdl.B;
intercept = mdl.FitInfo.Intercept;

x_coord = coord(:,1)';
y_coord = coord(:,2)';

x_coord_new = coord_new(:,1);
y_coord_new = coord_new(:,2);

for i = 1:nrow
    x_coord_temp = x_coord_new(i);
    y_coord_temp = y_coord_new(i);
    d(i,:) = sqrt((x_coord - x_coord_temp).^2 + (y_coord - y_coord_temp).^2);
end

if p.Results.InteractionPar
    x_lasso_input = [x_new d x_new.*d];
else
    x_lasso_input = [x_new d];
end

y = x_lasso_input*B + intercept;





