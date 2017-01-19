function countVal = fpga( time, comName )
% open serial
s = openSerial( comName );
% set input delay
delayInfo = zeros( 2, 16 );
delayInfo( 1,1 ) = 1;
setDelay( s, delayInfo );
% set counter
counterInfo = zeros( 3, 64 );
counterInfo( 2,1 ) = 1;
counterInfo( 1,: ) = 1;
setCounter( s, counterInfo );
% set count time
setTime( s, time );
% receiving configure-done signal
cfgDone = dec2bin(fread(s,1,'uint32'),32);
assert((str2double(cfgDone(1)) == 1),'Configure failed!');
disp('configure done!');
%read data
[ countVal, countDone ] = seadCount( s );
assert((countDone >= 2^31+2^30),'Reading counting done failed!');
fclose(s);
end