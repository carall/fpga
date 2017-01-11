function countVal = fpga( time, comName )
% open serial
s = OpenSerial( comName );
% set input delay
delayInfo = zeros( 2, 16 );
delayInfo( 1,1 ) = 1;
SetDelay( s, delayInfo );
% set counter
counterInfo = zeros( 3, 64 );
counterInfo( 2,1 ) = 1;
counterInfo( 1,: ) = 1;
SetCounter( s, counterInfo );
% set count time
SetTime( s, time );
% receiving configure-done signal
cfgDone = dec2bin(fread(s,1,'uint32'),32);
assert((str2double(cfgDone(1)) == 1),'Configure failed!');
disp('configure done!');
%read data
[ countVal, countDone ] = ReadCount( s );
assert((countDone >= 2^31+2^30),'Reading counting done failed!');
fclose(s);
end