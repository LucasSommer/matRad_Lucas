function c = matRad_constraintFunctions(optiProb,w,dij,cst)
% matRad IPOPT callback: constraint function for inverse planning 
% supporting max dose constraint, min dose constraint, min mean dose constraint, 
% max mean dose constraint, min EUD constraint, max EUD constraint, 
% max DVH constraint, min DVH constraint 
% 
% call
%   c = matRad_constraintFunctions(optiProb,w,dij,cst)
%
% input
%   optiProb:   option struct defining the type of optimization
%   w:          bixel weight vector
%   dij:        dose influence matrix
%   cst:        matRad cst struct
%
% output
%   c:          value of constraints
%
% References
%   -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2016 the matRad development team.
%
% This file is part of the matRad project. It is subject to the license
% terms in the LICENSE file found in the top-level directory of this
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part
% of the matRad project, including this file, may be copied, modified,
% propagated, or distributed except according to the terms contained in the
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get current dose / effect / RBExDose vector
optiProb.BP.compute(dij,w);
d = optiProb.BP.GetResult();

% get the used scenarios
useScen  = optiProb.BP.scenarios;
scenProb = optiProb.BP.scenarioProb;

% retrieve matching 4D scenarios
fullScen = cell(ndims(d),1);
[fullScen{:}] = ind2sub(size(d),useScen);
contourScen = fullScen{1};

% Initializes constraints
c = [];

% compute objective function for every VOI.
for  i = 1:size(optiProb.constrIdx,1)
         
      constraint = optiProb.constraints{i};
      curConIdx = optiProb.constrIdx(i,1);
      
      robustness = constraint.robustness;
         
      switch robustness
         case 'none' % if conventional opt: just sum objectives of nominal dose
            d_i = d{1}(cst{curConIdx,4}{1});
            c = [c; constraint.computeDoseConstraintFunction(d_i)];
            
         case 'PROB' % if prob opt: sum up expectation value of objectives
            
            d_i = dExp{1}(cst{curConIdx,4}{1});
            c = [c; constraint.computeDoseConstraintFunction(d_i)];
            
         case 'VWWC'  % voxel-wise worst case - takes minimum dose in TARGET and maximum in OAR
            contourIx = unique(contourScen);
            if ~isscalar(contourIx)
                  % voxels need to be tracked through the 4D CT,
                  % not yet implemented
                  matRad_cfg.dispError('4D VWWC optimization is currently not supported');
            end
            
            % prepare min/max dose vector
            if ~exist('d_tmp','var')
                  d_tmp = [d{useScen}];
            end
            
            d_Scen = d_tmp(cst{curConIdx,4}{contourIx},:);
            
            d_max = max(d_Scen,[],2);
            d_min = min(d_Scen,[],2);
            
            if isequal(cst{curConIdx,3},'OAR')
                  d_i = d_max;
            elseif isequal(cst{curConIdx,3},'TARGET')
                  d_i = d_min;
            end
            
            c = [c; constraint.computeDoseConstraintFunction(d_i)];
            
         case 'VWWC_INV'  %inverse voxel-wise conformitiy - takes maximum dose in TARGET and minimum in OAR
            contourIx = unique(contourScen);
            if ~isscalar(contourIx)
                  % voxels need to be tracked through the 4D CT,
                  % not yet implemented
                  matRad_cfg.dispError('4D inverted VWWC optimization is currently not supported');
            end
            
            % prepare min/max dose vector
            if ~exist('d_tmp','var')
                  d_tmp = [d{:}];
            end
            
            d_Scen = d_tmp(cst{curConIdx,4}{contourIx},:);
            d_max = max(d_Scen,[],2);
            d_min = min(d_Scen,[],2);
            
            if isequal(cst{curConIdx,3},'OAR')
                  d_i = d_min;
            elseif isequal(cst{curConIdx,3},'TARGET')
                  d_i = d_max;
            end
            
            c = [c; constraint.computeDoseConstraintFunction(d_i)];   
         otherwise
            matRad_cfg.dispError('Robustness setting %s not yet supported!',constraint.robustness);
      end 
         
end % if we are a constraint
end
   % if structure not empty and oar or target
