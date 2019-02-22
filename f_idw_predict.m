function y = f_idw_predict(x_new,coord_new,coord,b)

% INPUTS
% x_new                 New predictor input values of each monitoring sta-
%                       tion, specified as a table.  
%
%                       Example:
%                       x_new = [x_s1,x_s2,...,x_sn] where x_sn is the mea-
%                       sured value in station n.
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
% coord_new             New predictor input coordinates or grid references,  
%                       spedified as a table,it must have (x_coord,y_coord)
%                       of each new point. It is the same length as x.
%                       
% b                     It is a parameter that is used to highlight the spa-
%                       tial relationship between points. Farther points
%                       will be less important larger B.                     
%
% OUTPUTS
% y_new                 Predicted reponse values evaluated at x, returned
%                       as a numeric vector. It is the same length as
%                       x_new.

%-------------------------------------------------------------------------%
[nrow,~] = size(x_new);
vy = zeros(nrow,1);

lx = nrow;
 
mx_coord = mean(coord(:,1)); sx_coord = std(coord(:,1));
my_coord = mean(coord(:,2)); sy_coord = std(coord(:,2));
 
nx_coord = (coord(:,1) - mx_coord) / sx_coord;
ny_coord = (coord(:,2) - my_coord) / sy_coord;

nx_coord_new = (coord_new(:,1) - mx_coord) / sx_coord;
ny_coord_new = (coord_new(:,2) - my_coord) / sy_coord;

for t = 1:lx
    d = sqrt((nx_coord_new(t) - nx_coord').^2 + (ny_coord_new(t) - ny_coord').^2)';
    v = x_new(t,:)';
    u = find(d == 0);
    if isempty(d) == 0
        d(u) = [];
        v(u) = [];
    end
    vy(t) = (sum(v./(d.^b))) / (sum(1./(d.^b)));
end

y = vy; 
