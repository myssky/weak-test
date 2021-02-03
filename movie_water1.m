% movie water
% ��ط�ʶ��Ŀ��

clc;%���������ʾ����
clear;%�������
close all;%�������figure����
N=128;
% rand('state',6);%2����ȷ�������״̬��ʹÿ�����н����ͬ��
A=round(rand(N));%�������뷨ȡ��
SE=strel('disk',4);%����һ����0/1���ɵ�ƽ��Բ���뾶Ϊ4

A=ones(N);%����һ��N��ȫ1����
An=imnoise(A,'salt & pepper',0.05);%���������ԭͼ���������ͣ�������
A=imerode(An,SE);%ͼ��ʴ����
Ar=A.*rand(N);%������ÿ�����ֳ��������

subplot(231);%�����������еĻ����������ͼ�����1��λ
imshow(An,[]); %��ʾ�Ҷ�ͼ��
xlabel('An: Noise');%Ϊͼ����ӱ�ǩ

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
ih = imshow(Ar,[]); %������ͼ�񱣴浽ih��������ih���޸Ļ�Ӱ����ʾͼ��
xlabel('Patterns');
th = title('t=0');%��ʾ��ͼ���Ϸ��ı���

[x,y]=meshgrid(1:N);%���ɲ����������
vx=0.01;vy=0.005; % �ٶ�
P = exp(1i*[vx*x+vy*y]);%����e�Ĵη�,����ָ������������
%����x��y��Ϊ��������PҲΪ����

Puv = ifftshift(P);%�����ÿһ������ƽ��(n - 1)/2��λ�ã���fftshift�������

R=N/2;%ͼ��뾶
As=Ar;
As(abs([x-N/2-0.5]+1i*[y-N/2-0.5]) > R) = 0;%��Բ�η�Χ��������Ϳ��

set(ih,'CData',As);%����ͼ��ih�����ֺ�ֵ

for k=1:80
%     vx=0.04*[rand-0.5];
%     vy=0.02*[rand-0.5]; % �ٶȡ�����˶���
%     P=exp(1i*[vx*x+vy*y]);% ��λ������˶���
%     Puv=ifftshift(P);
    At=ifft2(fft2(Ar).*Puv);%���ٸ���Ҷ�任
    Ar=abs(At);
    As=Ar;
    As(abs([x-N/2-0.5]+1i*[y-N/2-0.5])>R)=0;
    As(N/2:N/2+3,k+3:k+6)=0.5; % �˶�Ŀ��
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
        DI(abs([x-N/2-0.5]+1i*[y-N/2-0.5])>R-N/40)=0; % ��ȥ���
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
%%% ����Ϊ�������