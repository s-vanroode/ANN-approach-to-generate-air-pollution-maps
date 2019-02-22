function net = f_ann_mdl(x,y,nhiddens)

% INPUTS
% x                     Outputs of previous models as network input.  
%       
% y                     Network targets (expected values).  
%
% nhiddens              Number of units or hidden neurons.
% 
% OUTPUTS
% net                   Structure with the ann model information.

%-------------------------------------------------------------------------%

% Set network parameters
net = feedforwardnet(nhiddens);
net.trainParam.epochs = 100;
net.trainParam.goal = 0.001;
net.trainParam.showWindow = 0;
net = train(net,x',y');

