% movie water
% 相关法识别目标

clc;%清除窗口显示内容
clear;%清除变量
close all;%清除所有figure窗口
N=128;
% rand('state',6);%2——确定随机数状态（使每次运行结果相同）
A=round(rand(N));%四舍五入法取整
SE=strel('disk',4);%创建一个由0/1构成的平面圆，半径为4

A=ones(N);%产生一个N阶全1方阵
An=imnoise(A,'salt & pepper',0.05);%添加噪声（原图像，噪声类型，参数）
A=imerode(An,SE);%图像腐蚀函数
Ar=A.*rand(N);%矩阵中每个数字乘上随机数

subplot(231);%构建两行三列的画布，下面的图像放在1号位
imshow(An,[]); %显示灰度图像
xlabel('An: Noise');%为图像添加标签

subplot(232);
imshow(A,[]); 
xlabel('A: Erode');

subplot(233);
imshow(A,[]); 
xlabel('Ar: Erode');

subplot(234);
imshow(Ar,[]); 
xlabel('Ar.*rand');

subplot(235);
ih = imshow(Ar,[]); %产生的图像保存到ih，后续对ih的修改会影响显示图像
xlabel('Patterns');
th = title('t=0');%显示在图像上方的标题

[x,y]=meshgrid(1:N);%生成采样点的坐标
vx=0.01;vy=0.005; % 速度
P = exp(1i*[vx*x+vy*y]);%计算e的次方,这里指数部分是虚数
%由于x，y均为矩阵，所得P也为矩阵

Puv = ifftshift(P);%矩阵的每一行向左平移(n - 1)/2个位置，是fftshift的逆过程

R=N/2;%图像半径
As=Ar;
As(abs([x-N/2-0.5]+1i*[y-N/2-0.5]) > R) = 0;%将圆形范围以外区域涂黑

set(ih,'CData',As);%设置图像ih的名字和值

for k=1:80
%     vx=0.04*[rand-0.5];
%     vy=0.02*[rand-0.5]; % 速度【随机运动】
%     P=exp(1i*[vx*x+vy*y]);% 相位【随机运动】
%     Puv=ifftshift(P);
    At=ifft2(fft2(Ar).*Puv);%快速傅里叶变换
    Ar=abs(At);
    As=Ar;
    As(abs([x-N/2-0.5]+1i*[y-N/2-0.5])>R)=0;
    As(N/2:N/2+3,k+3:k+6)=0.5; % 运动目标
    set(ih,'CData',As);
    set(th,'String',['t = ',num2str(k)]);
    
    if k == 1;
        imwrite(uint8(As*255),'test2.gif','gif', 'Loopcount',inf);
    else
        imwrite(uint8(As*255),'test2.gif','gif','WriteMode','append',...
            'DelayTime',0.2);
    end
    pause(0.2);
    if k==1;
        I1=As;
    end
    if k>1.2;
        I2=As;
        C1=fft2(I1);
        C2=fft2(I2);
        Ic=ifft2(abs(C1).*exp(1i*angle(C2)));
        Ic=abs(Ic);
        DI=abs(Ic-I2);
        DI(abs([x-N/2-0.5]+1i*[y-N/2-0.5])>R-N/40)=0; % 切去外边
%         figure; 
%         subplot(221); imshow(Ic,[]);
%         subplot(222); mesh(DI);
        [m0,n0]=find(DI==max(max(DI)));
        rd=3*exp(1i*linspace(0,pi*2,100));
        subplot(236);
        imshow(DI,[]); hold on;
        plot(n0+1i*m0+rd,'r');
        I1=I2;
    end    
    
end
%%% 以下为相关运算