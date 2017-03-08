function countTotal = fpga( time, comName )
% open serial
s = openSerial( comName );

% set input channel delay
delayInfo = zeros( 2, 16 );
% delayInfo(1,i) is the 1st 16 bits which is delay num,  and i is the input channel num;
delayInfo( 1,2 ) = 7 * 2^8 + 110;
% delayInfo(2,i) is the 2nd 16 bits which is selection information, default 0 not select, and i is the input channel num;
delayInfo( 2,1 ) = 1;
delayInfo( 2,2 ) = 1;
setDelay( s, delayInfo );

% set counter
counterInfo = zeros( 3, 64 );
% counterInfo(1,i) the 1st 16 bits which is the input selections, and i is the counter num;
counterInfo( 1,1 ) = 2^0;
counterInfo( 1,2 ) = 2^1;
counterInfo( 1,3 ) = 2^0 + 2^1;
% counterInfo(2,i) the 2nd 16 bits which is  the choice of and between or. default 0 is and;
% counterInfo(3,i) the 3rd 16 bits which is the input reverse informations. default 0 is normal;
% the 4th 16 bits is the 2nd 16 bits plus 2^1
setCounter( s, counterInfo );

% set count time
setTime( s, time );

% receiving configure-done signal
cfgDone = dec2bin(fread(s,1,'uint32'),32);
assert((str2double(cfgDone(1)) == 1),'Configure failed!');
disp('configure done!');

%read data
[ countTotal, countDone ] = readCount( s, 3 );
assert((countDone >= 2^31+2^30),'Reading counting done failed!');
fclose(s);
end