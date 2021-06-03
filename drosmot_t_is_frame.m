%% cleaning
clear
clc
close all
%% frames
hight = 16;
width = 7;
L=zeros(32,64,64);
for t = 1:size(L,3)
    for x = hight/2:3*hight/2
        for y = t:t+width
            L(x,y,t)=1;
        end
    end
end
L=L(:,1:64,:);
%% retina layer
Ps=zeros(size(L));
for x = 1:size(L,1)
	for y = 1:size(L,2)
		for t = 2:size(L,3)
			Ps(x,y,t) = P(x,y,t,L,Ps);
		end
	end
end
%% lamina layer
Ple=padarray(Ps,[2 2]);
Pli=padarray(Ps,[4 4]);

for x = 3:size(Ple,1)-2
    for y = 3:size(Ple,2)-2
        for t = 1:size(Ple,3)
            for u = -2:2
                for v = -2:2
                    Ple(x,y,t) = Ple(x,y,t)+Pl(x,y,t,Ple,u,v,4);
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
                    Pli(x,y,t) = Pli(x,y,t)+Pl(x,y,t,Pli,u,v,2);
                end
            end
        end
    end
end

Ple=Ple(3:size(Ple,1)-2,3:size(Ple,2)-2,:);
Pli=Pli(5:size(Pli,1)-4,5:size(Pli,2)-4,:);
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
DLon=zeros(size(Lon));
DLoff=zeros(size(Loff));
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
Lonhat=zeros(size(Lon));
Loffhat=zeros(size(Loff));

for x = 1:size(L,1)
    for y = 1:size(L,2)
        for t = 2:size(L,3)
            if DLon(x,y,t)>=0
                Lonhat(x,y,t)=alpha1*Lon(x,y,t)+(1-alpha1)*Lon(x,y,t-1);
            else
                Lonhat(x,y,t)=alpha2*Lon(x,y,t)+(1-alpha2)*Lon(x,y,t-1);
            end
            if DLoff(x,y,t)>=0
                Loffhat(x,y,t)=alpha1*Loff(x,y,t)+(1-alpha1)*Loff(x,y,t-1);
            else
                Loffhat(x,y,t)=alpha2*Loff(x,y,t)+(1-alpha2)*Loff(x,y,t-1);
            end
        end
    end
end

Mon=Lon-Lonhat;
Moff=Loff-Loffhat;
%% Medulla layer
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

Mon=padarray(Mon,[16 16]);
Monhat=padarray(Monhat,[16 16]);
t4r=zeros(size(Monhat));t4l=zeros(size(Monhat));t4d=zeros(size(Monhat));t4u=zeros(size(Monhat));

for x = 17:size(Mon,1)-16
    for y = 17:size(Mon,2)-16
        for t = 2:size(Mon,3)
            for i = 4:16
                t4r(x,y,t)=t4r(x,y,t)+(Monhat(x,y,t)*Mon(x+i,y,t));
                t4l(x,y,t)=t4r(x,y,t)+(Monhat(x+i,y,t)*Mon(x,y,t));
                t4d(x,y,t)=t4r(x,y,t)+(Monhat(x,y,t)*Mon(x,y+i,t));
                t4u(x,y,t)=t4r(x,y,t)+(Monhat(x,y+i,t)*Mon(x,y,t));
            end
        end
    end
end

Mon=Mon(17:size(Mon,1)-16,17:size(Mon,2)-16,:);
Monhat=Monhat(17:size(Monhat,1)-16,17:size(Monhat,2)-16,:);
t4r=t4r(17:size(t4r,1)-16,17:size(t4r,2)-16,:);
t4l=t4l(17:size(t4l,1)-16,17:size(t4l,2)-16,:);
t4d=t4d(17:size(t4d,1)-16,17:size(t4d,2)-16,:);
t4u=t4u(17:size(t4u,1)-16,17:size(t4u,2)-16,:);

%% lobula layer
Moffhat=zeros(size(L));
for x = 1:size(L,1)
    for y = 1:size(L,2)
        for t = 2:size(L,3)
            Moffhat(x,y,t)=(alpha3*Moff(x,y,t))+((1-alpha3)*Moff(x,y,t-1));
        end
    end
end

Moff=padarray(Moffhat, [16 16]);
Moffhat=padarray(Moffhat, [16 16]);
t5r=zeros(size(Moffhat));t5l=zeros(size(Moffhat));t5d=zeros(size(Moffhat));t5u=zeros(size(Moffhat));

for x = 17:size(Moff,1)-16
    for y = 17:size(Moff,2)-16
        for t = 2:size(Moff,3)
            for i = 4:16
                t5r(x,y,t)=t5r(x,y,t)+(Moffhat(x,y,t)*Moff(x+i,y,t));
                t5l(x,y,t)=t5l(x,y,t)+(Moffhat(x+i,y,t)*Moff(x,y,t));
                t5d(x,y,t)=t5d(x,y,t)+(Moffhat(x,y,t)*Moff(x,y+i,t));
                t5u(x,y,t)=t5u(x,y,t)+(Moffhat(x,y+i,t)*Moff(x,y,t));
            end
        end
    end
end

Moff=Moff(17:size(Moff,1)-16,17:size(Moff,2)-16,:);
Moffhat=Moffhat(17:size(Moffhat,1)-16,17:size(Moffhat,2)-16,:);
t5r=t5r(17:size(t5r,1)-16,17:size(t5r,2)-16,:);
t5l=t5l(17:size(t5l,1)-16,17:size(t5l,2)-16,:);
t5d=t5d(17:size(t5d,1)-16,17:size(t5d,2)-16,:);
t5u=t5u(17:size(t5u,1)-16,17:size(t5u,2)-16,:);

%% lobula plate
LPr=zeros(1,size(L,3));
LPl=zeros(1,size(L,3));
LPd=zeros(1,size(L,3));
LPu=zeros(1,size(L,3));
for t = 1:size(t4r,3)
    for y = 1:size(t4r,2)
        for x = 1:size(t4r,1)
         LPr(t)=LPr(t)+t4r(x,y,t)+t5r(x,y,t);
         LPl(t)=LPl(t)+t4l(x,y,t)+t5l(x,y,t);
         LPd(t)=LPd(t)+t4d(x,y,t)+t5d(x,y,t);
         LPu(t)=LPu(t)+t4u(x,y,t)+t5u(x,y,t);
        end
    end
end

%% output
HS=zeros(1,60);
VS=zeros(1,60);
for t = 1:size(LPr,2)
    HS(t)=LPr(t)-LPl(t);
    VS(t)=LPd(t)-LPu(t);
end

%% retina layer functions
function rmot = P(x,y,t,L,Ps) 
		rmot = L(x,y,t)-L(x,y,t-1)+a(1)*Ps(x,y,t-1);
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
