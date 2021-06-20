
close all;

%%train
model_trainRever = mapRever(Tmodel_tr,ymin,ymax);

y_trainRever =  mapRever(y,ymin,ymax);

TargetOutpt =y_trainRever;
ModelOutput = model_trainRever;

figure();
plot(TargetOutpt, ModelOutput,'b.', 'MarkerSize',12 );

axis([0 ymax 0 ymax]);
axis square;
hold on;
plot([0,ymax],[0,ymax],'k','linewidth',1.5);










%%test
model_teRever = mapRever(Tmodel_te,ymin,ymax);
y_teRever =  mapRever(y_te,ymin,ymax);

TargetOutpt =y_teRever;
ModelOutput = model_teRever;

figure();
plot(TargetOutpt, ModelOutput,'b.', 'MarkerSize',12 );

axis([0 ymax 0 ymax]);
axis square;
hold on;
plot([0,ymax],[0,ymax],'k','linewidth',1.5);



figure();
plot(TargetOutpt, ModelOutput,'k.', 'MarkerSize',12 );

axis([0 ymax 0 ymax]);
axis square;
hold on;
plot([0,ymax],[0,ymax],'k','linewidth',2);

x1=0:0.5:ymax+0.5;
x2=0:0.5:ymax+0.5;
[X1, X2]=meshgrid(x1, x2);
X=[X1(:) X2(:)];

clear tourValue;
for i = 1 : size(X,1)
    tourValue(i,1) = abs(X(i,1)-X(i,2));
end
tourValue=reshape(tourValue, length(x2), length(x1));
contour(x1, x2, tourValue,[0:1:4],'LineWidth',0.5);

hold on 

r=0:0.5:4;

[C,h]=contour(x1, x2, tourValue,[0:1:2],'LineWidth',1.5)
set(h,'ShowText','on','LevelList',[1 2 3]);

%contourf(x1, x2, tourValue,20)
hold on

xlabel('\fontname{Times New Roman}Target Outpt','FontSize',12);
     ylabel('\fontname{Times New Roman}Model Output','FontSize',12);
     axis square;

biasTest = abs(TargetOutpt - ModelOutput);
for i = 1 : 7
    if i~=7
        [ddd, ~] =  find(biasTest>0.5*(i-1) & biasTest<=0.5*i);
    else
        [ddd, ~] =  find(biasTest>0.5*(i-1));
    end
    num(1,i) = size(ddd,1);
    if i==1
        CumPro(1,i) = num(1,i);
    else
        CumPro(1,i) = CumPro(1,i-1) + num(1,i);
    end
end