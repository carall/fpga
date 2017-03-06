function [ countTotal,countDone ] = readCount2( serialName, counterNum, fineDelay )
% READCOUNT read count value from FPGA
%   serialName     serial variable name
disp('read data...');
fid = fopen('F:/LabVIEW Data/cnt.txt','a+');
fprintf(fid, '%d\n', fineDelay);
temp = fread(serialName,1,'uint32');
timer = tic;
count = zeros(1,16);
countPrev = zeros(1,16);
countTotal = zeros(1,16);
address = 0;
while temp<2^31+2^30 %read one counter data in one loop
    countValLow = dec2bin(temp,32);
    countValHigh = dec2bin(fread(serialName,1,'uint32'),32);
    countAddressLow = bin2dec(countValLow(3:8));
    countAddressHigh = bin2dec(countValHigh(3:8));
    assert((countAddressLow == countAddressHigh),'counter data address error!');
    address = countAddressLow + 1;
    % just do fread if the required counters are read finished;
    if address > counterNum
        temp = fread(serialName,1,'uint32');
        if address == 16
            timer = tic;
            countPrev = countTotal;
        end
        continue;
    end
    % handle count and countTotal
    val = bin2dec(countValLow(9:32)) + bin2dec(countValHigh(9:32))*2^24;
    countTotal(address) = val;
    count(address) = val - countPrev(address);
    
    if address == counterNum
        fprintf(fid, '%d', timer);
        for iCounterNum = 1 : counterNum
            fprintf(fid, '\t%d', count(iCounterNum));
        end
        fprintf(fid, '\n');
        disp(count(1:counterNum));
        count(:) = 0;
    end
    
    temp = fread(serialName,1,'uint32');
    timer = tic;
end
countDone = temp;
fclose(fid);
end