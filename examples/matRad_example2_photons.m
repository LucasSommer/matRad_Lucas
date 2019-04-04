%% Example: Photon Treatment Plan
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
% (iii) how to inversely optimize beamlet intensities
% (iv) how to visually and quantitatively evaluate the result

%% set matRad runtime configuration
matRad_rc

%% Patient Data Import
load('TG119.mat');

%%
% The file TG119.mat contains two Matlab variables. Let's check what we 
% have just imported. First, the 'ct' variable comprises the ct cube along
%with some meta information describing properties of the ct cube (cube 
% dimensions, resolution, number of CT scenarios). Please note that 
%multiple ct cubes (e.g. 4D CT) can be stored in the cell array ct.cube{}
if param.logLevel == 1
    display(ct);
end
%%
% The 'cst' cell array defines volumes of interests along with information 
% required for optimization. Each row belongs to one certain volume of 
% interest (VOI), whereas each column defines different properties. 
% Specifically, the second and third column  show the name and the type of 
% the structure. The type can be set to OAR, TARGET or IGNORED. The fourth 
% column contains a linear index vector that lists all voxels belonging to 
% a certain VOI.
if param.logLevel == 1
    display(cst);
end
%%
% The fifth column represents meta parameters for optimization. The overlap
% priority is used to resolve ambiguities of overlapping structures (voxels 
% belonging to multiple structures will only be assigned to the VOI(s) with
% the highest overlap priority, i.e.. the lowest value). The parameters 
% alphaX and betaX correspond to the tissue's photon-radiosensitivity 
% parameter of the linear quadratic model. These parameter are required for
% biological treatment planning using a variable RBE. Let's output the meta 
% optimization parameter of the target, which is stored in the thrid row:
if param.logLevel == 1
    ixTarget = 3;
    display(cst{ixTarget,5});
end
%%
% The sixth column contains optimization information such as objectives and
% constraints which are required to calculate the objective function value. 
% Please note, that multiple objectives/constraints can be defined for
% individual structures. Here, we have defined a squared deviation 
% objective making it 'expensive/costly' for the optimizer to over- and 
% underdose the target structure (both are equally important). 
if param.logLevel == 1
    display(cst{ixTarget,6});
end
%% Treatment Plan
% The next step is to define your treatment plan labeled as 'pln'. This 
% matlab structure requires input from the treatment planner and defines 
% the most important cornerstones of your treatment plan.

%%
% First of all, we need to define what kind of radiation modality we would
% like to use. Possible values are photons, protons or carbon. In this case
% we want to use photons. Then, we need to define a treatment machine to 
% correctly load the corresponding base data. matRad includes base data for
% generic photon linear accelerator called 'Generic'. By this means matRad 
% will look for 'photons_Generic.mat' in our root directory and will use 
% the data provided in there for dose calculation
pln.radiationMode = 'photons';  
pln.machine       = 'Generic';

%%
% Define the flavor of optimization along with the quantity that should be
% used for optimization. Possible quantities used for optimization are: 
% physicalDose: physical dose based optimization; 
% effect: biological effect based optimization;
% RBExD: RBE weighted dose based optimzation;
% Possible biological models are:
% none:        use no specific biological model
% constRBE:    use a constant RBE
% MCN:         use the variable RBE McNamara model for protons
% WED:         use the variable RBE Wedenberg model for protons
% LEM:         use the biophysical variable RBE Local Effect model for carbons
% As we are  using photons, we simply set the parameter to 'physicalDose' and
% and 'none'
quantityOpt    = 'physicalDose';                                     
modelName      = 'none';  

%%
% Now we have to set some beam parameters. We can define multiple beam 
% angles for the treatment and pass these to the plan as a vector. matRad 
% will then interpret the vector as multiple beams. In this case, we define
% linear spaced beams from 0 degree to 359 degree in 40 degree steps. This 
% results in 9 beams. All corresponding couch angles are set to 0 at this 
% point. Moreover, we set the bixelWidth to 5, which results in a beamlet 
% size of 5 x 5 mm in the isocenter plane. The number of fractions is set 
% to 30. Internally, matRad considers the fraction dose for optimization, 
% however, objetives and constraints are defined for the entire treatment.
pln.numOfFractions         = 30;
pln.propStf.gantryAngles   = [0:40:359];
pln.propStf.couchAngles    = zeros(1,numel(pln.propStf.gantryAngles));
pln.propStf.bixelWidth     = 5;

%%
% Obtain the number of beams and voxels from the existing variables and 
% calculate the iso-center which is per default the center of gravity of 
% all target voxels.
pln.propStf.numOfBeams      = numel(pln.propStf.gantryAngles);
pln.propStf.isoCenter       = ones(pln.propStf.numOfBeams,1) * matRad_getIsoCenter(cst,ct,0);

