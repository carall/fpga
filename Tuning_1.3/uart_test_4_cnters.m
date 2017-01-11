tic;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=serial('com1');
set(s,'BaudRate',9600);
set(s,'DataBits',8);
set(s,'FlowControl','hardware');
set(s,'Parity','odd');
set(s,'StopBits',1); % set the parameters of serial port
set(s,'InputBufferSize', 75544);
set(s,'OutputBufferSize',75544);
set(s,'Timeout',100);


fopen(s);   % open serial port com1
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


dlyCfgLow  = [0    0    0    0];
dlyCfgHigh = [0+1    256+1    512  768];

cntCfgLow0  = [1   2        1    0];
cntCfgHigh0 = [0   2^8     2^9   2^9 + 2^8  ] + 2^14+1;

cntCfgLow1  = [0   0        1     0];
cntCfgHigh1 = [0   2^8      2^9  2^9 + 2^8 ] + 2^14 + 2;

% cfgTimerLow  = [6309488     7 ];
% cfgTimerhigh = [2^15      2^15 + 2^14];
cfgTimerLow  = [6309488     7];
cfgTimerhigh = [2^15      2^15 + 2^14];


%% cfg input delay
for n = 1 : 4
    
    try
        fwrite(s,[dlyCfgLow(n); dlyCfgHigh(n)],'uint16','async');
    catch
    end
    pause(0.5);
end
%% cfg 4 counters
for n = 1 : 4
    
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
for n = 1 : 2
    try
        fwrite(s,[cfgTimerLow(n); cfgTimerhigh(n)],'uint16','async');
    catch
    end
    pause(0.5);
end
 
%% read cfg done rtn word, 10
    
cfgDone = dec2bin(fread(s,1,'uint32'),32) 


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
    for n = 2 : 4
        cntRtn0(n) = fread(s,1,'uint32');
        cntRtn1(n) = fread(s,1,'uint32');
    end
    toc
    for n = 1 : 4
        lowBits      = dec2bin(cntRtn0(n), 32);
        highBits     = dec2bin(cntRtn1(n), 32);
        cntVal(n)    = bin2dec(lowBits(9:32)) + bin2dec(highBits(9:32))*2^24;
        cntAddr0(n)  = bin2dec(lowBits(3:8));
        cntAddr1(n)  = bin2dec(highBits(3:8));
    end
     fprintf('xxxx  cnt_num  %d \n', aaa);
     aaa = aaa + 1;
    for n = 1 : 4
       fprintf('cnt_num= %2d   count_val= %d\n', cntAddr0(n), cntVal(n))
    end
end


%% read cnt done rtn word 11

% cntDone = dec2bin(fread(s,1,'uint32'),32)
%% read 4 cnt rtn words

cntRtn0 = [];
cntRtn1 = [];
for n = 1 : 4
    cntRtn0(n) = fread(s,1,'uint32');
    cntRtn1(n) = fread(s,1,'uint32');
end
for n = 1 : 4
    lowBits      = dec2bin(cntRtn0(n), 32);
    highBits     = dec2bin(cntRtn1(n), 32);
    cntVal(n)    = bin2dec(lowBits(9:32)) + bin2dec(highBits(9:32))*2^24;
    cntAddr0(n)  = bin2dec(lowBits(3:8));
    cntAddr1(n)  = bin2dec(highBits(3:8));
end

 fprintf('final  values\n');
for n = 1 : 4
    fprintf('cnt_num= %2d   count_val= %d\n', cntAddr0(n), cntVal(n))
end
fclose(s);
toc
