%% Example: Proton Treatment Plan with subsequent Isocenter shift
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
% (ii) how to setup a proton dose calculation 
% (iii) how to inversely optimize the pencil beam intensities directly from command window in MATLAB. 
% (iv) how to simulate a lateral patient displacement by shifting the iso-center 
% (v) how to recalculated the dose considering the shifted geometry and the previously optimized pencil beam intensities
% (vi) how to compare the two results

%% set matRad runtime configuration
matRad_rc; %If this throws an error, run it from the parent directory first to set the paths

%% Patient Data Import
% Let's begin with a clear Matlab environment and import the prostate
% patient into your workspace

load('PROSTATE.mat');

%% Treatment Plan
% The next step is to define your treatment plan labeled as 'pln'. This 
% structure requires input from the treatment planner and defines the most 
% important cornerstones of your treatment plan.

%%
% First of all, we need to define what kind of radiation modality we would
% like to use. Possible values are photons, protons or carbon. In this
% example we would like to use protons for treatment planning. Next, we
% need to define a treatment machine to correctly load the corresponding 
% base data. matRad features generic base data in the file
% 'proton_Generic.mat'; consequently the machine has to be set accordingly
pln.radiationMode = 'protons';        
pln.machine       = 'Generic';

%%
% for particles it is possible to also calculate the LET disutribution
% alongside the physical dose. Therefore you need to activate the
% corresponding option during dose calculcation. We also explicitly say to
% use the Hong Pencil Beam Algorithm
pln.propDoseCalc.calcLET = 0;
pln.propDoseCalc.engine = 'HongPB';
                                       
%%
% Now we have to set the remaining plan parameters.
pln.numOfFractions        = 30;
pln.propStf.gantryAngles  = [90 270];
pln.propStf.couchAngles   = [0 0];
pln.propStf.bixelWidth    = 5;
pln.propStf.numOfBeams    = numel(pln.propStf.gantryAngles);
pln.propStf.isoCenter     = ones(pln.propStf.numOfBeams,1) * matRad_getIsoCenter(cst,ct,0);
pln.propOpt.runDAO        = 0;
pln.propSeq.runSequencing = 0;

% Define the flavor of biological optimization for treatment planning along
% with the quantity that should be used for optimization.

quantityOpt   = 'RBExD';            % either  physicalDose / effect / RBExD
modelName     = 'constRBE';         % none: for photons, protons, carbon                                    constRBE: constant RBE model
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

%% Generate Beam Geometry STF
stf = matRad_generateStf(ct,cst,pln);

%% Dose Calculation
% Lets generate dosimetric information by pre-computing dose influence 
% matrices for unit beamlet intensities. Having dose influences available 
% allows for subsequent inverse optimization. 
dij = matRad_calcDoseInfluence(ct,cst,stf,pln);

%% Inverse Optimization for IMPT
% The goal of the fluence optimization is to find a set of bixel/spot 
% weights which yield the best possible dose distribution according to the 
% clinical objectives and constraints underlying the radiation treatment
resultGUI = matRad_fluenceOptimization(dij,cst,pln);

%% Plot the Resulting Dose Slice
% Let's plot the transversal iso-center dose slice
slice = round(pln.propStf.isoCenter(1,3)./ct.resolution.z);
figure
imagesc(resultGUI.RBExD(:,:,slice)),colorbar,colormap(jet)

%% Plot the Resulting Beam Dose Slice
% Let's plot the transversal iso-center dose slice of beam 1 and beam 2
% separately 
figure
subplot(121),imagesc(resultGUI.RBExD_beam1(:,:,slice)),colorbar,colormap(jet),title('dose of beam 1')
subplot(122),imagesc(resultGUI.RBExD_beam2(:,:,slice)),colorbar,colormap(jet),title('dose of beam 2')
%% and the corresponding LET distribution
% Transversal iso-center slice
if pln.propDoseCalc.calcLET
    figure
    imagesc(resultGUI.LET(:,:,slice)),colormap(jet),colorbar,title('LET [keV/�m]')
end
%%
% Now let's simulate a patient shift in y direction for both beams
stf(1).isoCenter(2) = stf(1).isoCenter(2) - 4;
stf(2).isoCenter(2) = stf(2).isoCenter(2) - 4;
pln.propStf.isoCenter       = reshape([stf.isoCenter],[3 pln.propStf.numOfBeams])';

%% Recalculate Plan
% Let's use the existing optimized pencil beam weights and recalculate the RBE weighted dose
resultGUI_isoShift = matRad_calcDoseDirect(ct,stf,pln,cst,resultGUI.w);

%%  Visual Comparison of results
% Let's compare the new recalculation against the optimization result.
plane = 3;
doseWindow = [0 max([resultGUI.RBExD(:); resultGUI_isoShift.RBExD(:)])];

figure,title('original plan')
matRad_plotSliceWrapper(gca,ct,cst,1,resultGUI.RBExD,plane,slice,[],0.75,colorcube,[],doseWindow,[]);
figure,title('shifted plan')
matRad_plotSliceWrapper(gca,ct,cst,1,resultGUI_isoShift.RBExD,plane,slice,[],0.75,colorcube,[],doseWindow,[]);

absDiffCube = resultGUI.RBExD-resultGUI_isoShift.RBExD;
figure,title('absolute difference')
matRad_plotSliceWrapper(gca,ct,cst,1,absDiffCube,plane,slice,[],[],colorcube);

% Let's plot single profiles that are perpendicular to the beam direction
ixProfileY = round(pln.propStf.isoCenter(1,2)./ct.resolution.y);

profileOrginal = resultGUI.RBExD(:,ixProfileY,slice);
profileShifted = resultGUI_isoShift.RBExD(:,ixProfileY,slice);

figure,plot(profileOrginal,'LineWidth',2),grid on,hold on,
plot(profileShifted,'LineWidth',2),legend({'original profile','shifted profile'}),
xlabel('mm'),ylabel('Gy(RBE)'),title('profile plot')
%% Quantitative Comparison of results
% Compare the two dose cubes using a gamma-index analysis. The gamma index
% is a composite quality distribution equally taking into account a dose 
% difference and a distance to agreement criterion in order to quantify
% differences between two dose cubes. A gamma-index value of smaller than 1
% indicates a successful test and a value greater than 1 illustrates a 
% failed test. An alternative analysis could be performed with the 
% matRad_compareDose function, which includes the gamma test

doseDifference  = 2;
distToAgreement = 2;
n               = 1;

[gammaCube,gammaPassRateCell] = matRad_gammaIndex(...
    resultGUI_isoShift.RBExD,resultGUI.RBExD,...
    [ct.resolution.x, ct.resolution.y, ct.resolution.z],...
    [doseDifference distToAgreement],slice,n,'global',cst);

% Let's plot the gamma index histogram
figure
hist(gammaCube(gammaCube>0),100)
title('gamma index histogram')


