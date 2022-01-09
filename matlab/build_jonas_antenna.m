function pcb = build_jonas_antenna(varargin)
%% Create a antenna model for simulation and manufacture for Jonas innitial antennas
%   :param pcb_name:  the name of the design
%   :param pcb_version: the version number for the antenna
%   :param substrate_length: the length of the PCB
%   :param substrate_width: the width of the PCB
%   :param substrate_thickness: the thickness of the PCB substrate
%   :param antenna_width: the width of the antenna conductor
%   :param antenna_feed_gap: the gap between the antenna feed pads
%   :param antenna_arm_spacingL: the spacing between the antenna arms
%   :param pad_length: the length of the antenna pad
%   :param pad_width: the width of the antenna pad
%   :param slot_width: the width of the tuning slot
%   :param slot_length: the length of the tuning slot
%   :param build: if true, then build model for creating gerber files.
%               : if false, then build a model for simulation.

% Note the for simulation then two arms need to be electricall conneced to
% feed the simulation feed model.

% Created by:  Alan Wilson-Langman
% Revision: 1.0
% Copyright (c) 2022 Inspectobot.





%Set defaults
pcb_name = 'antenna';
pcb_version = '1.0';
mm=1e-3;
side= 54.96*mm;
gap=1.2*mm;
spacing=2.40*mm;
pad_length = 2.40*mm;  %Add 3.6mm too.
pad_width = 1.2*mm;
slot_length = 45.00*mm;
slot_width = 5.00*mm;

substrate_length=190*mm;
substrate_width = 96*mm;
substrate_thickness = 1.52*mm/2;

build = true;

if ~isempty(varargin) > 0
    property_names = varargin{1:2:end};
    property_values = varargin{2:2:end};
    numargs = length(property_values);
    for k = 1:numargs
        switch string(property_names(k))
            case "pcb_name"
               if ischar(property_values(k)) 
                   substrate_length = property_values(k); 
               end
            case "pcb_version"
               if ischar(property_values(k)) 
                   substrate_length = property_values(k); 
               end
            case "substrate_length"
                if isnumeric(property_values(k)) 
                    substrate_length = property_values(k); 
                end
            case "substrate_width"
                if isnumeric(property_values(k)) 
                    substrate_width = property_values(k); 
                end
            case "substrate_thickness"
                if isnumeric(property_values(k)) 
                    substrate_thickness = property_values(k); 
                end
            case "antenna_width"
                if isnumeric(property_values(k)) 
                    side = property_values(k);
                end
            case "antenna_feed_gap"
                if isnumeric(property_values(k)) 
                    gap = property_values(k);
                end
    
            case "antenna_arm_spacing"
                if isnumeric(property_values(k)) 
                    spacing = property_values(k); 
                end
    
            case "pad_length"
                if isnumeric(property_values(k)) 
                    pad_length = property_values(k);
                end
    
            case "pad_width"
                if isnumeric(property_values(k)) 
                    pad_width = property_values(k);
                end
    
            case "slot_length"
                if isnumeric(property_values(k)) 
                   slot_length = property_values(k);
                end
    
    
            case "slot_width"
                if isnumeric(property_values(k)) 
                    slot_width = property_values(k);
                end
    
    
            case "build"
                if ~isnumeric(property_values(k)) 
                    build = property_values(k);
                end
        end
    end
end

sq_left = antenna.Rectangle('Length',side,'Width',side,'Center',[-side-spacing/2 0]);
circ_left = antenna.Circle('Radius',side/2,'Center',[-side/2-spacing/2, 0]);
pad_left = antenna.Rectangle('Length',pad_length,'Width',pad_width,'Center',[-pad_length/2-gap/2 0]);
slot_left = antenna.Rectangle('Length',slot_length,'Width',slot_width,'Center',[-side/2-spacing/2, slot_width/2]);
left_arm = sq_left + circ_left-slot_left+pad_left;

sq_right = antenna.Rectangle('Length',side,'Width',side,'Center',[side+spacing/2 0]);
circ_right = antenna.Circle('Radius',side/2,'Center',[side/2+spacing/2, 0],'NumPoints',50);
pad_right = antenna.Rectangle('Length',pad_length,'Width',pad_width,'Center',[pad_length/2+gap/2 0]);
slot_right = antenna.Rectangle('Length',slot_length,'Width',slot_width,'Center',[side/2+spacing/2, slot_width/2]);
right_arm = sq_right+circ_right-slot_right+pad_right;


antenna_top_layer = left_arm+right_arm;

%For simulation the antenna arms need to be bridged
if ~build
    bridge = antenna.Rectangle('Length',pad_length,'Width',pad_width,'Center',[0 0]);
    antenna_top_layer = antenna_top_layer + bridge;
end

% Define bottom ground plane
boardShape= antenna.Rectangle('Length',substrate_length,'Width',substrate_width);
substrate = dielectric("Name",'FR4',"EpsilonR",4.8,"LossTangent",0.026,"Thickness",substrate_thickness);
conductor = metal("Name","PEC","Conductivity",Inf,"Thickness",0);

pcb = pcbStack;
pcb.Name = pcb_name;
pcb.Revision = pcb_version;
pcb.BoardThickness = substrate_thickness;
pcb.Conductor=conductor;
pcb.BoardShape = boardShape;
pcb.Layers = {antenna_top_layer,substrate};
pcb.FeedLocations = [0 0 1];
pcb.FeedDiameter = pad_width/2;



