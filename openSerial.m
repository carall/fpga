function serialName = openSerial( comName )
% OPENSERIAL open and config the serial
%   serialName   like com5...
disp( 'open and configure serial...' );
serialName = serial( comName );
serialName.Baudrate = 9600;
serialName.DataBits = 8;
% serialName.FlowControl = 'hardware';
serialName.Parity = 'odd';
serialName.StopBits = 1;
serialName.Timeout = 10;
fopen( serialName );
end

