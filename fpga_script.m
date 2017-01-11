
clear;
s=serial('com5');
s.Baudrate = 9600;
s.DataBits = 8;
s.FlowControl = 'hardware';
s.Parity = 'odd';
s.StopBits = 1;
s.Timeout = 10;
fopen(s);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fwrite(s,[0;1],'uint16','async');
pause(0.5);
for n=1:15
    dly_address = 2^8*n;
    fwrite(s,[0;dly_address],'uint16','async');
    pause(0.5);
end
pause(0.5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
channel = 1;
cnt_low_low = 2^(channel-1);
fwrite(s,[cnt_low_low;2^14+1],'uint16','async');
pause(0.5);
fwrite(s,[0;2^14+2],'uint16','async');
pause(0.5);
for n=1:63
    cnt_address = 2^8*n;
    fwrite(s,[0;2^14+cnt_address+1],'uint16','async');
    pause(0.5);
    fwrite(s,[0;2^14+cnt_address+2],'uint16','async');
    pause(0.5);
end
pause(0.5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time = 10;
timer = time*99*500000;
timer_bin = dec2bin(timer,47);
timer_low2 = ['10000000' timer_bin(24:31)];
timer_low2_dec = bin2dec(timer_low2);
timer_low1 = timer_bin(32:47);
timer_low1_dec = bin2dec(timer_low1);
timer_high2 = ['110000000' timer_bin(1:7)];
timer_high2_dec = bin2dec(timer_high2);
timer_high1 = timer_bin(8:23);
timer_high1_dec = bin2dec(timer_high1);
try
    fwrite(s,[timer_low1_dec;timer_low2_dec],'uint16','async');
    pause(0.5);
    fwrite(s,[timer_high1_dec;timer_high2_dec],'uint16','async');
end
pause(0.5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cfgDone = dec2bin(fread(s,1,'uint32'),32);
assert((str2double(cfgDone(1)) == 1),'Configure failed!');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
temp = fread(s,1,'uint32');
cnt_mat = zeros(1,64);
while temp<2^31+2^30 %read one counter data in one loop
    cnt_val_low = dec2bin(temp,32);
    cnt_val_high = dec2bin(fread(s,1,'uint32'),32);
    cnt_adres_low = bin2dec(cnt_val_low(3:8));
    cnt_adres_high = bin2dec(cnt_val_high(3:8));
    assert((cnt_adres_low == cnt_adres_high),'counter data address error!');
    address = cnt_adres_low;
    val = bin2dec(cnt_val_low(9:32)) + bin2dec(cnt_val_high(9:32))*2^24;
    cnt_mat(address+1) = val;
    temp = fread(s,1,'uint32');
end
count_val = cnt_mat(1);
assert((temp >= 2^31+2^30),'Reading counting done failed!');
fclose(s);