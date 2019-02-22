% PAPER: An artificial neural network ensemble approach to generate air
%        pollution maps.
% AUTHORS: Steffanie Van Roode Fuentes, Juan Jesús Ruiz Agüilar, Javier
%        González Enrique and Ignacio José Turias.
%
%
%-------------------------------------------------------------------------%
% This code pretends to reproduce the experiment (with any data base) in
% the most intuitive way for the user. It is not optimized.
%
% First, you must generate all three models (LASSO, IDW and ANN ensemble).
% Then, you can estimate any point on the map or generate a map (grid).
% Finally, you can display the map with scaled colours.
%
% An example of real database of NO2 is presented.
%-------------------------------------------------------------------------%

load database_example;


%% GENERATE ANN ENSEMBLE MODEL

% In this example, the validation and test processes have not been develo-
% ped but they must be performed in order to select the best model parame-
% ters.

% METER UN INPUT 

% REQUIRED PARAMETERS
% LASSO parameters
cv = input('Required LASSO parameter. Enter the k-fold number to create the model: ');
% IDW parameters
b = input('Required IDW parameter. Enter B parameter to create the model: ');
% ANN parameters
nhiddens = input('Required ANN parameter. Enter the number of hidden neurons to create the model: ');


% MODEL 1 - LASSO
% To generate input data for ann mdlel 
[nrow,ncol] = size(x);

x_mdl = [];
for i = 1:ncol
    temp = x;
    temp(:,i) = zeros(size(temp(:,i)));
    x_mdl = [x_mdl; temp];
end

coord_mdl = [];
for i = 1:ncol
    temp = coord(i,:);
    temp = repmat(temp,nrow,1);
    coord_mdl = [coord_mdl; temp];
end

mdl = f_lasso_mdl(x,coord,cv,'InteractionPar',true);
y_lasso = f_lasso_predict(x_mdl,coord_mdl,coord,mdl,'InteractionPar',true);


% MODEL 2 - IDW
% To generate input data for ann mdlel 
[nrow,ncol] = size(x);

x_mdl = repmat(x,ncol,1);

coord_mdl = [];
for i = 1:ncol
    temp = coord(i,:);
    temp = repmat(temp,nrow,1);
    coord_mdl = [coord_mdl; temp];
end

y_idw = f_idw_predict(x_mdl,coord_mdl,coord,b);


% MODEL 3 - ANN ENSEMBLE
net = f_ann_mdl([y_lasso(:) y_idw(:)],x(:),nhiddens);
y_ann = net([y_lasso(:) y_idw(:)]');



%% ESTIMATE ANY POINT OR GRID
% Estimate new values for an area for the point in time t from the new 
% database (x_new). 
t = input('Enter the instant t: ');
spaced = input('Enter the cell size of the grid (for example 200(m)):');


x_coord_lim = [min(coord(:,1)) max(coord(:,1))];
y_coord_lim = [min(coord(:,2)) max(coord(:,2))]; 

i = 1;
for x_coord = x_coord_lim(1)-spaced/2:spaced:x_coord_lim(2)+spaced/2
    j = 1;
    for y_coord = y_coord_lim(2)+spaced/2:-spaced:y_coord_lim(1)-spaced/2
        y_lasso_grid(j,i) = f_lasso_predict(x_new(t,:),[x_coord y_coord],coord,mdl,'InteractionPar',true);
        y_idw_grid(j,i) = f_idw_predict(x_new(t,:),[x_coord y_coord],coord,b);
        y_ann_grid(j,i) = net([y_lasso_grid(j,i) y_idw_grid(j,i)]');
        j = j + 1;
    end
    i = i + 1;
end


%% RENDERING 
x_coord = x_coord_lim(1)-spaced/2:spaced:x_coord_lim(2)+spaced/2;
y_coord = y_coord_lim(2)+spaced/2:-spaced:y_coord_lim(1)-spaced/2;

figure (1)
imagesc([min(min(x_coord)) max(max(x_coord))],...
    [min(min(y_coord)) max(max(y_coord))],y_lasso_grid)
hold on
% Display the monitoring station location on the maps.
plot(coord(:,1),coord(:,2),'+k','LineWidth',1)
hold off
ax1 = gca;
ax1.YDir = 'normal';
title('LASSO MODEL')
xlabel('X UTM')
ylabel('Y UTM')
colorbar

figure (2)
imagesc([min(min(x_coord)) max(max(x_coord))],...
    [min(min(y_coord)) max(max(y_coord))],y_idw_grid)
hold on
% Display the monitoring station location on the maps.
plot(coord(:,1),coord(:,2),'+k','LineWidth',1)
hold off
ax2 = gca;
ax2.YDir = 'normal';
title('IDW MODEL')
xlabel('X UTM')
ylabel('Y UTM')
colorbar

figure (3)
imagesc([min(min(x_coord)) max(max(x_coord))],...
    [min(min(y_coord)) max(max(y_coord))],y_ann_grid)
hold on
% Display the monitoring station location on the maps.
plot(coord(:,1),coord(:,2),'+k','LineWidth',1)
hold off
ax3 = gca;
ax3.YDir = 'normal';
title('ANN ENSEMBLE MODEL')
xlabel('X UTM')
ylabel('Y UTM')
colorbar