%%
% Enable sequencing and disable direct aperture optimization (DAO) for now.
% A DAO optimization is shown in a seperate example.
pln.propOpt.runSequencing = 1;
pln.propOpt.runDAO        = 0;

% retrieve bio model parameters
pln.bioParam = matRad_bioModel(pln.radiationMode,quantityOpt, modelName);

% retrieve scenarios for dose calculation and optimziation
pln.multScen = matRad_multScen(ct,'nomScen');

%%
% and et voila our treatment plan structure is ready. Lets have a look:
if param.logLevel == 1
    display(pln);
end

%% Generate Beam Geometry STF
% The steering file struct comprises the complete beam geometry along with 
% ray position, pencil beam positions and energies, source to axis distance (SAD) etc.
stf = matRad_generateStf(ct,cst,pln,param);

%%
% Let's display the beam geometry information of the 6th beam
if param.logLevel == 1
    display(stf(6));
end
%% Dose Calculation
% Let's generate dosimetric information by pre-computing dose influence 
% matrices for unit beamlet intensities. Having dose influences available 
% allows subsequent inverse optimization.
dij = matRad_calcPhotonDose(ct,stf,pln,cst,param);

%% Inverse Optimization for IMRT
% The goal of the fluence optimization is to find a set of beamlet/pencil 
% beam weights which yield the best possible dose distribution according to
% the clinical objectives and constraints underlying the radiation 
% treatment. Once the optimization has finished, trigger once the GUI to 
% visualize the optimized dose cubes.
resultGUI = matRad_fluenceOptimization(dij,cst,pln,param);
matRadGUI;

%% Plot the Resulting Dose Slice
% Let's plot the transversal iso-center dose slice
if param.logLevel == 1
    slice = round(pln.propStf.isoCenter(1,3)./ct.resolution.z);
    figure
    imagesc(resultGUI.physicalDose(:,:,slice)),colorbar, colormap(jet);
end
%% Now let's create another treatment plan but this time use a coarser beam spacing.
% Instead of 40 degree spacing use a 50 degree geantry beam spacing
pln.propStf.gantryAngles = [0:50:359];
pln.propStf.couchAngles  = zeros(1,numel(pln.propStf.gantryAngles));
pln.propStf.numOfBeams   = numel(pln.propStf.gantryAngles);
stf                      = matRad_generateStf(ct,cst,pln,param);
pln.propStf.isoCenter    = stf.isoCenter;
dij                      = matRad_calcPhotonDose(ct,stf,pln,cst,param);
resultGUI_coarse         = matRad_fluenceOptimization(dij,cst,pln,param);

%%  Visual Comparison of results
% Let's compare the new recalculation against the optimization result.
% Check if you have added all subdirectories to the Matlab search path,
% otherwise it will not find the plotting function
if param.logLevel == 1
    plane      = 3;
    doseWindow = [0 max([resultGUI.physicalDose(:); resultGUI_coarse.physicalDose(:)])];

    figure,title('original plan - fine beam spacing')
    matRad_plotSliceWrapper(gca,ct,cst,1,resultGUI.physicalDose,plane,slice,[],0.75,colorcube,[],doseWindow,[]);
    figure,title('modified plan - coarse beam spacing')
    matRad_plotSliceWrapper(gca,ct,cst,1,resultGUI_coarse.physicalDose,plane,slice,[],0.75,colorcube,[],doseWindow,[]);
end
%% 
% At this point we would like to see the absolute difference of the first 
% optimization (finer beam spacing) and the second optimization (coarser 
% beam spacing)
if param.logLevel == 1
    absDiffCube = resultGUI.physicalDose-resultGUI_coarse.physicalDose;
    figure,title( 'fine beam spacing plan - coarse beam spacing plan')
    matRad_plotSliceWrapper(gca,ct,cst,1,absDiffCube,plane,slice,[],[],colorcube);
end

%% Obtain dose statistics
% Two more columns will be added to the cst structure depicting the DVH and
% standard dose statistics such as D95,D98, mean dose, max dose etc.
[dvh,qi]               = matRad_indicatorWrapper(cst,pln,resultGUI);
[dvh_coarse,qi_coarse] = matRad_indicatorWrapper(cst,pln,resultGUI_coarse);

%%
% The treatment plan using more beams should in principle result in a
% better OAR sparing. Therefore lets have a look at the D95 of the OAR of 
% both plans
if param.logLevel == 1
    ixOAR = 2;
    display(qi(ixOAR).D_95);
    display(qi_coarse(ixOAR).D_95);
end