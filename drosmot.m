%% cleaning
clear
clc
close all
%% frames
hight = 16;
width = 7;
L=zeros(32,64,60);
for t = 1:size(L,3)
    for x = hight/2:3*hight/2
        for y = t:t+width
            L(x,y,t)=1;
        end
    end
end
L=L(1:32,1:64,1:60);
%% retina layer
Ps=zeros(size(L));
for x = 1:size(L,1)
	for y = 1:size(L,2)
		for t = 1:size(L,3)
			Ps(x,y,t) = P(x,y,t,L,Ps);
		end
	end
end
%% lamina layer
% 0-padding
Plet=zeros(size(Ps,1)+4,size(Ps,2)+4, size(Ps,3));
Ple = Plet;
Plet(3:end-2,3:end-2,:)=Ps;
Plit=zeros(size(Ps,1)+8,size(Ps,2)+8, size(Ps,3));
Pli=Plit;
Plit(5:end-4,5:end-4,:)=Ps;
for x = 3:size(Ple,1)-2
    for y = 3:size(Ple,2)-2
        for t = 1:size(Ple,3)
            for u = -2:2
                for v = -2:2
                    Ple(x,y,t) = Ple(x,y,t)+Pl(x,y,t,Plet,u,v,4);
                end
            end
        end
    end
end
for x = 5:size(Ple,1)-4
    for y = 5:size(Ple,2)-4
        for t = 1:size(Ple,3)
            for u = -4:4
                for v = -4:4
                    Pli(x,y,t) = Pli(x,y,t)+Pl(x,y,t,Plit,u,v,2);
                end
            end
        end
    end
end
Ple=Ple(3:34,3:66,:);
Pli=Pli(5:36,5:68,:);
clear Plit
clear Plet
La=zeros(size(L));
for x = 1:size(L,1)
    for y = 1:size(L,2)
        for t = 1:size(L,3)
            if Ple(x,y,t) >= 0 && Pli(x,y,t) >= 0
                La(x,y,t) = abs(Ple(x,y,t) - Pli(x,y,t));
            end
            if Ple(x,y,t) < 0 && Pli(x,y,t) < 0
                La(x,y,t) = -abs(Ple(x,y,t) - Pli(x,y,t));
            end
        end
    end
end
Lon=max(0,La);
Loff=min(La,0);
DLon=zeros(size(L));DLoff=zeros(size(L));
for x = 1:size(L,1)
    for y = 1:size(L,2)
        for t = 2:size(L,3)
            DLon(x,y,t) = Lon(x,y,t) - Lon(x,y,t-1);
            DLoff(x,y,t) = Loff(x,y,t) -Loff(x,y,t-1);
        end
    end
end
taui=1;
tau1=1;
tau2=3;
alpha1=taui/(tau1+taui);
alpha2=taui/(tau2+taui);
Lonhat=zeros(size(L));
Loffhat=zeros(size(L));
for x = 1:size(L,1)
    for y = 1:size(L,2)
        for t = 2:size(L,3)
            if DLon(x,y,t) >= 0
                Lonhat(x,y,t)=(alpha1*Lon(x,y,t))+((1-alpha1)*Lon(x,y,t-1));
            end
            if DLon(x,y,t) <0
                Lonhat(x,y,t)=(alpha2*Lon(x,y,t))+((1-alpha2)*Lon(x,y,t-1));
            end
            if DLoff(x,y,t) >= 0
                Loffhat(x,y,t)=(alpha1*Loff(x,y,t))+((1-alpha1)*Loff(x,y,t-1));
            end
            if DLoff(x,y,t) <0
                Loffhat(x,y,t)=(alpha2*Loff(x,y,t))+((1-alpha2)*Loff(x,y,t-1));
            end
        end
    end
end
Mon = Lon-Lonhat;
Moff = Loff-Loffhat;
%% Medulla layer
%taus=1;
%taus=2;
%taus=3;
%taus=4;
%taus=5;
taus=6;
alpha3=taui/(taui+taus);
Monhat=zeros(size(L));
for x = 1:size(L,1)
    for y = 1:size(L,2)
        for t = 2:size(L,3)
            Monhat(x,y,t)=(alpha3*Mon(x,y,t))+((1-alpha3)*Mon(x,y,t-1));
        end
    end
