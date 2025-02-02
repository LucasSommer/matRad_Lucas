%% Example: Photon Treatment Plan with Direct aperture optimization
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2017 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% In this example we will show 
% (i) how to load patient data into matRad
% (ii) how to setup a photon dose calculation and 
% (iii) how to inversely optimize directly from command window in MatLab.
% (iv) how to apply a sequencing algorithm
% (v) how to run a direct aperture optimization
% (iv) how to visually and quantitatively evaluate the result

%% set matRad runtime configuration
matRad_rc; %If this throws an error, run it from the parent directory first to set the paths

%% Patient Data Import
% import the head & neck patient into your workspace.

load('HEAD_AND_NECK.mat');

%% Treatment Plan
% The next step is to define your treatment plan labeled as 'pln'. This 
% structure requires input from the treatment planner and defines 
% the most important cornerstones of your treatment plan.

pln.radiationMode   = 'photons';   % either photons / protons / carbon
pln.machine         = 'Generic';
pln.numOfFractions  = 30;
 
pln.propStf.gantryAngles    = [0:72:359];
pln.propStf.couchAngles     = [0 0 0 0 0];
pln.propStf.bixelWidth      = 5;
pln.propStf.numOfBeams      = numel(pln.propStf.gantryAngles);
pln.propStf.isoCenter       = ones(pln.propStf.numOfBeams,1) * matRad_getIsoCenter(cst,ct,0);

quantityOpt   = 'physicalDose';     % either  physicalDose / effect / RBExD
modelName     = 'none';             % none: for photons, protons, carbon                                    constRBE: constant RBE model
                                    % MCN: McNamara-variable RBE model for protons                          WED: Wedenberg-variable RBE model for protons 
                                    % LEM: Local Effect Model for carbon ions
% retrieve bio model parameters
pln.bioParam = matRad_bioModel(pln.radiationMode,quantityOpt, modelName);

% retrieve scenarios for dose calculation and optimziation
pln.multScen = matRad_multScen(ct,'nomScen');

% dose calculation settings
pln.propDoseCalc.doseGrid.resolution.x = 3; % [mm]
pln.propDoseCalc.doseGrid.resolution.y = 3; % [mm]
pln.propDoseCalc.doseGrid.resolution.z = 3; % [mm]

% We can also use other solver for optimization than IPOPT. matRad 
% currently supports fmincon from the MATLAB Optimization Toolbox. First we
% check if the fmincon-Solver is available, and if it es, we set in in the
% pln.propOpt.optimizer vairable. Otherwise wie set to the default
% optimizer 'IPOPT'
if matRad_OptimizerFmincon.IsAvailable()
    pln.propOpt.optimizer = 'fmincon';   
else
    pln.propOpt.optimizer = 'IPOPT';
end

%%
% Enable sequencing and direct aperture optimization (DAO).
pln.propSeq.runSequencing = true;
pln.propOpt.runDAO        = true;

%% Generate Beam Geometry STF
stf = matRad_generateStf(ct,cst,pln);

%% Dose Calculation
% Lets generate dosimetric information by pre-computing dose influence 
% matrices for unit beamlet intensities. Having dose influences available 
% allows for subsequent inverse optimization.
dij = matRad_calcDoseInfluence(ct,cst,stf,pln);

%% Inverse Planning for IMRT
% The goal of the fluence optimization is to find a set of beamlet weights 
% which yield the best possible dose distribution according to the 
% predefined clinical objectives and constraints underlying the radiation 
% treatment. Once the optimization has finished, trigger once the GUI to
% visualize the optimized dose cubes.
resultGUI = matRad_fluenceOptimization(dij,cst,pln);
matRadGUI;

%% Sequencing
% This is a multileaf collimator leaf sequencing algorithm that is used in 
% order to modulate the intensity of the beams with multiple static 
% segments, so that translates each intensity map into a set of deliverable 
% aperture shapes.
resultGUI = matRad_sequencing(resultGUI,stf,dij,pln);

%% DAO - Direct Aperture Optimization
% The Direct Aperture Optimization is an optimization approach where we 
% directly optimize aperture shapes and weights.
resultGUI = matRad_directApertureOptimization(dij,cst,resultGUI.apertureInfo,resultGUI,pln);

%% Aperture visualization
% Use a matrad function to visualize the resulting aperture shapes
matRad_visApertureInfo(resultGUI.apertureInfo);

%% Indicator Calculation and display of DVH and QI
[dvh,qi] = matRad_indicatorWrapper(cst,pln,resultGUI,[],[]);
