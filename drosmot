%% cleaning
clear
clc
close all
%% input layer
block_height= 9  ;
block_width = 25 ;
frame_time  = 33 ;
frames      = 100;
time = frame_time*frames;

L=zeros(frames+block_width,block_height,time);

corner = 1;

for t=1:time
    if rem(t,frame_time) == 0
        corner = corner+1;
    end
    L(corner:corner+block_width,1:block_height,t)=1;
end
L=flipud(L);
L=padarray(L,[5 5]);

L_prev=cat(3,L,zeros(size(L,1),size(L,2)));
L     =cat(3,zeros(size(L,1),size(L,2)),L);

%% retina layer
P=L-L_prev;

P=P(:,:,2:end);
a=1/(1+exp(1));

P_prev=cat(3,P,zeros(size(P,1),size(P,2)));
P     =cat(3,zeros(size(P,1),size(P,2)),P);
P_prev=P_prev*a;

P=P+P_prev;

P=P(:,:,2:end);
L=L(:,:,2:end);
%% Lamina layer
DOG1=fspecial('gaussian',[2 2],2);
DOG2=fspecial('gaussian',[4 4],4);
gauss_ON=imfilter(L,DOG1);
gauss_OFF=imfilter(L,DOG1);
% The above 2 lines should be P but that breaks it.
ONs =    max(0, gauss_ON );
%OFFs=abs(min(gauss_OFF,0));
OFFs=    -max(0, gauss_OFF);

ONs_prev =cat(3, ONs, zeros(size(ONs,1), size(ONs,2)));
ONs      =cat(3, zeros(size(ONs,1), size(ONs,2)), ONs);
OFFs_prev=cat(3,OFFs,zeros(size(OFFs,1),size(OFFs,2)));
OFFs     =cat(3,zeros(size(OFFs,1),size(OFFs,2)),OFFs);


ONs_grad =ONs - ONs_prev;
OFFs_grad=OFFs-OFFs_prev;

ONs_hat =zeros(size(ONs)) ;
OFFs_hat=zeros(size(OFFs));

for x = 1:size(ONs,1)
    for y = 1:size(ONs,2)
        for t = 1:size(ONs,3)
            if ONs_grad(x,y,t) >= 0
                ONs_hat(x,y,t)  = ONs(x,y,t) -LPF(ONs(x,y,t), ONs_prev(x,y,t), 33/(1+33));
            else
                ONs_hat(x,y,t)  =ONs(x,y,t)-LPF(ONs(x,y,t), ONs_prev(x,y,t), 33/(100+33));
            end
            if OFFs_grad(x,y,t) >= 0
                OFFs_hat(x,y,t)=OFFs(x,y,t)- LPF(OFFs(x,y,t),OFFs_prev(x,y,t), 33/(1+33));
            else
                OFFs_hat(x,y,t)=OFFs(x,y,t)-LPF(OFFs(x,y,t),OFFs_prev(x,y,t),33/(100+33));
            end
        end
    end
end
ONs = ONs(:,:,2:end);
OFFs=OFFs(:,:,2:end);
ONs_hat = ONs_hat(:,:,2:end);
OFFs_hat=OFFs_hat(:,:,2:end);


ONs_hat =max(ONs_hat ,0);
OFFs_hat=max(OFFs_hat,0);
MON = ONs- ONs_hat;
MOFF=OFFs-OFFs_hat;
%% Medulla and Lobula layer
tau=10;
alpha3=33/(33+tau);

% Medulla
MON_prev=cat(3,MON, zeros(size(MON,1),size(MON,2)));
MON     =cat(3,zeros(size(MON,1),size(MON,2)), MON);

MONhat =MON -LPF(MON, MON_prev, alpha3);

MON    =    MON(:,:,2:end);
MONhat = MONhat(:,:,2:end);

MON   =padarray(MON, [16 , 16]);
MONhat=padarray(MONhat,[16,16]);

T4r=zeros(size(MONhat));
T4l=zeros(size(MONhat));
T4d=zeros(size(MONhat));
T4u=zeros(size(MONhat));

for x = 17:size(MON,1)-16
    for y = 17:size(MON,2)-16
        for t = 2:size(MON,3)
            for i = 4:16
                T4r(x,y,t)=T4r(x,y,t) + (MONhat(x,y,t)*MON(x+i,y,t));
                T4l(x,y,t)=T4r(x,y,t) + (MONhat(x+i,y,t)*MON(x,y,t));
                T4d(x,y,t)=T4r(x,y,t) + (MONhat(x,y,t)*MON(x,y+i,t));
                T4u(x,y,t)=T4r(x,y,t) + (MONhat(x,y+i,t)*MON(x,y,t));
            end
        end
    end
