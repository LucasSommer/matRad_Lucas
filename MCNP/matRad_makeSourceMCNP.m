function [control_makeSourceMCNP, varHelper] = matRad_makeSourceMCNP(stf, pln, varHelper, counterField, counterRay)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write source data as MCNP input file. For each bixel/ray an individual
% MCNP input file is generated, where position of the source is defined by
% opening of Multi-Leaf Collimator and optional energyspectrum of
% particles.
% Note: Dose calculation for radiation fields based on RSSA data is
% selected by setting pln.propStf.bixelWidth to 'field'. IMRT or square
% field dose calculation for pure neutron or mixed neutron-gamma sources is
% selected from selected machine (please check readme.txt in the
% MCNP dose engine folder).
%
% call
%   [control_makeSourceMCNP, fileID_C, nameListRays] = matRad_makeSourceMCNP(stf, pln, varHelper, counterField, counterRay)
%
% input
%   stf:    steering information structure used to position square source
%           for every ray individually in lps system and control source
%           particles, spectral information and initial direction of flight
%   pln:    matRad plan meta information struct
%
% output:   varHelper with new element .simPropMCNP.fileID_C containing
%           individual file IDs for all bixels s.th. runfiles can be put
%           together later
%
% References
%   [1] PELOWITZ, D. B., et al. MCNP6 User�s Manual. LACP-00634, May, 2013.
%
% Author: Lucas Sommer (Lucas.Sommer@tum.de), 11/2018
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

matRad_cfg =  MatRad_Config.instance();

%% Check source input and create source part of runfile
pathRunfiles = fullfile(matRad_cfg.matRadRoot, 'submodules', 'MCdoseEngineMCNP', 'runfiles_tmp', filesep);

%% Option A: Predefined field using RSSA file
if strcmp(num2str(pln.propStf.bixelWidth),'field')
    pathRSSA = fullfile(matRad_cfg.matRadRoot, 'submodules', 'MCdoseEngineMCNP', 'RSSA_depot', filesep);
    makeSource_readRSSA(stf, pln, varHelper, pathRunfiles, pathRSSA)
    control_makeSourceMCNP = 1;

    %% Option B: only neutrons but with spectral information
elseif strcmp(pln.radiationMode, 'neutrons') ...
        && ~isstring(pln.propStf.bixelWidth) ...
        && strcmp(num2str(stf(counterField).ray(counterRay).energy), 'spectralDistribution') ...
        && strcmp(pln.machine,'MCNPneutronField')

    % Get list of available tabulated neutron spectra
    spectralInformation.pathLocation = fullfile(matRad_cfg.matRadRoot, 'submodules', 'MCdoseEngineMCNP', 'SpectralInformation', filesep);
    spectralInformation.neutronSpectrum = dir([spectralInformation.pathLocation, 'spectrum_neutrons_*']);

    % Check if there is more than one neutron spectrum available in
    % ../MATRAD/MCdoseEngineMCNP/SpectralInformation
    if size(spectralInformation.neutronSpectrum,1)~=1
        [spectralInformation.neutronIndex,~] = listdlg('PromptString','Please select neutron spectrum:',...
            'SelectionMode','single',...
            'ListString',{spectralInformation.neutronSpectrum.name});
    else
        spectralInformation.neutronIndex = 1;
    end

    % Read spectral information from selected file with first column as
    % energy and second column as spectral information
    fid_neutronSpectrum = fopen([spectralInformation.neutronSpectrum(spectralInformation.neutronIndex).folder, filesep, spectralInformation.neutronSpectrum(spectralInformation.neutronIndex).name], 'r');
    spectralInformation.spectrumValuesNeutrons = fscanf(fid_neutronSpectrum, '%f', [2,inf]);
    spectralInformation.spectrumValuesNeutrons = spectralInformation.spectrumValuesNeutrons';
    fclose(fid_neutronSpectrum);

    makeSource_spectralInformationNeutrons(stf, varHelper, pathRunfiles, counterField, counterRay,spectralInformation)
    control_makeSourceMCNP = 1;

    %% Option C: only photons but with spectral information
