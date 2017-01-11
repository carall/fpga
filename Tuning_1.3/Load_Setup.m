function Load_Setup(Table_Delay,Table_Counter,Table_Timer)
prompt={'请输入文件名'};
dlg_title='对话框';
num_lines=1;
def={'1'};
value=inputdlg(prompt,dlg_title,num_lines,def);
Data=load([cell2mat(value) '.mat']);
Data_Delay=Data.Data_Delay;
Data_Counter=Data.Data_Counter;
Data_Timer=Data.Data_Timer;
set(Table_Delay,'Data',Data_Delay);
set(Table_Counter,'Data',Data_Counter);
set(Table_Timer,'Data',Data_Timer);
end