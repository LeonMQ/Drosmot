%% cleaning
clear
clc
close all
%% frames
L=zeros(32,64,60);
for t = 1:size(L,3)
	if t>=2
		if t<-58
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
			Ps(x,y,t) = P(x,y,t,L);
		end
	end
end

%% lamina layer
Ple=zeros(size(Ps,1)+4,size(Ps,2)+4, size(Ps,3));
Ple(3:end-2,3:end-2)=Ps;
Pli=zeros(size(Ps,1)+8,size(Ps,2)+8, size(Ps,3));
Pli(5:end-4,5:end-4)=Ps;
for x = 3:size(Ple,1)-2
	for y = 3:size(Ple,2)-2
		for t in 1:size(Ple,3)
			for u in -2:2
				for v in -2:2
				
				end
			end
		end
	end
end
%% retina layer functions
function rmot = P(x,y,t,L)
	if t==1 
		rmot = L(x,y,t)+a(1);
	elseif t==2
		rmot = L(x,y,t)-L(x,y,t-1) + (a(1)*P(x,y,t-1,L));
	else
		rmot = L(x,y,t)-L(x,y,t-1) + ((a(1)*P(x,y,t-1,L)) + (a(2)*P(x,y,t-2,L)));
	end
end
function decay = a(i)
	decay = 1/(1+exp(i));
end
%% lamina layer functions
function vdog = Pl(x,y,t,Ps,u,v,sig)
	vdog=Ps(x-u,y-v,t)*G(u,v,sig);
end
function kernel = G(u,v,sig)
	kernel = (1/(2*pi*(sig^2))) * exp(-(u^2+v^2)/(2*sig^2));
end