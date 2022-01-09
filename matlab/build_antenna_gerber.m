function build_antenna_gerber(antenna_pcb,filename,varargin)
%%  Builds the antenna gerber files from an antenna build model.
%    :param antenna_pcb:  antenna model object (pcbStack)
%    :filename: of the output zip file. No need to add .zip.
%    :service (optional): the PCB service to use (matlab PCBServices obj)
%    :connector (optiona;): the connector to use. Also matlab obj.

% Created by:  Alan Wilson-Langman
% Revision: 1.0
% Copyright (c) 2022 Inspectobot.


%Defaults
service = PCBServices.PCBWayWriter;
connector = [];


if ~isempty(varargin) > 0
    property_names = varargin{1:2:end};
    property_values = varargin{2:2:end};
    numargs = length(property_values);
    for k = 1:numargs
        switch property_names(k)
            case "service"
                %Should check to make sure that it is the right object.
               service = property_values(k)
            case "connector"
               connector = property_values(k)
        end
    end
end


if isstring(filename)
    filename_ = filename.split('.');
    service.Filename=char(filename_(1));
else
    service.Filename='antenna';
end

%Note that for this
write = PCBWriter(antenna_pcb,service,connector);
write.Soldermask='none';
write.Solderpaste=0;

write.gerberWrite();