end

MON   =MONhat(17:size(MON, 1) -16, 17:size(MON, 2) -16, :);
MONhat=MONhat(17:size(MONhat,1)-16,17:size(MONhat,2)-16,:);
T4r   = T4r(17:size(T4r, 1) - 16, 17:size(T4r, 2) - 16, :);
T4l   = T4l(17:size(T4l, 1) - 16, 17:size(T4l, 2) - 16, :);
T4d   = T4d(17:size(T4d, 1) - 16, 17:size(T4d, 2) - 16, :);
T4u   = T4u(17:size(T4u, 1) - 16, 17:size(T4u, 2) - 16, :);


% Lobula
MOFF_prev=cat(3,MOFF,zeros(size(MOFF,1),size(MOFF,2)));
MOFF     =cat(3,zeros(size(MOFF,1),size(MOFF,2)),MOFF);

MOFFhat=MOFF-LPF(MOFF,MOFF_prev,alpha3);

MOFF   =   MOFF(:,:,2:end);
MOFFhat=MOFFhat(:,:,2:end);

MOFF   =padarray(MOFF, [16 , 16]);
MOFFhat=padarray(MOFFhat,[16,16]);

T5r=zeros(size(MOFFhat));
T5l=zeros(size(MOFFhat));
T5d=zeros(size(MOFFhat));
T5u=zeros(size(MOFFhat));

for x = 17:size(MOFF,1)-16
    for y = 17:size(MOFF,2)-16
        for t = 2:size(MOFF,3)
            for i = 4:16
                T5r(x,y,t)=T5r(x,y,t)+(MOFFhat(x,y,t)*MOFF(x+i,y,t));
                T5l(x,y,t)=T5r(x,y,t)+(MOFFhat(x+i,y,t)*MOFF(x,y,t));
                T5d(x,y,t)=T5r(x,y,t)+(MOFFhat(x,y,t)*MOFF(x,y+i,t));
                T5u(x,y,t)=T5r(x,y,t)+(MOFFhat(x,y+i,t)*MOFF(x,y,t));
            end
        end
    end
end
MOFF   =MOFFhat(17:size(MOFF, 1) -16, 17:size(MOFF, 2) -16, :);
MOFFhat=MOFFhat(17:size(MOFFhat,1)-16,17:size(MOFFhat,2)-16,:);
T5r    =T5r(17:size(T5r , 1) - 16 , 17:size(T5r , 2) - 16 , :);
T5l    =T5l(17:size(T5l , 1) - 16 , 17:size(T5l , 2) - 16 , :);
T5d    =T5d(17:size(T5d , 1) - 16 , 17:size(T5d , 2) - 16 , :);
T5u    =T5u(17:size(T5u , 1) - 16 , 17:size(T5u , 2) - 16 , :);

%% Lobula plate
LPr=zeros(1,size(L,3));
LPl=zeros(1,size(L,3));
LPd=zeros(1,size(L,3));
LPu=zeros(1,size(L,3));
for t = 1:size(T4r,3)
    for y = 1:size(T4r,2)
        for x = 1:size(T4r,1)
         LPr(t)=LPr(t)+T4r(x,y,t)+T5r(x,y,t);
         LPl(t)=LPl(t)+T4l(x,y,t)+T5l(x,y,t);
         LPd(t)=LPd(t)+T4d(x,y,t)+T5d(x,y,t);
         LPu(t)=LPu(t)+T4u(x,y,t)+T5u(x,y,t);
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
%% plot data wrangling
sample=32:33:3300;
sample=[1 sample];
Horiz=zeros(size(sample));
Vert=zeros(size(sample));
for i = 1:100
    Horiz(i)=HS(sample(i));
    Vert(i)=VS(sample(i));
end
Horiz=[Horiz 0];
Vert =[Vert 0];
%% Plotting
figure
subplot(2,2,1);
imagesc(L(:,:,1));
axis off
title('First frame')
colormap gray
subplot(2,2,2);
imagesc(L(:,:,end));
title('Last Frame')
axis off
colormap gray
subplot(2,1,2);
axis on
plot(1:102,Horiz,1:102,Vert,LineWidth=2);
%axis([0 102 -0.5 0.5]);
legend('Vertical response','Horizontal response');
xlabel('Frames')
ylabel('Model Response')
xticks(0:6:102);
%% Low pass filter
function LPFil = LPF(c,p,d)
    LPFil=d*c+(1-d)*p;
end