end
% 0-padding
Mont=zeros(size(Mon,1)+32,size(Mon,2)+32,size(Mon,3));
Mont(17:end-16,17:end-16,:)=Mon;
Monhatt=zeros(size(Monhat,1)+32,size(Monhat,2)+32,size(Monhat,3));
Monhatt(17:end-16,17:end-16,:)=Monhat;
t4r=zeros(size(Monhatt));t4l=zeros(size(Monhatt));t4d=zeros(size(Monhatt));t4u=zeros(size(Monhatt));
for x = 17:size(Mont,1)-16
    for y = 17:size(Mont,2)-16
        for t = 2:size(Mont,3)
            for i = 4:16
                t4r(x,y,t)=t4r(x,y,t)+(Monhatt(x,y,t)*Mont(x+i,y,t));
                t4l(x,y,t)=t4l(x,y,t)+(Monhatt(x+i,y,t)*Mont(x,y,t));
                t4d(x,y,t)=t4d(x,y,t)+(Monhatt(x,y,t)*Mont(x,y+i,t));
                t4u(x,y,t)=t4u(x,y,t)+(Monhatt(x,y+i,t)*Mont(x,y,t));
            end
        end
    end
end
clear Monhatt
clear Mont
t4r=t4r(17:48,17:80,:);t4l=t4l(17:48,17:80,:);t4d=t4d(17:48,17:80,:);t4u=t4u(17:48,17:80,:);
%% Lobula layer
Moffhat=zeros(32,64,60);
for x = 1:size(L,1)
    for y = 1:size(L,2)
        for t = 2:size(L,3)
            Moffhat(x,y,t)=(alpha3*Moff(x,y,t))+((1-alpha3)*Moff(x,y,t-1));
        end
    end
end
% 0-padding
Mofft=zeros(size(Moff,1)+32,size(Moff,2)+32,size(Moff,3));
Mofft(17:end-16,17:end-16,:)=Moff;
Moffhatt=zeros(size(Moffhat,1)+32,size(Moffhat,2)+32,size(Moffhat,3));
Moffhatt(17:end-16,17:end-16,:)=Moffhat;
t5r=zeros(size(Moffhatt));t5l=zeros(size(Moffhatt));t5d=zeros(size(Moffhatt));t5u=zeros(size(Moffhatt));
for x = 17:size(Mofft,1)-16
    for y = 17:size(Mofft,2)-16
        for t = 2:size(Mofft,3)
            for i = 4:16
                t5r(x,y,t)=t5r(x,y,t)+(Moffhatt(x,y,t)*Mofft(x+i,y,t));
                t5l(x,y,t)=t5l(x,y,t)+(Moffhatt(x+i,y,t)*Mofft(x,y,t));
                t5d(x,y,t)=t5d(x,y,t)+(Moffhatt(x,y,t)*Mofft(x,y+i,t));
                t5u(x,y,t)=t5u(x,y,t)+(Moffhatt(x,y+i,t)*Mofft(x,y,t));
            end
        end
    end
end
clear Moffhatt
clear Mofft
t5r=t5r(17:48,17:80,:);t5l=t5l(17:48,17:80,:);t5d=t5d(17:48,17:80,:);t5u=t5u(17:48,17:80,:);
%% Lobulla plate layer
LPr=zeros(1,size(L,3));
LPl=zeros(1,size(L,3));
LPd=zeros(1,size(L,3));
LPu=zeros(1,size(L,3));
for t = 2:size(t4r,3)
    for x = 1:size(t4r,1)
        for y= 1:size(t4r,2)
         LPr(t)=LPr(t-1)+t4r(x,y,t)+t5r(x,y,t);
         LPl(t)=LPl(t-1)+t4l(x,y,t)+t5l(x,y,t);
         LPd(t)=LPd(t-1)+t4d(x,y,t)+t5d(x,y,t);
         LPu(t)=LPu(t-1)+t4u(x,y,t)+t5u(x,y,t);
        end
    end
end
%%
HS=zeros(1,60);
VS=zeros(1,60);
for t = 1:size(LPr,2)
    HS(t)=LPr(t)-LPl(t);
    VS(t)=LPd(t)-LPu(t);
end
%% retina layer functions
function rmot = P(x,y,t,L,Ps)
    if t==1 
		rmot = L(x,y,t)+a(1);
	elseif t==2
		rmot = L(x,y,t)-L(x,y,t-1) + (a(1)*Ps(x,y,t-1));
	else
		rmot = L(x,y,t)-L(x,y,t-1) + ((a(1)*Ps(x,y,t-1)) + (a(2)*Ps(x,y,t-2)));
    end
end
function decay = a(i)
	decay = 1/(1+exp(i));
end
%% lamina layer functions
function vdog = Pl(x,y,t,Plx,u,v,sig)
	vdog=Plx(x-u,y-v,t)*G(u,v,sig);
end
function kernel = G(u,v,sig)
	kernel = (1/(2*pi*(sig^2))) * exp(-(u^2+v^2)/(2*sig^2));
end
