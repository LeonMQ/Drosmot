%% cleaning
clear
clc
close all
%% input
Ls = zeros(32,64);
for x = 1:32
    for y = 1:64
        if mod(x,2)==0 && mod(y,2) ~= 0
            Ls(x,y)=1;
        elseif mod(x,2)~=0 && mod(y,2) == 0
            Ls(x,y)=1;
        end
    end
end
L=zeros(32,64,64);
for t=1:64
    L(:,:,t)=Ls;
end

hight = 16;
width = 7;
for t = 1:size(L,3)
    for x = hight/2:3*hight/2
        for y = t:t+width
            L(x,y,t)=1;
        end
    end
end
L=L(:,1:64,:);

%% Lamina layer
DOG1=fspecial('gaussian',[2 2],2);
DOG2=fspecial('gaussian',[4 4],4);
gauss_ON=imfilter(L,DOG1);
gauss_OFF=imfilter(L,DOG1);

ONs =    max(0, gauss_ON );

ONs_prev =cat(3, ONs, zeros(size(ONs,1), size(ONs,2)));
ONs      =cat(3, zeros(size(ONs,1), size(ONs,2)), ONs);

ONs_grad =ONs - ONs_prev;

ONs_hat =zeros(size(ONs)) ;

for x = 1:size(ONs,1)
    for y = 1:size(ONs,2)
        for t = 1:size(ONs,3)
            if ONs_grad(x,y,t) >= 0
                ONs_hat(x,y,t)  = ONs(x,y,t) -LPF(ONs(x,y,t), ONs_prev(x,y,t), 3/(1+3));
            else
                ONs_hat(x,y,t)  =ONs(x,y,t)-LPF(ONs(x,y,t), ONs_prev(x,y,t), 3/(10+3));
            end
        end
    end
end

ONs = ONs(:,:,2:end);
ONs_hat = ONs_hat(:,:,2:end);

ONs_hat =max(ONs_hat ,0);
MON = ONs- ONs_hat;

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
%% Lobula plate
LPr=zeros(1,size(L,3));
LPl=zeros(1,size(L,3));
LPd=zeros(1,size(L,3));
LPu=zeros(1,size(L,3));
for t = 1:size(T4r,3)
    for y = 1:size(T4r,2)
        for x = 1:size(T4r,1)
         LPr(t)=LPr(t)+T4r(x,y,t);
         LPl(t)=LPl(t)+T4l(x,y,t);
         LPd(t)=LPd(t)+T4d(x,y,t);
         LPu(t)=LPu(t)+T4u(x,y,t);
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
%% sigmoid
HS = ((1+exp(-abs(HS)*(32*64*0.01).^(-1))).^(-1)-0.5);
VS = ((1+exp(-abs(VS)*(32*64*0.01).^(-1))).^(-1)-0.5);
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
plot(1:64,HS,1:64,VS,LineWidth=2);
%axis([0 102 -0.5 0.5]);
legend('Vertical response','Horizontal response');
xlabel('Frames')
ylabel('Model Response')
xticks(0:6:102);
%%
% for i=1:64
%     imagesc(L(:,:,i));
%     pause(0.01);
% end
%% Low pass filter
function LPFil = LPF(c,p,d)
    LPFil=d*c+(1-d)*p;
end
