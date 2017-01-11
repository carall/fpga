clc;
clear all;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=serial('com6');
set(s,'BaudRate',9600);
set(s,'DataBits',8);
set(s,'FlowControl','hardware');
set(s,'Parity','odd');
set(s,'StopBits',1); % set the parameters of serial port
% set(s,'InputBufferSize', 75544);
% set(s,'OutputBufferSize',75544);
set(s,'Timeout',100);


fopen(s);   % open serial port com1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


dlyCfgLow  = zeros(1,15); %%orignal data dlyCfgLow  = [0    0    0    0];
dlyCfgHigh = [0+1    256+1    512  768 1024 1280 1536 1792 2048 2304 2560 2816 3072 3328 3584]; %%choose which channel active  +1, dlyCfgHigh = [0    256    512  768] + 1

cntCfgLow0  = zeros(1,16);
cntCfgLow0(1)=1;%% open cnt 0 to count channel 1
cntCfgLow0(2)=1;%% open cnt 1 to count channel 1
cntCfgLow0(3)=2;%% open cnt 2 to count channel 2
cntCfgLow0(4)=2;%% open cnt 3 to count channel  2
cntCfgLow0(5)=3;%% open cnt 4 to count channel 1&2
cntCfgLow0(6)=3;%% open cnt 5 to count channel 1 reverse & 2 
cntCfgLow0(7)=3;%% open cnt 6 to count channel 1 & 2 reverse
cntCfgLow0(8)=3;%% open cnt 2 to count channel 1 reverse & 2  reverse
%cntCfgLow0  = repmat([1 2 4 8] ,1, 4);  %%choose input


cntCfgHigh0 = (0:15) * 2^8 + 2^14+1; %% address mapping, and "&" calculation, 
                                   %%if cntCfgHigh0 = (0:15) * 2^8 + 2^14+1 means it will as "or" calculation
cntCfgHigh0(5)= 17408; %%cnt5 'and'
cntCfgHigh0(6)= 17664; %%cnt6 'and'
cntCfgHigh0(7)= 17920; %%cnt7 'and'
cntCfgHigh0(8)= 18177; %%cnt8 'or'

cntCfgLow1  =  zeros(1,16); %%control revers 
cntCfgLow1(2)=1; %%revers control, let cnt 0 count channel 1 reverse
cntCfgLow1(4)=2; %%revers control, let cnt 3 count channel 2 reverse
cntCfgLow1(6)=1; %%revers control, let chnanel 1 reverse
cntCfgLow1(7)=2; %%revers control, let chnanel 1 and 2 reverse
cntCfgLow1(8)=3; %%revers control, let chnanel 1 reverse and 2 reverse
cntCfgHigh1 = (0:15) * 2^8  + 2^14 + 2;%% only control address

cfgTimerLow  = [6309488     7 ];
cfgTimerhigh = [2^15      2^15 + 2^14];
% cfgTimerLow  = [10624576     914]; %%310 counting time
% cfgTimerhigh = [2^15      2^15 + 2^14];


%% cfg input delay
for n = 1 : 15 %% orignal data: n=1:4
    fprintf('cfg_input_%d\n', n)
    try
        fwrite(s,[dlyCfgLow(n); dlyCfgHigh(n)],'uint16','async');
        dlyCfgLow(n);
        dlyCfgHigh(n);
    catch
    end
    pause(0.5);
    
end
%% cfg 16 counters
for n = 1 : 16
    fprintf('cfg_cnt_%d\n', n)
    try
        fwrite(s,[cntCfgLow0(n); cntCfgHigh0(n)],'uint16','async');
    catch
    end
    pause(0.5);
    try
        fwrite(s,[cntCfgLow1(n); cntCfgHigh1(n)],'uint16','async');
    catch
    end
    pause(0.5);
    
end
%% cfg timer
fprintf('cfg_timer\n')
for n = 1 : 2
    try
        fwrite(s,[cfgTimerLow(n); cfgTimerhigh(n)],'uint16','async');
    catch
    end
    pause(0.5);
end

%% read cfg done rtn word, 10

cfgDone = dec2bin(fread(s,1,'uint32'),32);


%%

aaa = 1;
    tic
while 1 ==1
    
    cntRtn0 = [];
    cntRtn1 = [];
    

    rxData = fread(s,1,'uint32');
    
    if rxData == 2^31 + 2^30
        cntDone = dec2bin(rxData)
        break
    else
        cntRtn0(1) = rxData;
        cntRtn1(1) = fread(s,1,'uint32');
    end
    for n = 2 : 16
        cntRtn0(n) = fread(s,1,'uint32');
        cntRtn1(n) = fread(s,1,'uint32');
    end
    toc
    for n = 1 : 16
        lowBits      = dec2bin(cntRtn0(n), 32);
        highBits     = dec2bin(cntRtn1(n), 32);
        cntVal(n)    = bin2dec(lowBits(9:32)) + bin2dec(highBits(9:32))*2^24;
        cntAddr0(n)  = bin2dec(lowBits(3:8));
        cntAddr1(n)  = bin2dec(highBits(3:8));
    end
     fprintf('xxxx  cnt_num  %d \n', aaa);
     aaa = aaa + 1;
    for n = 1 : 16
       fprintf('cnt_num= %2d   count_val= %d\n', cntAddr0(n), cntVal(n))
    end
end


%% read cnt done rtn word 11

% cntDone = dec2bin(fread(s,1,'uint32'),32)
%% read 4 cnt rtn words

cntRtn0 = [];
cntRtn1 = [];
for n = 1 : 16
    cntRtn0(n) = fread(s,1,'uint32');
    cntRtn1(n) = fread(s,1,'uint32');
end
for n = 1 : 16
    lowBits      = dec2bin(cntRtn0(n), 32);
    highBits     = dec2bin(cntRtn1(n), 32);
    cntVal(n)    = bin2dec(lowBits(9:32)) + bin2dec(highBits(9:32))*2^24;
    cntAddr0(n)  = bin2dec(lowBits(3:8));
    cntAddr1(n)  = bin2dec(highBits(3:8));
end

 fprintf('final  values\n');
for n = 1 : 16
    fprintf('cnt_num= %2d   count_val= %d\n', cntAddr0(n), cntVal(n))
end
fclose(s);
toc


