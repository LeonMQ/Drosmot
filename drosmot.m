%% cleaning
clear
clc
close all
%% frames
L=zeros(32,64,60);
for t = 1:size(L,3)
	if t>=2
		if t<=57
			L(9,t,t)=1;
			L(10,t,t)=1;
			L(11,t,t)=1;
			L(12,t,t)=1;
			L(13,t,t)=1;
			L(14,t,t)=1;
			L(15,t,t)=1;
			L(16,t,t)=1;
			L(17,t,t)=1;
			L(18,t,t)=1;
			L(19,t,t)=1;
			L(20,t,t)=1;
			L(21,t,t)=1;
			L(22,t,t)=1;
			L(23,t,t)=1;
			L(24,t,t)=1;
			
			L(9,t+1,t)=1;
			L(10,t+1,t)=1;
			L(11,t+1,t)=1;
			L(12,t+1,t)=1;
			L(13,t+1,t)=1;
			L(14,t+1,t)=1;
			L(15,t+1,t)=1;
			L(16,t+1,t)=1;
			L(17,t+1,t)=1;
			L(18,t+1,t)=1;
			L(19,t+1,t)=1;
			L(20,t+1,t)=1;
			L(21,t+1,t)=1;
			L(22,t+1,t)=1;
			L(23,t+1,t)=1;
			L(24,t+1,t)=1;

			L(9,t+2,t)=1;
			L(10,t+2,t)=1;
			L(11,t+2,t)=1;
			L(12,t+2,t)=1;
			L(13,t+2,t)=1;
			L(14,t+2,t)=1;
			L(15,t+2,t)=1;
			L(16,t+2,t)=1;
			L(17,t+2,t)=1;
			L(18,t+2,t)=1;
			L(19,t+2,t)=1;
			L(20,t+2,t)=1;
			L(21,t+2,t)=1;
			L(22,t+2,t)=1;
			L(23,t+2,t)=1;
			L(24,t+2,t)=1;

			L(9,t+3,t)=1;
			L(10,t+3,t)=1;
			L(11,t+3,t)=1;
			L(12,t+3,t)=1;
			L(13,t+3,t)=1;
			L(14,t+3,t)=1;
			L(15,t+3,t)=1;
			L(16,t+3,t)=1;
			L(17,t+3,t)=1;
			L(18,t+3,t)=1;
			L(19,t+3,t)=1;
			L(20,t+3,t)=1;
			L(21,t+3,t)=1;
			L(22,t+3,t)=1;
			L(23,t+3,t)=1;
			L(24,t+3,t)=1;

			L(9,t+4,t)=1;
			L(10,t+4,t)=1;
			L(11,t+4,t)=1;
			L(12,t+4,t)=1;
			L(13,t+4,t)=1;
			L(14,t+4,t)=1;
			L(15,t+4,t)=1;
			L(16,t+4,t)=1;
			L(17,t+4,t)=1;
			L(18,t+4,t)=1;
			L(19,t+4,t)=1;
			L(20,t+4,t)=1;
			L(21,t+4,t)=1;
			L(22,t+4,t)=1;
			L(23,t+4,t)=1;
			L(24,t+4,t)=1;
			
			L(9,t+5,t)=1;
			L(10,t+5,t)=1;
			L(11,t+5,t)=1;
			L(12,t+5,t)=1;
			L(13,t+5,t)=1;
			L(14,t+5,t)=1;
			L(15,t+5,t)=1;
			L(16,t+5,t)=1;
			L(17,t+5,t)=1;
			L(18,t+5,t)=1;
			L(19,t+5,t)=1;
			L(20,t+5,t)=1;
			L(21,t+5,t)=1;
			L(22,t+5,t)=1;
			L(23,t+5,t)=1;
			L(24,t+5,t)=1;

			L(9,t+6,t)=1;
			L(10,t+6,t)=1;
			L(11,t+6,t)=1;
			L(12,t+6,t)=1;
			L(13,t+6,t)=1;
			L(14,t+6,t)=1;
			L(15,t+6,t)=1;
			L(16,t+6,t)=1;
			L(17,t+6,t)=1;
			L(18,t+6,t)=1;
			L(19,t+6,t)=1;
			L(20,t+6,t)=1;
			L(21,t+6,t)=1;
			L(22,t+6,t)=1;
			L(23,t+6,t)=1;
			L(24,t+6,t)=1;
		end
	end
end

%% retina layer
Ps=zeros(size(L,1),size(L,2),size(L,3));
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
Lon=zeros(size(Ps,1),size(Ps,2), size(Ps,3));Loff=zeros(size(Ps,1),size(Ps,2), size(Ps,3));
for x = 1:size(L,1)
	for y = 1:size(L,2)
		for t = 1:size(L,3)
            if La(x,y,t) > 0
                Lon(x,y,t) = La(x,y,t);
            end
            if La(x,y,t) < 0
                Loff(x,y,t) = La(x,y,t);
            end
        end
    end
end
DLon=zeros(size(Lon,1),size(Lon,2),size(Lon,3));DLoff=zeros(size(Loff,1),size(Loff,2),size(Loff,3));
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
Lonhat=zeros(size(Lon,1),size(Lon,2),size(Lon,3));Loffhat=zeros(size(Loff,1),size(Loff,2),size(Loff,3));
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
%%
Mon=zeros(32,64,60);
Moff=zeros(32,64,60);
Mon = Lon-Lonhat;
Moff = Loff-Loffhat;
%% Medulla layer
taus=1;
%taus=2;
%taus=3;
%taus=4;
%taus=5;
%taus=6;
alpha3=taui/(taui+taus);
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
t4rt=t4r(17:48,17:80,:);t4lt=t4l(17:48,17:80,:);t4dt=t4d(17:48,17:80,:);t4ut=t4u(17:48,17:80,:);
%% Lobula layer
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
t5rt=t5r(17:48,17:80,:);t5lt=t5l(17:48,17:80,:);t5dt=t5d(17:48,17:80,:);t5ut=t5u(17:48,17:80,:);
%% Lobulla plate layer
LPr=zeros(1,size(L,3));
LPl=zeros(1,size(L,3));
LPd=zeros(1,size(L,3));
LPu=zeros(1,size(L,3));
for t = 1:size(t4rt,3)
    for x = 1:size(t4rt,1)
        for y= 1:size(t4rt,2)
         LPr(t)=LPr(t)+t4rt(x,y,t)+t5rt(x,y,t);
         LPl(t)=LPl(t)+t4rt(x,y,t)+t5rt(x,y,t);
         LPd(t)=LPd(t)+t4rt(x,y,t)+t5rt(x,y,t);
         LPu(t)=LPu(t)+t4rt(x,y,t)+t5rt(x,y,t);
        end
    end
end
%%
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
