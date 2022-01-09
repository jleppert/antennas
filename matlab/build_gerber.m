function writer = build_gerber(pcb,filename,varargin)
%%  Builds the antenna gerber files from an antenna build model.
%    :param pcb:  rf PCB component (can be antenna) object (pcbStack)
%    :filename: of the output zip file. No need to add .zip.
%    :service (optional): the PCB service to use (matlab PCBServices obj)
%    :connector (optional;): the connector to use. Also matlab obj.

% Created by:  Alan Wilson-Langman
% Revision: 1.0
% Copyright (c) 2022 Inspectobot.


%Defaults
service = PCBServices.MayhewWriter;
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
writer = PCBWriter(pcb,service,connector);
writer.Soldermask='none';
writer.Solderpaste=0;
writer.UseDefaultConnector=false;

writer.gerberWrite();








