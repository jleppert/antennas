function build_antenna_gerber(antenna_pcb,filename,varargin)


%Defaults
service = PCBServices.PCBWayWriter;
dir = './output'


if isstring(filename)
    filename_ = filename.split('.');
    service.Filename=char(filename_(1));
else
    service.Filename='antenna';
end

write = PCBWriter(antenna_pcb,service,[]);
write.Soldermask='none';
write.Solderpaste=0;

write.gerberWrite();








