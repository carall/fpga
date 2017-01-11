function [cmd]=UART_Write_Counter(Table_Counter)
Data_Counter=get(Table_Counter,'Data');
n=size(Data_Counter,2); %% size the data   
cmd=zeros(4,n); %% size the output data
for i=1:n   %% build all the 32 bits command
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%build counter low 32 bits
    cmd_low_now= ['01' dec2bin(i-1,6) '000000' '0'];
    if(strcmp(Data_Counter(i,17),'Or'))%or 0 and 1
        cmd_low_now=[cmd_low_now '1'];
    else
        cmd_low_now=[cmd_low_now '0'];
    end
    for ii=16:-1:1
        if(cell2mat(Data_Counter(i,ii))==0)
            cmd_low_now=[cmd_low_now '0'];
        else
            cmd_low_now=[cmd_low_now '1'];
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%build counter high32 bits
    cmd_high_now=['01' dec2bin(i-1,6) '000000' '1'];
    cmd_high_now=[cmd_high_now '0'];
    for ii=16:-1:1
        if(cell2mat(Data_Counter(i,ii))==2)%reverse 1 normal 0
            cmd_high_now=[cmd_high_now '1'];
        else
            cmd_high_now=[cmd_high_now '0'];
        end
    end
    cmd(2,i)=bin2dec(cmd_low_now(1:16)); %%build low command low
    cmd(1,i)=bin2dec(cmd_low_now(17:32)); %%build low command high
    cmd(4,i)=bin2dec(cmd_high_now(1:16)); %%build high command low
    cmd(3,i)=bin2dec(cmd_high_now(17:32)); %%build high command high
end
end