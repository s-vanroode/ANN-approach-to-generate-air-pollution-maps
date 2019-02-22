function mdl = f_lasso_mdl(x,coord,cv,varargin)

% INPUTS
% x                     Database is matrix (nrow,ncol) where columns are mo-
%                       nitoring stations and rows are the different points
%                       of time.  
%       
% coord                 Grid references where columns are (x_coord,y_coord)
%                       of each monitoring stations and rows are number of
%                       each monitoring station.  
%
% cv                    k-fold cross validation.
% 
% OUTPUTS
% mdl                   Structure with the lasso model information
%                       
% VARARGIN
% 'InteractionPar'      Add to the new database a variable type that is an
%                       interaction between the measured variable and the 
%                       distance. It is false by default.
% 
% 'Standarize'          It is true by default. 
%
% 'Criteria'            Specifies the lambda value selection criteria.
%
%                       'mimMSE'    Lambda value with the minimum MSE. By
%                                   default.
%                       '1SE'       Largest Lambda value such that MSE is 
%                                   within one standard error of the mini- 
%                                   mum MSE.

%-------------------------------------------------------------------------%
% NAMING
% s - station
% l - length
% n - number
% u - index
% v - vector
% m - matrix
% test - test
% tv - training and validation
% st - estandarized
%-------------------------------------------------------------------------%
% VARARGIN
p = inputParser;

addParameter(p, 'InteractionPar', false, @islogical)
addParameter(p, 'Standardize', true, @islogical)
addParameter(p, 'Criteria', 'minMSE', @(s) ismember(s,{'mimMSE','1SE'}))

parse(p,varargin{:})
disp(p.Results)
%-------------------------------------------------------------------------%

if p.Results.InteractionPar
    [x_lasso_input,y_lasso_input] = f_lasso_input_mdl(x,coord,'InteractionPar',true);
else
    [x_lasso_input,y_lasso_input] = f_lasso_input_mdl(x,coord);
end

% mdlel
[~,FitInfo] = lasso(x_lasso_input,y_lasso_input,'CV',cv,...
    'Standardize',p.Results.Standardize,...
    'Options',statset('UseParallel',true));

if strcmp(p.Results.Criteria, 'mimMSE')
    [B1,FitInfo1] = lasso(x_lasso_input,y_lasso_input,...
        'Lambda',FitInfo.LambdaMinMSE,...
        'Standardize',p.Results.Standardize,...
        'Options',statset('UseParallel',true));
    
else
    [B1,FitInfo1] = lasso(x_lasso_input,y_lasso_input,...
        'Lambda',FitInfo.Lambda1SE,...
        'Standardize',p.Results.Standardize,...
        'Options',statset('UseParallel',true));
    
end

mdl.B = B1;
mdl.FitInfo = FitInfo1;