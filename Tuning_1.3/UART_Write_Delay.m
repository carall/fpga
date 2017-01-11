function [cmd]=UART_Write_Delay(Table_Delay,cmd_select)
Data_Delay=get(Table_Delay,'Data');  %%read input data
n=size(Data_Delay,2); %% size the data   
cmd=zeros(size(Data_Delay)); %% size the output data
for i=1:n   %% build all the 32 bits command
    cmd_now=['0000' dec2bin(i-1,4) '0000000']; %%build the highest 15bits
    if(cmd_select(i)<=0) %%build "Sel" bits
        cmd_now=[cmd_now '0']; 
    else
        cmd_now=[cmd_now '1']; 
    end
    cmd_now=[cmd_now dec2bin(Data_Delay(2,i),8)]; %%build Coarse Delay bits
    cmd_now=[cmd_now dec2bin(Data_Delay(1,i),8)]; %%build Fine Delay bits
    cmd(2,i)=bin2dec(cmd_now(1:16)); %%build low command
    cmd(1,i)=bin2dec(cmd_now(17:32)); %%build high command
end
end
