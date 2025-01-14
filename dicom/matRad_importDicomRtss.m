function structures = matRad_importDicomRtss(filename,dicomInfo,visBool)
% matRad function to read the data of the selected dicomRT structure set file 
% into a matlab struct
% 
% call
%   structures = matRad_importDicomRtss(filename,dicomInfo)
%   structures = matRad_importDicomRtss(filename,dicomInfo,visBool)
%
% input
%   filename:       name of the rtss file
%   dicomInfo:      meta information from the dicom ct files for sanity
%                   checks
%   visBool:        (optional) turn on/off visualization
%
% output
%   structures:     struct containing names, numbers, colors, and
%                   coordinates of the polygon segmentations
%
% References
%   -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2015 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\nReading structures...');

if nargin < 3
    visBool = 0;
end
matRad_cfg = MatRad_Config.instance();
matRad_checkEnvDicomRequirements(matRad_cfg.env);



% read dicom info (this includes already all data for the rtss)
if matRad_cfg.isOctave || verLessThan('matlab','9')
    structInfo = dicominfo(filename);
else % apply 'UseVRHeuristic' option when available to use a to help read certain 
     % noncompliant files which switch value representation (VR) modes incorrectly
    structInfo = dicominfo(filename,'UseVRHeuristic',false,'UseDictionaryVR',true);
end

% list the defined structures
try
    listOfDefStructs = fieldnames(structInfo.StructureSetROISequence);
catch
    matRad_cfg.dispError('StructureSetROISequence not defined ')
end
% list of contoured structures
try
    listOfContStructs = fieldnames(structInfo.ROIContourSequence);
catch
    matRad_cfg.dispError('ROIContourSequence not defined ')
end 

%% process structure data
numOfDefStructs  = numel(listOfDefStructs);
numOfContStructs = numel(listOfContStructs);

for i = 1:numOfContStructs % loop over every structure   

    % find the correct name
    for j = 1:numOfDefStructs
        if structInfo.ROIContourSequence.(listOfContStructs{i}).ReferencedROINumber ...
                == structInfo.StructureSetROISequence.(listOfDefStructs{j}).ROINumber
            break;
        end
    end    
    structures(i).structName   = regexprep(...  % replace nonregular characters by whitespace
        structInfo.StructureSetROISequence.(listOfDefStructs{j}).ROIName,...
        '[^a-zA-Z0-9]',' ');
                             
    structures(i).structNumber = structInfo.ROIContourSequence.(...
                                 listOfContStructs{i}).ReferencedROINumber;
    if isfield(structInfo.ROIContourSequence.(listOfContStructs{i}),'ROIDisplayColor')
        structures(i).structColor  = structInfo.ROIContourSequence.(...
                                     listOfContStructs{i}).ROIDisplayColor;  
    end

    if isfield(structInfo.ROIContourSequence.(...
                    listOfContStructs{i}), 'ContourSequence');
                if ~isempty(structInfo.ROIContourSequence.(...
                                listOfContStructs{i}).ContourSequence);
                    listOfSlices = fieldnames(structInfo.ROIContourSequence.(...
                                                listOfContStructs{i}).ContourSequence);
                else
                    matRad_cfg.dispWarning(['Contour ' structures(i).structName ' is empty'])
                    continue;
                end
    else
        matRad_cfg.dispWarning(['Contour ' structures(i).structName ' is empty'])
        continue;
    end
    
    for j = 1:numel(listOfSlices)
        structSlice = structInfo.ROIContourSequence.(...
                listOfContStructs{i}).ContourSequence.(listOfSlices{j});
        
        if strcmpi(structSlice.ContourGeometricType, 'POINT')
            continue;
        end
        
        % store the z-coordinate of this structure slice
        structX = structSlice.ContourData([1:3:end 1]);
        structY = structSlice.ContourData([2:3:end 2]);
        structZ = structSlice.ContourData([3:3:end 3]);
        
        % rounding to solve numerical problems with contour points not
        % being defined exactly in the same slice
        structZ = 1e-10*round(1e10*structZ);
        
        % sanity check 1
        if numel(unique(structZ)) > 1
            matRad_cfg.dispError('Detected contour points outside of single slice\n');
        end
        
        % sanity check 2
        if unique(structZ) > max(dicomInfo.SlicePositions) || unique(structZ) < min(dicomInfo.SlicePositions)
            matRad_cfg.dispWarning(['Omitting contour data for ' structures(i).structName ' at slice position ' num2str(unique(structZ)) 'mm - no ct data available.\n']);
        else
            structures(i).item(j).points = [structX, structY, structZ];
        end
            
    end
    
end

%% visualization
% show all structure points in a single plot
if visBool
    figure;
    hold on
    for i = 1:numel(structures)
        plot3(structures(i).points(:,1),structures(i).points(:,2),...
            structures(i).points(:,3),'-',...
            'Color',structures(i).structColor ./ 255,'Displayname',structures(i).structName);
    end
    legend('show')
end

fprintf('finished!\n');


end
