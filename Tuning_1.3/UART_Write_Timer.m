function [cmd]=UART_Write_Timer(Table_Timer)
Data_Timer=get(Table_Timer,'Data');
cmd=zeros(4,1);
Data_Timer=Data_Timer*99*500000;
Data_Timer_Binary=dec2bin(Data_Timer,47);
Data_Timer_High=Data_Timer_Binary(1:23);
Data_Timer_Low=Data_Timer_Binary(24:47);
cmd_low_now= ['10' '000000' Data_Timer_Low];
cmd_high_now=['11' '0000000' Data_Timer_High];
cmd(2,1)=bin2dec(cmd_low_now(1:16)); %%build low command low
cmd(1,1)=bin2dec(cmd_low_now(17:32)); %%build low command high
cmd(4,1)=bin2dec(cmd_high_now(1:16)); %%build high command low
cmd(3,1)=bin2dec(cmd_high_now(17:32)); %%build high command high
end