elseif strcmp(pln.radiationMode, 'photons') ...
        && ~isstring(pln.propStf.bixelWidth) ...
        && strcmp(num2str(stf(counterField).ray(counterRay).energy), 'spectralDistribution') ...
        && strcmp(pln.machine,'MCNPphotonField')

    % Get list of available tabulated photon spectra
    spectralInformation.pathLocation = fullfile(matRad_cfg.matRadRoot, 'submodules', 'MCdoseEngineMCNP', 'SpectralInformation', filesep);
    spectralInformation.photonSpectrum = dir([spectralInformation.pathLocation, 'spectrum_photons_*']);

    % Check if there is more than one photon spectra available in
    % ../MATRAD/MCNP/SpectralInformation
    if size(spectralInformation.photonSpectrum,1)~=1
        [spectralInformation.photonIndex,~] = listdlg('PromptString','Please select photon spectrum:',...
            'SelectionMode','single',...
            'ListString',{spectralInformation.photonSpectrum.name});
    else
        spectralInformation.photonIndex = 1;
    end

    % Read spectral information from selected file with first column as
    % energy and second column as spectral information
    fid_photonSpectrum = fopen([spectralInformation.photonSpectrum(spectralInformation.photonIndex).folder, filesep, spectralInformation.photonSpectrum(spectralInformation.photonIndex).name], 'r');
    spectralInformation.spectrumValuesPhotons = fscanf(fid_photonSpectrum, '%f', [2,inf]);
    spectralInformation.spectrumValuesPhotons = spectralInformation.spectrumValuesPhotons';
    fclose(fid_photonSpectrum);

    makeSource_spectralInformationPhotons(stf, varHelper,pathRunfiles,spectralInformation)
    control_makeSourceMCNP = 1;
    %% Option D: neutrons and photons with spectral information
elseif strcmp(pln.radiationMode, 'neutrons') ...
        && ~isstring(pln.propStf.bixelWidth) ...
        && strcmp(num2str(stf(counterField).ray(counterRay).energy), 'spectralDistribution') ...
        && strcmp(pln.machine,'MCNPmixedField')

    % Get list of available tabulated neutron spectra
    spectralInformation.pathLocation = fullfile(matRad_cfg.matRadRoot, 'submodules', 'MCdoseEngineMCNP', 'SpectralInformation', filesep);
    spectralInformation.neutronSpectrum = dir([spectralInformation.pathLocation, 'spectrum_neutrons_*']);
    spectralInformation.photonSpectrum = dir([spectralInformation.pathLocation, 'spectrum_photons_*']);

    % Check if there is more than one neutron spectrum available in
    % ../MATRAD/MCNP/SpectralInformation
    if size(spectralInformation.neutronSpectrum,1)~=1
        [spectralInformation.neutronIndex,~] = listdlg('PromptString','Please select neutron spectrum:',...
            'SelectionMode','single',...
            'ListString',{spectralInformation.neutronSpectrum.name});
    else
        spectralInformation.neutronIndex = 1;
    end
    % Same for photons
    if size(spectralInformation.photonSpectrum,1)~=1
        [spectralInformation.photonIndex,~] = listdlg('PromptString','Please select photon spectrum:',...
            'SelectionMode','single',...
            'ListString',{spectralInformation.photonSpectrum.name});
    else
        spectralInformation.photonIndex = 1;
    end

    % Read spectral information from selected file with first column as
    % energy and second column as spectral information
    % Neutrons
    fid_neutronSpectrum = fopen([spectralInformation.neutronSpectrum(spectralInformation.neutronIndex).folder, filesep, spectralInformation.neutronSpectrum(spectralInformation.neutronIndex).name], 'r');
    spectralInformation.spectrumValuesNeutrons = fscanf(fid_neutronSpectrum, '%f', [2,inf]);
    spectralInformation.spectrumValuesNeutrons = spectralInformation.spectrumValuesNeutrons';
    fclose(fid_neutronSpectrum);
    % Photons
    fid_photonSpectrum = fopen([spectralInformation.photonSpectrum(spectralInformation.photonIndex).folder, filesep, spectralInformation.photonSpectrum(spectralInformation.photonIndex).name], 'r');
    spectralInformation.spectrumValuesPhotons = fscanf(fid_photonSpectrum, '%f', [2,inf]);
    spectralInformation.spectrumValuesPhotons = spectralInformation.spectrumValuesPhotons';
    fclose(fid_photonSpectrum);

    makeSource_spectralInformationNeutronsPlusPhotons(stf, varHelper,pathRunfiles,spectralInformation)
    control_makeSourceMCNP = 1;

    %% Option E: monoenergetic neutrons
