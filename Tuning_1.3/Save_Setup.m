function Save_Setup(Table_Delay,Table_Counter,Table_Timer)
Data_Delay=get(Table_Delay,'Data')
Data_Counter=get(Table_Counter,'Data')
Data_Timer=get(Table_Timer,'Data')
prompt={'�������ļ���'};
dlg_title='�Ի���';
num_lines=1;
def={'1'};
value=inputdlg(prompt,dlg_title,num_lines,def);
save([cell2mat(value) '.mat'],'Data_Delay','Data_Counter','Data_Timer');
end