clc;
clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig=figure('Menu','none','Color','w','Name','FPGA-GUI','NumberTitle','off','Position',[50,50,1280,720]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Num=1;
Size_X=0.03;
Size_Width=1-Size_X*2;
Size_X_Panel=0.01;
Size_Width_Panel=1-Size_X_Panel*2;
Size_Y=1;
Size_Gap=0.01;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置延迟 
Size_H_Panel_Delay=0.14;
Size_Y_Panel_Delay=Size_Y-Size_H_Panel_Delay;
uipanel('Title','设置触发延迟 (0: Unused)  (Fine Delay: 1-66 Taps)  (Coarse Delay: 1-255 Taps)','FontSize',12,'BackgroundColor','white','Position',[Size_X_Panel,Size_Y_Panel_Delay,Size_Width_Panel,Size_H_Panel_Delay]);
Size_H_Table_Delay=0.09;
Size_Y_Table_Delay=Size_Y_Panel_Delay+Size_Gap;
Table_Data_Delay=zeros(2,16);
rowname={'Fine Delay','Coarse Delay'};
columnformat={'numeric'};columnformat=repmat(columnformat,1,16);
columneditable=true(1,16);
Table_Delay=uitable('Parent',fig,'Data',Table_Data_Delay,'Units','normalized','Position',[Size_X,Size_Y_Table_Delay,Size_Width,Size_H_Table_Delay],'RowName',rowname,'ColumnFormat',columnformat,'ColumnEditable',columneditable,'ColumnWidth',{65}); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置计数器
Size_H_Panel_Counter=0.46;
Size_Y_Panel_Counter=Size_Y_Panel_Delay-Size_H_Panel_Counter-Size_Gap;
uipanel('Title','设置计数器工作模式(0: Unused)  (1: Normal)  (2: Reverse) ','FontSize',12,'BackgroundColor','white','Position',[Size_X_Panel,Size_Y_Panel_Counter,Size_Width_Panel-0.36,Size_H_Panel_Counter]);
Size_H_Table_Counter=0.41;
Size_Y_Table_Counter=Size_Y_Panel_Counter+Size_Gap;
Table_Data_Counter=[repmat({0},64,16) repmat({'Or'},64,1)];
rowname=[];
for i=1:64
    temp=sprintf('Counter:  %d',i);
    rowname=[rowname {temp}]; %#ok<AGROW>    
end
columnformat=[];
for i=1:16
    columnformat=[columnformat {'numeric'}]; %#ok<AGROW>
end
columnformat=[columnformat {{'Or' 'And'}}];
columneditable=true(1,17);
Table_Counter=uitable('Parent',fig,'Data',Table_Data_Counter,'Units','normalized','Position',[Size_X,Size_Y_Table_Counter,Size_Width-0.36,Size_H_Table_Counter],'RowName',rowname,'ColumnFormat',columnformat,'ColumnEditable',columneditable,'ColumnWidth',{34}); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置时间
uipanel('Title','设置计数器时间  (单位: 秒)','FontSize',12,'BackgroundColor','white','Position',[Size_X_Panel+0.64,Size_Y_Panel_Counter+0.35,0.34,Size_H_Panel_Counter-0.35]);
Table_Data_Timer=0;
Table_Timer=uitable('Parent',fig,'Data',Table_Data_Timer,'Units','normalized','Position',[Size_X+0.64,Size_Y_Table_Counter+0.35,0.30,Size_H_Table_Counter-0.35],'RowName',{'Timer:'},'ColumnName',{'Seconds'},'ColumnFormat',{'numeric'},'ColumnEditable',true,'ColumnWidth',{200}); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%读取配置与操作
uipanel('Title','读取配置与操作','FontSize',12,'BackgroundColor','white','Position',[Size_X_Panel+0.64,Size_Y_Panel_Counter,0.34,Size_H_Panel_Counter-0.12]);
file=dir('*.mat');
n=length(file);
Table_Data_Setup=[];
Table_Setup_Row_Name=[];
Table_Setup_Column_Format=[];
Table_Setup_Column_Editable=false(1,n);
for i=1:n
    Table_Data_Setup=[Table_Data_Setup {file(i).name}];
    Table_Setup_Row_Name=[Table_Setup_Row_Name {'File Name:'}];
    Table_Setup_Column_Format=[Table_Setup_Column_Format {'numeric'}];
end
Table_Data_Setup=Table_Data_Setup';
Table_Setup_Row_Name=Table_Setup_Row_Name';
Table_Setup=uitable('Parent',fig,'Data',Table_Data_Setup,'Units','normalized','Position',[Size_X_Panel+0.66,Size_Y_Panel_Counter+0.01,0.2,Size_H_Panel_Counter-0.18],'RowName',Table_Setup_Row_Name,'ColumnName',{'Name'},'ColumnFormat',Table_Setup_Column_Format,'ColumnEditable',Table_Setup_Column_Editable,'ColumnWidth',{130}); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%显示连续读取数据
Size_H_Panel_Bar=0.35;
Size_Y_Panel_Bar=Size_Y_Panel_Counter-Size_H_Panel_Bar-Size_Gap;
uipanel('Title','显示连续读取数据','FontSize',12,'BackgroundColor','white','Position',[Size_X_Panel,Size_Y_Panel_Bar,Size_Width_Panel-0.3,Size_H_Panel_Bar]);
Size_H_Bar=0.3;
Size_Y_Bar=Size_Y_Panel_Bar+Size_Gap*2;
Table_Data_Output=repmat({0},8,8);
Table_Output_Row_Name=[];
Table_Output_Column_Format=[];
Table_Output_Column_Editable=true(1,64);
for i=1:8
    Table_Output_Row_Name=[Table_Output_Row_Name {['Counter' num2str(i) ':']}];
    Table_Output_Column_Format=[Table_Output_Column_Format {'numeric'}];
end
Table_Output_Row_Name=Table_Output_Row_Name';
Table_Output=uitable('Parent',fig,'Data',Table_Data_Output,'Units','normalized','Position',[Size_X,Size_Y_Bar,Size_Width-0.3,Size_H_Bar],'RowName',Table_Output_Row_Name,'ColumnFormat',Table_Output_Column_Format,'ColumnEditable',Table_Output_Column_Editable,'ColumnWidth',{88}); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%显示调试数据
uipanel('Title','显示调试数据','FontSize',12,'BackgroundColor','white','Position',[Size_X_Panel+0.7,Size_Y_Panel_Bar,Size_Width_Panel-0.7,Size_H_Panel_Bar]);
axes('position',[Size_X+0.7,Size_Y_Bar,Size_Width-0.7,Size_H_Bar]);
Bar_Data=0;
bar(Bar_Data);
xlim([1,64]);
Bar1=gca;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%按钮响应函数
uicontrol('Parent',fig,'Style','PushButton','CallBack','Button_Start2(Table_Delay,Table_Counter,Table_Timer,Table_Output);','String','连续采集','Units','normalized','Position',[Size_X_Panel+0.88,Size_Y_Panel_Counter+0.02,0.08,0.06]);
uicontrol('Parent',fig,'Style','PushButton','CallBack','Button_Start1(Table_Delay,Table_Counter,Table_Timer,Table_Output,Bar1);','String','调试','Units','normalized','Position',[Size_X_Panel+0.88,Size_Y_Panel_Counter+0.1,0.08,0.06]);
uicontrol('Parent',fig,'Style','PushButton','CallBack','Save_Setup(Table_Delay,Table_Counter,Table_Timer)','String','保存设置','Units','normalized','Position',[Size_X_Panel+0.88,Size_Y_Panel_Counter+0.18,0.08,0.06]);
uicontrol('Parent',fig,'Style','PushButton','CallBack','Load_Setup(Table_Delay,Table_Counter,Table_Timer)','String','读取设置','Units','normalized','Position',[Size_X_Panel+0.88,Size_Y_Panel_Counter+0.26,0.08,0.06]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%