elseif strcmp(pln.radiationMode, 'neutrons') ...
        && ~isstring(pln.propStf.bixelWidth) ...
        && isnumeric(stf(counterField).ray(counterRay).energy) ...
        && strcmp(pln.machine,'MCNPmonoEn')

    disp('*****')
    disp('Monoenergetic neutrons used for simulation.')
    disp('*****')

    makeSource_monoenN(stf, varHelper, pathRunfiles, counterField, counterRay)
    control_makeSourceMCNP = 1;

else
    error('No valid energy input for particle energy!')
end

%% Define functions here
    function makeSource_monoenN(stf, varHelper, pathRunfiles, counterField, counterRay)
        % Get rotation matrix
        rotMatrix = matRad_calcMCNProtMatrix(stf.gantryAngle, stf.couchAngle);
        % Calculate source position in original coordinate system
        sourcePoint = stf.sourcePoint_bev + stf(counterField).ray(counterRay).rayPos_bev;


        fileID_C = fopen(strcat(pathRunfiles,'blockC_source', int2str(varHelper.totalNumberBixels)), 'w');
        % Define source card, note: VEC=reference vector for the direction
        % sampling, DIR=cosine of angle between VEC and partice direction,
        % in case DIR=-1 a monodirectional source in counter direction of VEC
        source.sourceCard_0 = 'SDEF\n        X=d1 Y=%.4f Z=d2\n        VEC=0 1 0\n        DIR=1 PAR=1 ERG=%.4f TR=1\n';
        source.sourceCard_1_i = 'SI1 %.4f %.4f\n';  % Initial position and source extension
        source.sourceCard_1_p = 'SP1 0 1\n';
        source.sourceCard_2_i = 'SI2 %.4f %.4f\n';  % ...
        source.sourceCard_2_p = 'SP2 0 1\n';

        % Define coordinate transformation card
        coordTrafo.TRcard = 'TR1\n        %.4f %.4f %.4f\n        %.4f %.4f %.4f\n        %.4f %.4f %.4f\n        %.4f %.4f %.4f\n';

        % Write Block C
        fprintf(fileID_C, 'C ***************************************************************\n');
        fprintf(fileID_C, 'C C.1: Source\n');
        fprintf(fileID_C, 'C ***************************************************************\n');

        % Write initial source position and extension
        fprintf(fileID_C, source.sourceCard_0, ...
            sourcePoint(2)*varHelper.rescaleFactor, ...
            stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).energy);
        fprintf(fileID_C, source.sourceCard_1_i, ...
            (sourcePoint(1)-stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor, ...
            (sourcePoint(1)+stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor);
        fprintf(fileID_C, source.sourceCard_1_p);
        fprintf(fileID_C, source.sourceCard_2_i, ...
            (sourcePoint(3)-stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor, ...
            (sourcePoint(3)+stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor);
        fprintf(fileID_C, source.sourceCard_2_p);

        % Write TR card for spatial source transformation
        fprintf(fileID_C, coordTrafo.TRcard, ...
            stf.isoCenter(1)*varHelper.rescaleFactor, stf.isoCenter(2)*varHelper.rescaleFactor, stf.isoCenter(3)*varHelper.rescaleFactor, ...
            rotMatrix(1,1), rotMatrix(1,2), rotMatrix(1,3),...
            rotMatrix(2,1), rotMatrix(2,2), rotMatrix(2,3),...
            rotMatrix(3,1), rotMatrix(3,2), rotMatrix(3,3));
        fclose(fileID_C);
    end

    function makeSource_spectralInformationNeutrons(stf, varHelper, pathRunfiles, counterField, counterRay, spectralInformation)
        % Get rotation matrix
        rotMatrix = matRad_calcMCNProtMatrix(stf(counterField).gantryAngle, stf(counterField).couchAngle);
        % Calculate source position in original coordinate system
        sourcePoint = stf(counterField).sourcePoint_bev + stf(counterField).ray(counterRay).rayPos_bev;


        fileID_C = fopen(strcat(pathRunfiles,'blockC_source', int2str(varHelper.totalNumberBixels)), 'w');
        % Define source card, note: VEC=reference vector for the direction
        % sampling, DIR=cosine of angle between VEC and partice direction,
        % in case DIR=-1 a monodirectional source in counter direction of
        % VEC.
        % ERG=d3 used to define spectrum according to information read from
        % tabulated data in ..\MATRAD\MCNP\SpectralInformation
        
        source.sourceCard_0 = 'SDEF\n        X=d1 Y=%.4f Z=d2\n        VEC=0 1 0\n        DIR=1 PAR=1 ERG=d3 TR=1\n';
        source.sourceCard_1_i = 'SI1 %.4f %.4f\n';  % Initial position and source extension
        source.sourceCard_1_p = 'SP1 0 1\n';
        source.sourceCard_2_i = 'SI2 %.4f %.4f\n';  % ...
        source.sourceCard_2_p = 'SP2 0 1\n';
        source.energyCard_3_i_0 = 'SI3 H\n';        % Energy bins
        source.energyCard_3_i = '        %8d\n';
        source.energyCard_3_p_0 = 'SP3 D\n';        % Spectral information
        source.energyCard_3_p = '        %8d\n';

        % Define coordinate transformation card
        coordTrafo.TRcard = 'TR1\n        %.4f %.4f %.4f\n        %.4f %.4f %.4f\n        %.4f %.4f %.4f\n        %.4f %.4f %.4f\n';

        % Write Block C
        fprintf(fileID_C, 'C ***************************************************************\n');
        fprintf(fileID_C, 'C C.1: Source\n');
        fprintf(fileID_C, 'C ***************************************************************\n');

        % Write initial source position and extension
        fprintf(fileID_C, source.sourceCard_0, ...
            sourcePoint(2)*varHelper.rescaleFactor);
        fprintf(fileID_C, source.sourceCard_1_i, ...
            (sourcePoint(1)-stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor, ...
            (sourcePoint(1)+stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor);
        fprintf(fileID_C, source.sourceCard_1_p);
        fprintf(fileID_C, source.sourceCard_2_i, ...
            (sourcePoint(3)-stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor, ...
            (sourcePoint(3)+stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor);
        fprintf(fileID_C, source.sourceCard_2_p);

        % Write spectral distribution
        fprintf(fileID_C, source.energyCard_3_i_0);
        fprintf(fileID_C, source.energyCard_3_i, ...
            spectralInformation.spectrumValuesNeutrons(:,1));
        fprintf(fileID_C, source.energyCard_3_p_0);
        fprintf(fileID_C, source.energyCard_3_p, ...
            spectralInformation.spectrumValuesNeutrons(:,2));

        % Write TR card for spatial source transformation
        fprintf(fileID_C, coordTrafo.TRcard, ...
            stf(counterField).isoCenter(1)*varHelper.rescaleFactor, stf(counterField).isoCenter(2)*varHelper.rescaleFactor, stf(counterField).isoCenter(3)*varHelper.rescaleFactor, ...
            rotMatrix(1,1), rotMatrix(1,2), rotMatrix(1,3),...
            rotMatrix(2,1), rotMatrix(2,2), rotMatrix(2,3),...
            rotMatrix(3,1), rotMatrix(3,2), rotMatrix(3,3));

        % Close blockC_source file
        fclose(fileID_C);
    end

    function makeSource_spectralInformationPhotons(stf, varHelper, pathRunfiles, spectralInformation)

        fileID_C = fopen(strcat(pathRunfiles,'blockC_source', int2str(varHelper.totalNumberBixels)), 'w');
        % Define source card, note: VEC=reference vector for the direction
        % sampling, DIR=cosine of angle between VEC and partice direction,
        % in case DIR=-1 a monodirectional source in counter direction of
        % VEC.
        % ERG=d3 used to define spectrum according to information read from
        % tabulated data in ..\MATRAD\MCNP\SpectralInformation

        source.sourceCard_0 = 'SDEF\n        X=0 Y=d1 Z=d2\n        VEC=1 0 0\n        DIR=-1 PAR=2 ERG=d3 TR=1\n';
        source.sourceCard_1_i = 'SI1 %.4f %.4f\n';  % Initial position and source extension
        source.sourceCard_1_p = 'SP1 0 1\n';
        source.sourceCard_2_i = 'SI2 %.4f %.4f\n';  % ...
        source.sourceCard_2_p = 'SP2 0 1\n';
        source.energyCard_3_i_0 = 'SI3 H\n';        % Energy bins
        source.energyCard_3_i = '        %8d\n';
        source.energyCard_3_p_0 = 'SP3 D\n';        % Spectral information
        source.energyCard_3_p = '        %8d\n';

        % Define coordinate transformation card
        coordTrafo.TRcard = 'TR1\n        %.4f %.4f %.4f\n        %.4f 0 %.4f\n        0 1 0\n        %.4f 0 %.4f\n';

        % Write Block C
        fprintf(fileID_C, 'C ***************************************************************\n');
        fprintf(fileID_C, 'C C.1: Source\n');
        fprintf(fileID_C, 'C ***************************************************************\n');

        % Write initial source position and extension
        fprintf(fileID_C, source.sourceCard_0);
        fprintf(fileID_C, source.sourceCard_1_i, ...
            (-stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor, ...
            (stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor);
        fprintf(fileID_C, source.sourceCard_1_p);
        fprintf(fileID_C, source.sourceCard_2_i, ...
            (-stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor, ...
            (stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor);
        fprintf(fileID_C, source.sourceCard_2_p);

        % Write spectral distribution
        fprintf(fileID_C, source.energyCard_3_i_0);
        fprintf(fileID_C, source.energyCard_3_i, ...
            spectralInformation.spectrumValuesPhotons(:,1));
        fprintf(fileID_C, source.energyCard_3_p_0);
        fprintf(fileID_C, source.energyCard_3_p, ...
            spectralInformation.spectrumValuesPhotons(:,2));

        % Write TR card for spatial source transformation
        fprintf(fileID_C, coordTrafo.TRcard, ...
            stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).rayPosMLC(1)*varHelper.rescaleFactor, ...
            stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).rayPosMLC(2)*varHelper.rescaleFactor, ...
            stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).rayPosMLC(3)*varHelper.rescaleFactor, ...
            cosd(stf(varHelper.simPropMCNP.counterField).couchAngle), ...
            sind(stf(varHelper.simPropMCNP.counterField).couchAngle), ...
            -sind(stf(varHelper.simPropMCNP.counterField).couchAngle), ...
            cosd(stf(varHelper.simPropMCNP.counterField).couchAngle));

        % Close blockC_source file
        fclose(fileID_C);
    end

    function makeSource_spectralInformationNeutronsPlusPhotons(stf, varHelper, pathRunfiles, spectralInformation)

        fileID_C = fopen(strcat(pathRunfiles,'blockC_source', int2str(varHelper.totalNumberBixels)), 'w');
        % Define source card, note: VEC=reference vector for the direction
        % sampling, DIR=cosine of angle between VEC and partice direction,
        % in case DIR=-1 a monodirectional source in counter direction of
        % VEC.
        % ERG=d3 used to define spectrum according to information read from
        % tabulated data in ..\MATRAD\MCNP\SpectralInformation

        source.sourceCard_0 = 'SDEF\n        X=0 Y=d1 Z=d2\n        VEC=1 0 0\n        DIR=-1 PAR=d3 ERG=fpar=d4 TR=1\n';
        source.sourceCard_1_i = 'SI1 %.4f %.4f\n';  % Initial position and source extension
        source.sourceCard_1_p = 'SP1 0 1\n';
        source.sourceCard_2_i = 'SI2 %.4f %.4f\n';  % ...
        source.sourceCard_2_p = 'SP2 0 1\n';
        source.particleDistribution_i = 'SI3 L 1 2\n';
        error('Relation of neutron and photons fluence not implemented yet.')
        % source.particleDistribution_p = 'SP3 ? ?\n';
        source.particleEnergyDistributions = 'DS4 S 5 6\n';
        source.neutronEnergyCard_5_i_0 = 'SI5 H\n';        % Energy bins neutrons
        source.neutronEnergyCard_5_i = '        %8d\n';
        source.neutronEnergyCard_5_p_0 = 'SP5 D\n';        % Spectral information neutrons
        source.neutronEnergyCard_5_p = '        %8d\n';
        source.photonEnergyCard_6_i_0 = 'SI6 H\n';        % Energy bins photons
        source.photonEnergyCard_6_i = '        %8d\n';
        source.photonEnergyCard_6_p_0 = 'SP6 D\n';        % Spectral information photons
        source.photonEnergyCard_6_p = '        %8d\n';

        % Define coordinate transformation card
        coordTrafo.TRcard = 'TR1\n        %.4f %.4f %.4f\n        %.4f 0 %.4f\n        0 1 0\n        %.4f 0 %.4f\n';

        % Write Block C
        fprintf(fileID_C, 'C ***************************************************************\n');
        fprintf(fileID_C, 'C C.1: Source\n');
        fprintf(fileID_C, 'C ***************************************************************\n');

        % Write initial source position and extension
        fprintf(fileID_C, source.sourceCard_0);
        fprintf(fileID_C, source.sourceCard_1_i, ...
            (-stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor, ...
            (stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor);
        fprintf(fileID_C, source.sourceCard_1_p);
        fprintf(fileID_C, source.sourceCard_2_i, ...
            (-stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor, ...
            (stf(varHelper.simPropMCNP.counterField).bixelWidth/2)*varHelper.rescaleFactor);
        fprintf(fileID_C, source.sourceCard_2_p);

        % Write spectral distribution
        fprintf(fileID_C, source.particleDistribution_i);
        fprintf(fileID_C, source.particleDistribution_p);
        fprintf(fileID_C, source.particleEnergyDistributions);
        % Neutrons
        fprintf(fileID_C, source.neutronEnergyCard_5_i_0);
        fprintf(fileID_C, source.neutronEnergyCard_5_i, ...
            spectralInformation.spectrumValuesNeutrons(:,1));
        fprintf(fileID_C, source.neutronEnergyCard_5_p_0);
        fprintf(fileID_C, source.neutronEnergyCard_5_p, ...
            spectralInformation.spectrumValuesNeutrons(:,2));
        % Photons
        fprintf(fileID_C, source.photonEnergyCard_6_i_0);
        fprintf(fileID_C, source.photonEnergyCard_6_i, ...
            spectralInformation.spectrumValuesPhotons(:,1));
        fprintf(fileID_C, source.photonEnergyCard_6_p_0);
        fprintf(fileID_C, source.photonEnergyCard_6_p, ...
            spectralInformation.spectrumValuesPhotons(:,2));

        % Write TR card for spatial source transformation
        fprintf(fileID_C, coordTrafo.TRcard, ...
            stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).rayPosMLC(1)*varHelper.rescaleFactor, ...
            stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).rayPosMLC(2)*varHelper.rescaleFactor, ...
            stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).rayPosMLC(3)*varHelper.rescaleFactor, ...
            cosd(stf(varHelper.simPropMCNP.counterField).couchAngle), ...
            sind(stf(varHelper.simPropMCNP.counterField).couchAngle), ...
            -sind(stf(varHelper.simPropMCNP.counterField).couchAngle), ...
            cosd(stf(varHelper.simPropMCNP.counterField).couchAngle));

        % Close blockC_source file
        fclose(fileID_C);
    end

    function makeSource_readRSSA(stf, pln, varHelper, pathRunfiles, pathRSSA)
        if (strcmp(pln.machine, 'MCNP_MLC1') &&  ~varHelper.calcDoseDirect && stf(1).bixelWidth==15)
            copyfile([pathRSSA, 'BixelWidth15mm', filesep, 'RSSA'], [pathRunfiles,'RSSA']);
            fileID_C = fopen(strcat(pathRunfiles,'blockC_source', int2str(varHelper.totalNumberBixels)), 'w');
            % Define source card
            source.sourceCard_0 = ['SSR OLD ', varHelper.positioningRSSA.numberRSSAsurfaceString,' NEW 1001 TR=1\n'];

            % Define coordinate transformation card
            coordTrafo.TRcard = 'TR1\n        %.4f %.4f %.4f\n        %.4f %.4f 0\n        0 0 -1\n        %.4f %.4f 0\n';

            % Write Block C
            fprintf(fileID_C, 'C ***************************************************************\n');
            fprintf(fileID_C, 'C C.1: Source\n');
            fprintf(fileID_C, 'C ***************************************************************\n');

            % Write source read
            fprintf(fileID_C, source.sourceCard_0);

            % Write TR card for spatial source transformation
            fprintf(fileID_C, coordTrafo.TRcard, ...
                stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).rayPosMLC(1)*varHelper.rescaleFactor  + varHelper.positioningRSSA.LocationRSSASurf.x*cosd(stf(varHelper.simPropMCNP.counterField).couchAngle), ...
                stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).rayPosMLC(2)*varHelper.rescaleFactor, ... -varHelper.positioningRSSA.LocationRSSASurf.y, ...
                stf(varHelper.simPropMCNP.counterField).ray(varHelper.simPropMCNP.counterRay).rayPosMLC(3)*varHelper.rescaleFactor - varHelper.positioningRSSA.LocationRSSASurf.x*sind(stf(varHelper.simPropMCNP.counterField).couchAngle), ...
                -cosd(-stf(varHelper.simPropMCNP.counterField).couchAngle), ...
                -sind(-stf(varHelper.simPropMCNP.counterField).couchAngle), ...
                sind(-stf(varHelper.simPropMCNP.counterField).couchAngle), ...
                -cosd(-stf(varHelper.simPropMCNP.counterField).couchAngle));

            % Close blockC_source file
            fclose(fileID_C);

        elseif varHelper.calcDoseDirect && strcmp(pln.machine, 'MCNP_MLC1')
            copyfile([pathRSSA, 'FieldRSSA_temp', filesep, 'RSSA'], [pathRunfiles,'RSSA']);
            fileID_C = fopen(strcat(pathRunfiles,'blockC_source', int2str(varHelper.totalNumberBixels)), 'w');
            varHelper.positioningRSSA.numberRSSAsurfaceString = '9.1';
            % Define source card
            source.sourceCard_0 = ['SSR OLD ', varHelper.positioningRSSA.numberRSSAsurfaceString,' NEW 1001 TR=2\n'];

            % Define coordinate transformation card
            coordTrafo.TRcard_1 = 'TR1\n        %.4f %.4f %.4f\n        %.4f 0 %.4f\n        0 1 0\n        %.4f 0 %.4f\n';
            coordTrafo.TRcard_2 = 'TR2\n        %.4f %.4f %.4f\n        %.4f 0 %.4f\n        0 -1 0\n        %.4f 0 %.4f\n';

            % Write Block C
            fprintf(fileID_C, 'C ***************************************************************\n');
            fprintf(fileID_C, 'C C.1: Source\n');
            fprintf(fileID_C, 'C ***************************************************************\n');

            % Write source read
            fprintf(fileID_C, source.sourceCard_0);
            dummyDistConverter = 4930; % distance MLC exit to converter plates
            % Set surface for source positioning, auxiliary coordinate
            % system origin, and trafo matrices
            % Case-by-cas definition:
            if length(pln.propStf.gantryAngles)~=1 || length(pln.propStf.couchAngles)~=1
                error('Simulation of only one predefined field using RSSA file currently supported.')
            elseif (pln.propStf.gantryAngles~=90 && pln.propStf.gantryAngles~=270)
                error('For simulation of irradiation at FRM 2 only gantry angles of 90� and 270� are allowed.')
            elseif pln.propStf.couchAngles > 180
                error('For simulation of irradiation at FRM 2 only couch angles of 0� to 180� are allowed. Consider opposing gantry angle.')
            elseif pln.propStf.gantryAngles==90 && pln.propStf.couchAngles <= 90
                % Define position of surface for RSSA positioning
                pos_tr1 = [cosd(pln.propStf.couchAngles)*stf.SAD, 0, -sind(pln.propStf.couchAngles)*stf.SAD];
                pos_tr1 = pos_tr1 + stf.isoCenter;
                % Define rotation of surface for RSSA positioning
                mat_tr1 = [cosd(pln.propStf.couchAngles) cosd(90-pln.propStf.couchAngles)...
                    cosd(90+pln.propStf.couchAngles) cosd(pln.propStf.couchAngles)];
                % Define position of RSSA auxiliary coordinatsystem origin
                pos_tr2 = [cosd(pln.propStf.couchAngles)*(stf.SAD+dummyDistConverter), 0, -sind(pln.propStf.couchAngles)*(stf.SAD+dummyDistConverter)];
                pos_tr2 = pos_tr2 + stf.isoCenter;
                % Define rotation for RSSA positioning
                mat_tr2 = [cosd(180-pln.propStf.couchAngles) cosd(90-pln.propStf.couchAngles)...
                    cosd(90-pln.propStf.couchAngles) cosd(pln.propStf.couchAngles)];
            elseif pln.propStf.gantryAngles==90 && pln.propStf.couchAngles > 90
                % Define position of surface for RSSA positioning
                pos_tr1 = [-sind(pln.propStf.couchAngles-90)*stf.SAD, 0, -cosd(pln.propStf.couchAngles-90)*stf.SAD];
                pos_tr1 = pos_tr1 + stf.isoCenter;
                % Define rotation of surface for RSSA positioning
                mat_tr1 = [cosd(pln.propStf.couchAngles) cosd(pln.propStf.couchAngles-90)...
                    cosd(180-(pln.propStf.couchAngles-90)) cosd(pln.propStf.couchAngles)];
                % Define position of RSSA auxiliary coordinatsystem origin
                pos_tr2 = [-sind(pln.propStf.couchAngles-90)*(stf.SAD+dummyDistConverter), 0, -cosd(pln.propStf.couchAngles-90)*(stf.SAD+dummyDistConverter)];
                pos_tr2 = pos_tr2 + stf.isoCenter;
                % Define rotation for RSSA positioning
                mat_tr2 = [cosd(180-pln.propStf.couchAngles) cosd(pln.propStf.couchAngles-90)...
                    cosd(pln.propStf.couchAngles-90) cosd(pln.propStf.couchAngles)];
            elseif pln.propStf.gantryAngles==270 && pln.propStf.couchAngles <= 90
                % Define position of surface for RSSA positioning
                pos_tr1 = [-cosd(pln.propStf.couchAngles)*stf.SAD, 0, sind(pln.propStf.couchAngles)*stf.SAD];
                pos_tr1 = pos_tr1 + stf.isoCenter;
                % Define rotation of surface for RSSA positioning
                mat_tr1 = [cosd(pln.propStf.couchAngles) cosd(90-pln.propStf.couchAngles)...
                    cosd(90+pln.propStf.couchAngles) cosd(pln.propStf.couchAngles)];
                % Define position of RSSA auxiliary coordinatsystem origin
                pos_tr2 = [-cosd(pln.propStf.couchAngles)*(stf.SAD+dummyDistConverter), 0, sind(pln.propStf.couchAngles)*(stf.SAD+dummyDistConverter)];
                pos_tr2 = pos_tr2 + stf.isoCenter;
                % Define rotation for RSSA positioning
                mat_tr2 = [cosd(pln.propStf.couchAngles) cosd(90+pln.propStf.couchAngles)...
                    cosd(90+pln.propStf.couchAngles) cosd(180-pln.propStf.couchAngles)];
            elseif pln.propStf.gantryAngles==270 && pln.propStf.couchAngles > 90
                % Define position of surface for RSSA positioning
                pos_tr1 = [sind(pln.propStf.couchAngles-90)*stf.SAD, 0, cosd(pln.propStf.couchAngles-90)*stf.SAD];
                pos_tr1 = pos_tr1 + stf.isoCenter;
                % Define rotation of surface for RSSA positioning
                mat_tr1 = [cosd(pln.propStf.couchAngles) cosd(pln.propStf.couchAngles-90)...
                    cosd(180-(pln.propStf.couchAngles-90)) cosd(pln.propStf.couchAngles)];
                % Define position of RSSA auxiliary coordinatsystem origin
                pos_tr2 = [sind(pln.propStf.couchAngles-90)*(stf.SAD+dummyDistConverter), 0, cosd(pln.propStf.couchAngles-90)*(stf.SAD+dummyDistConverter)];
                pos_tr2 = pos_tr2 + stf.isoCenter;
                % Define rotation for RSSA positioning
                mat_tr2 = [cosd(pln.propStf.couchAngles) cosd(180-(pln.propStf.couchAngles-90))...
                    cosd(180-(pln.propStf.couchAngles-90)) cosd(180-pln.propStf.couchAngles)];
            end

            varHelper.sourcePos_tr1 = [pos_tr1(1) pos_tr1(2) pos_tr1(3)]*varHelper.rescaleFactor;
            varHelper.rotMatrix_tr1 = [mat_tr1(1) 0 mat_tr1(2); 0 1 0; mat_tr1(3) 0 mat_tr1(4)];

            varHelper.sourcePos_tr2 = [pos_tr2(1) pos_tr2(2) pos_tr2(3)]*varHelper.rescaleFactor;
            varHelper.rotMatrix_tr2 = [mat_tr2(1) 0 mat_tr2(2); 0 -1 0; mat_tr2(3) 0 mat_tr2(4)];

            pos_tr1 = pos_tr1*varHelper.rescaleFactor;
            pos_tr2 = pos_tr2*varHelper.rescaleFactor;
            % Write TR card for RSSA surface positioning
            fprintf(fileID_C, coordTrafo.TRcard_1, ...
                pos_tr1(1), pos_tr1(2), pos_tr1(3),...
                mat_tr1(1), mat_tr1(2), mat_tr1(3), mat_tr1(4));
            % Write TR card for RSAA source transformation
            fprintf(fileID_C, coordTrafo.TRcard_2, ...
                pos_tr2(1), pos_tr2(2), pos_tr2(3),...
                mat_tr2(1), mat_tr2(2), mat_tr2(3), mat_tr2(4));

            % Close blockC_source file
            fclose(fileID_C);
        else
            error('No RSSA file exist for this bixel width/radiation field. Please generate one...')
        end
    end

end