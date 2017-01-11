clc;
clear;
a=rand(1,5)*100;
h=bar(a);
h1=gca;
xlim(gca,[0 5+1]);
ylim(gca,[0 max(a)*1.2]);
hx = get(h(1),'XData'); % ×Ý×ø±ê
hy=  get(h(1),'YData'); % ×Ý×ø±ê
text(hx,hy+max(a)*0.05,'string')