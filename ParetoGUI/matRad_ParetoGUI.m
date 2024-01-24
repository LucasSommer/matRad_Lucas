classdef matRad_ParetoGUI < handle
% matRad_MainGUI   Graphical User Interface configuration class   
% This Class is used to create the main GUI interface where all the widgets
% are called and created.
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2019 the matRad development team.
%
% This file is part of the matRad project. It is subject to the license
% terms in the LICENSE file found in the top-level directory of this
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part
% of the matRad project, including this file, may be copied, modified,
% propagated, or distributed except according to the terms contained in the
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        guiHandle
        lastStoragePath = []        
    end

    properties (Access = private)
        LogoWidget
        ParetoSliceWidget
        SliderWidget
        DVHWidget
        ButtonWidget
    end

    methods
        function this = matRad_ParetoGUI(varargin)
        %Panel for Main Widget 
        
        matRad_cfg = MatRad_Config.instance();
        
        this.guiHandle = figure(...
            'Units','normalized',...
            'Position',[0.005 0.04 0.99 0.9],... %approximate fullscreen position
            'Visible','on',...
            'Color',matRad_cfg.gui.backgroundColor,...  
            'IntegerHandle','off',...
            'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
            'MenuBar','none',...
            'Name','matRad Pareto Navigator (NOT FOR CLINICAL USE!)',...
            'HandleVisibility','callback',...
            'Tag','figure1',...
            'CloseRequestFcn',@(src,hEvent) figure1_CloseRequestFcn(this,src,hEvent));
        
        %WindowState not available in all versions
        if isprop(this.guiHandle,'WindowState')
            set(this.guiHandle,'WindowState','maximized');
        end
        
        pParetoSlice = uipanel(...
            'Parent',this.guiHandle,...     
            'Units','normalized',...
            'Title','Current plan Slice',...
            'BackgroundColor',matRad_cfg.gui.backgroundColor,...
            'Tag','PlanSlicePanel',...
            'Clipping','off',...
            'Position',[0.01 0.5 0.45 0.49],...
            'FontName',matRad_cfg.gui.fontName,...
            'FontSize',matRad_cfg.gui.fontSize,...
            'FontWeight',matRad_cfg.gui.fontWeight);
        
        
        pSliderWidget = uipanel( ...
            'Parent',this.guiHandle,...
            'Units','normalized',...
            'BackgroundColor',matRad_cfg.gui.backgroundColor,...
            'Tag','SliderPanel',...
            'Clipping','off',...
            'Position',[0.005 0.005 0.5 0.49],...
            'FontName',matRad_cfg.gui.fontName,...
            'FontSize',matRad_cfg.gui.fontSize,...
            'FontWeight',matRad_cfg.gui.fontWeight);
        pSliderWidget.Scrollable = "on";

          
        pButtonWidget = uipanel(...
            'Parent',this.guiHandle,...  
            'Units','normalized',...
            'BackgroundColor',matRad_cfg.gui.backgroundColor,...
            'Tag','Additional Button Panel',...
            'Clipping','off',...
            'Position',[0.51 0.395 0.15 0.1],...
            'FontName',matRad_cfg.gui.fontName,...
            'FontSize',matRad_cfg.gui.fontSize,...
            'FontWeight',matRad_cfg.gui.fontWeight);

        pParetoDVHWidget = uipanel(...
                'Parent',this.guiHandle,...  
                'Units','normalized',...
                'Title','DVH ',...
                'BackgroundColor',matRad_cfg.gui.backgroundColor,...
                'Tag','DVHPanel',...
                'Clipping','off',...
                'Position',[0.51 0.5 0.45 0.49],...
                'FontName',matRad_cfg.gui.fontName,...
                'FontSize',matRad_cfg.gui.fontSize,...
                'FontWeight',matRad_cfg.gui.fontWeight);
        

        
        this.ParetoSliceWidget = matRad_ParetoSliceWidget(pParetoSlice);
        this.SliderWidget = matRad_SliderWidget(pSliderWidget,this.ParetoSliceWidget);
        this.DVHWidget = matRad_ParetoDVHWidget(pParetoDVHWidget);
        this.ButtonWidget = matRad_ButtonWidget(pButtonWidget,this.SliderWidget,this.DVHWidget);

        end
        
        function figure1_CloseRequestFcn(this,hObject, ~)
            matRad_cfg = MatRad_Config.instance();
            set(0,'DefaultUicontrolBackgroundColor',matRad_cfg.gui.backgroundColor);
            selection = questdlg('Do you really want to close the matRad ParetoInterface?',...
                'Close matRad',...
                'Yes','No','Yes');

            switch selection
                case 'Yes'
                    delete(hObject);
                    delete(this);
                case 'No'
                    return
            end
        end
    end
end