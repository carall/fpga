function countDone = ReadCount( serialName, writePeriod, path,Table_Output )
% READCOUNT read count value from FPGA
%   serialName     serial variable name
%   writePeriod    写入文件间隔时间
disp('开始读取数据');
fid = fopen(path ,'a');
fprintf(fid,'开始读取数据时间：%s\r\n', datestr(now));
temp = fread(serialName,1,'uint32');
tic;
countVal = zeros(1,16);
loopCount = 0;
while temp<2^31+2^30 %read one counter data in one loop
    countValLow = dec2bin(temp,32);
    countValHigh = dec2bin(fread(serialName,1,'uint32'),32);
    countAddressLow = bin2dec(countValLow(3:8));
    countAddressHigh = bin2dec(countValHigh(3:8));
    assert((countAddressLow == countAddressHigh),'计数器返回地址不一致！');
    address = countAddressLow;
    assert((address < 16),'计数器返回地址超过15！');
    val = bin2dec(countValLow(9:32)) + bin2dec(countValHigh(9:32))*2^24;
    countVal(address+1) = val;
   
    if address == 15
        if toc > writePeriod - 1 && toc < writePeriod + 1
            tic;
            time = datestr(now);
            fprintf(fid, '%s\t', time(13:20));
            for i = 1 : 16
                fprintf(fid, '%d\t', countVal(i));
            end
            fprintf(fid, '\r\n');
        end
        dataScreen = zeros(1,64);
        for i=1:16
            dataScreen(i) = countVal(i);
        end
        dataScreen = reshape(dataScreen, 8, 8);
        set(Table_Output,'Data',dataScreen);
        pause(0.1);
        countVal(:) = 0; %每返回完16个计算器就清零
    end
    temp = fread(serialName,1,'uint32');
end
countDone = temp;
fclose(fid);
disp('读数结束！');
end