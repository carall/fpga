function [ countVal,countDone ] = ReadCount( serialName )
% READCOUNT read count value from FPGA
%   serialName     serial variable name
disp('read data...');
fid = fopen('F:\LabVIEW Data\cnt.txt','a+');
temp = fread(serialName,1,'uint32');
timer = tic;
countVal = zeros(1,64);
while temp<2^31+2^30 %read one counter data in one loop
    countValLow = dec2bin(temp,32);
    countValHigh = dec2bin(fread(serialName,1,'uint32'),32);
    countAddressLow = bin2dec(countValLow(3:8));
    countAddressHigh = bin2dec(countValHigh(3:8));
    assert((countAddressLow == countAddressHigh),'counter data address error!');
    address = countAddressLow;
    val = bin2dec(countValLow(9:32)) + bin2dec(countValHigh(9:32))*2^24;
    countVal(address+1) = val;
    if address == 0
        fprintf(fid, '%d\r\n%d\r\n', timer,val);
    end
    temp = fread(serialName,1,'uint32');
    timer = tic;
end
countDone = temp;
fclose(fid);
end