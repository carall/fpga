function SetCounter( serialName, counterInfo )
%SETTIME set count time
%   serialName     serial variable name
%   counterInfo    counter information, 64*3 matrix; the 1st line is logic
%   operation (1->or, 0->and); the 2ed line is 16 channels selection (1 or
%   0), binary into decimal; the 3rd line is 16 channels reverse
%   (1->reverse, 0->normal),binary into decimal.

[ row, col ] = size( counterInfo );
assert( (row == 3 && col == 64 ), 'counters information matrix dimension fault!'); 
disp( 'set counters...' );
for n = 1 : 64
    counterAddress = n - 1;
    temp = 2^14 + counterAddress * 2^8 + counterInfo( 1,n );
    fwrite( serialName, [ counterInfo( 2,n ); temp ], 'uint16', 'async' );
    pause(0.5);
    temp = temp - counterInfo( 1,n ) + 2;
    fwrite( serialName, [ counterInfo( 3,n ); temp ], 'uint16', 'async' );
    pause(0.5);
end
end