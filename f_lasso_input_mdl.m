function [x_lasso_input_mdl,y_lasso_input_mdl] = f_lasso_input_mdl(x,coord,varargin)

% INPUTS
% x                     Database is matrix (nrow,ncol) where columns are mo-
%                       nitoring stations and rows are the different points
%                       of time.  
%       
% coord                 Grid references where columns are (x_coord,y_coord)
%                       of each monitoring stations and rows are number of
%                       each monitoring station.     
% 
% OUTPUTS
% x_lasso_input_mdl     A new database as input of lasso model where rows
%                       are input variables for a monitoring stations and  
%                       for a moment in time.
%
% y_lasso_input_mdl     A new database as input of lasso model where rows
%                       are input variables for a monitoring stations and  
%                       for a moment in time.
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
[nrow,ncol] = size(x);

% Calculating distances between stations
x_coord = coord(:,1);
y_coord = coord(:,2);
for i = 1:ncol
    x_coord_temp = x_coord(i);
    y_coord_temp = y_coord(i);
    for j = 1:ncol
        d(i,j) = sqrt((x_coord(j) - x_coord_temp).^2 + (y_coord(j) - y_coord_temp).^2);
    end
end

% Generating a new database
x_temp = [];
for i = 1:ncol
    temp = x;
    temp(:,i) = zeros(size(temp(:,i)));
    x_temp = [x_temp; temp];
end

d_temp = [];
for j = 1:ncol
    temp = d(j,:);
    temp = repmat(temp,nrow,1);
    d_temp = [d_temp; temp];
end

if p.Results.InteractionPar
    x_lasso_input_mdl = [x_temp d_temp x_temp.*d_temp];
else
    x_lasso_input_mdl = [x_temp d_temp];
end

y_lasso_input_mdl = x(:);
