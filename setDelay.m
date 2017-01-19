function SetDelay( serialName, delayInfo )
% SETDELAY set triger delays
%   serialName     serial variable name
%   delayInfo      delay information, 2*16 matirx, the 1st line is channel
%   selection (1 or 0) and the 2ed line is the delay number

[ row, col ] = size( delayInfo );
assert( (row == 2 && col == 16 ), 'delay information matrix dimension fault!'); % confirm the input parameter
disp( 'set delay...' );
for n = 1 : 16 % one channel each loop
    channelAddress = ( n - 1 );
    delayInfo( 1,n ) = 1 * ( delayInfo( 1,n ) > 0 );
    first16Bits = delayInfo( 2,n );
    seconf16Bits = channelAddress * 2 ^ 8 + delayInfo( 1,n );
    fwrite( serialName, [ first16Bits; seconf16Bits ], 'uint16', 'async' );
    pause(0.5);
end
end