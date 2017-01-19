function SetTime( serialName, time )
%SETTIME set count time
%   serialName     serial variable name
%   time           count time (seconds)
disp( 'set count time...' );
timerBin = dec2bin( time * 99 * 500000, 47);
timerLowFirst16Bits = bin2dec( timerBin( 32:47 ) );
timerLowSecond16Bits = bin2dec( [ '10000000', timerBin( 24:31 ) ] );
timerHighFirst16Bits = bin2dec( timerBin( 8:23 ) );
timerHighSecond16Bits = bin2dec( [ '110000000', timerBin( 1:7 ) ] );
fwrite( serialName, [ timerLowFirst16Bits; timerLowSecond16Bits ], 'uint16', 'async' );
pause(0.5);
fwrite( serialName, [ timerHighFirst16Bits; timerHighSecond16Bits ], 'uint16', 'async' );
pause(0.5);
end

