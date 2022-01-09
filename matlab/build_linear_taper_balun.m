function [pcb,connector] = build_linear_taper_balun(varargin)
% Builds a linear taper feed planar balun for matching to the antenna. 
% Created by:  Alan Wilson-Langman
% Revision: 1.0
% Copyright (c) 2022 Inspectobot.


%Set defaults
pcb_name = 'antenna';
pcb_version = '1.0';
mm=1e-3;
L = 50*mm;
W1 = 2.9*mm;
W2 = 1.2*mm;
W3 = 3*W1;
h = 1.54*mm;

substrate_width = 4*W1;
substrate_length = L;
substrate_thickness = h;

terminate = true;
termination_impedance = 100;
add_connector = true;
connector=[];


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
            case "W1"
                if isnumeric(property_values(k)) 
                    W1 = property_values(k);
                end
            case "W2"
                if isnumeric(property_values(k)) 
                    W2 = property_values(k);
                end
    
            case "W3"
                if isnumeric(property_values(k)) 
                    W3 = property_values(k); 
                end
            case "L"
                if isnumeric(property_values(k)) 
                    L = property_values(k); 
                end
            case "termination_impedance"
                if isnumeric(property_values(k)) 
                    termination_impedance = property_values(k); 
                end
            case "terminate"
                if ~isnumeric(property_values(k)) 
                    terminate = property_values(k);
                end
            case "add_connector"
                if ~isnumeric(property_values(k)) 
                    add_connector = property_values(k);
                end
            
        end
    end
end


%Build antenna conductors
top_layer = antenna.Polygon("Vertices",[-L/2 W1/2;L/2 W2/2;L/2 -W2/2;-L/2 -W1/2]);
gnd = antenna.Polygon("Vertices",[-L/2 W3/2;L/2 W2/2;L/2 -W2/2;-L/2 -W3/2]);


%Create PCB board (for now using FR4)
boardShape= antenna.Rectangle('Length',substrate_length,'Width',substrate_width);
substrate = dielectric("FR4");
substrate.Thickness= substrate_thickness;
conductor = metal("Name","PEC","Conductivity",Inf,"Thickness",0);

pcb = pcbComponent;
pcb.Name = pcb_name;
pcb.Revision = pcb_version;
pcb.BoardThickness = substrate_thickness;
pcb.Conductor=conductor;
pcb.BoardShape = boardShape;
pcb.Layers = {top_layer,substrate,gnd};
pcb.FeedLocations = [-L/2 0 1 3;L/2 0 1 3];
pcb.FeedDiameter = W2;


if terminate
    % Terminated the antenna end with a 90 ohm load
    ZLP = lumpedElement('Impedance', termination_impedance/2, 'Location', [L/2 0 pcb.BoardThickness]);
    ZLN = lumpedElement('Impedance', termination_impedance/2, 'Location', [L/2 0 0]);
    pcb.Load = [ZLP ZLN];
end

if add_connector
    connector = PCBConnectors.SMAEdge_Linx;
    connector.ExtendBoardProfile=0;
    connector.EdgeLocation = 'west';
end

end