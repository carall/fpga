function Button_Start2(Table_Delay,Table_Counter,Table_Timer,Table_Output)
clc;

n_counter=get(Table_Counter,'Data');
n_counter=n_counter(:,1:16);
n_counter=cell2mat(n_counter);cmd_select=sum(n_counter);
n_counter=n_counter>0;
n_counter=sum(n_counter,2);
n_counter_valid=n_counter~=0;Data_Selection=n_counter_valid;
n_counter_valid=find(n_counter_valid>0);
n_counter=sum(n_counter);

cmd_delay=UART_Write_Delay(Table_Delay,cmd_select);
cmd_counter=UART_Write_Counter(Table_Counter);
cmd_timer=UART_Write_Timer(Table_Timer);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cfg COM
disp('����COM�ӿ�')
s=serial('com6');
set(s,'BaudRate',9600);
set(s,'DataBits',8);
set(s,'FlowControl','hardware');
set(s,'Parity','odd');
set(s,'StopBits',1); % set the parameters of serial port
% set(s,'InputBufferSize', 75544);
% set(s,'OutputBufferSize',75544);
set(s,'Timeout',100);
fopen(s); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cfg input delay
disp('���ô����ӳ�')
for n = 1 : 15   %%%original setting: n=1:4
    try
        cmd_delay(1,n);
        cmd_delay(2,n);
        fwrite(s,[cmd_delay(1,n); cmd_delay(2,n)],'uint16','async')
    end
    pause(0.5);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cfg counters
disp('���ü�����')
for n = 1 : 16
    try
        cmd_counter(1,n);
        cmd_counter(2,n);
        fwrite(s,[cmd_counter(1,n); cmd_counter(2,n)],'uint16','async');
    end
    pause(0.5);
    try
        cmd_counter(3,n);
        cmd_counter(4,n);
        fwrite(s,[cmd_counter(3,n); cmd_counter(4,n)],'uint16','async');
    end
    pause(0.5);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cfg timer
disp('���ü�����ʱ��')
try
    fwrite(s,[cmd_timer(1,1); cmd_timer(2,1)],'uint16','async');
end
pause(0.5);
try
    fwrite(s,[cmd_timer(3,1); cmd_timer(4,1)],'uint16','async');
end
pause(0.5);
start_time=tic;
cfgDone = dec2bin(fread(s,1,'uint32'),32);
assert((str2double(cfgDone(1)) == 1),'����������ʧ��');
disp('�����������');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
savePath = 'C:\test.txt';
savePeriod = 20;
countDone = ReadCount( s, savePeriod, savePath, Table_Output);
assert((countDone >= 2^31+2^30),'���������źų�����');
fclose(s);
%{
disp('��ȡ����')
flag=1;
aaa = 1;
    tic
while 1 ==1
    
    cntRtn0 = [];
    cntRtn1 = [];
    

    rxData = fread(s,1,'uint32');
    
    if rxData == 2^31 + 2^30
        cntDone = dec2bin(rxData);
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('��ʾ����');
    n=length(cntVal);
    Data_Output=zeros(1,64);
    for i=1:n
            Data_Output(i)=cntVal(i);
    end
    Data_Output=reshape(Data_Output,8,8);
    set(Table_Output,'Data',Data_Output);
    pause(0.1);
end
fclose(s);
disp('��ȡ����');
%}
end