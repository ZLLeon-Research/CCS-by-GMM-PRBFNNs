
clear Result_His Result_GLCM Result_HG Result_His_rm Result_GLCM_rm Result_HG_rm

cd results

load('Result_His.mat');
load('Result_GLCM.mat');
load('Result_HG.mat');
load('Result_His_rm.mat');
load('Result_GLCM_rm.mat');
load('Result_HG_rm.mat');

% 
%   save('Result_His','Result_His');
%   save('Result_GLCM','Result_GLCM');
%   save('Result_HG','Result_HG');
% 
%   save('Result_His_rm','Result_His_rm');
%   save('Result_GLCM_rm','Result_GLCM_rm');
%   save('Result_HG_rm','Result_HG_rm');
  

% q = load('Result_His.mat');
% Result_His = q.Result_His; 
% q2 = load('Result_GLCM.mat');
% Result_GLCM = q2.Result_GLCM;
% q3 = load('Result_HG.mat');
% Result_HG = q3.Result_HG;
% 
% save('PRBFNN1_Result_His','Result_His');
% save('PRBFNN1_Result_GLCM','Result_GLCM');
% save('PRBFNN1_Result_HG','Result_HG');

close all;


x = [4:1:11];
yhis1 = Result_His(1,:);
yglcm1 = Result_GLCM(1,:);
yHG1 = Result_HG(1,:);

figure();
plot(x,yhis1,'-o','Color',[0 0 1],'LineWidth',1.5, 'MarkerSize',5);
hold on;
plot(x,yglcm1,'-*','Color',[0 1 0],'LineWidth',1.5, 'MarkerSize',5);
hold on;
plot(x,yHG1,'-diamond','Color',[1 0 0],'LineWidth',1.5 ,'MarkerSize',5);

set(gca,'XLim',[9 11]);
set(gca,'YLim',[0 4]);
%set(gca,'XTick',[2,6,10,14,18,22,26,30,36]);
 xlabel('Number of Hidden Neurons');
 ylabel('Mean Absolute Error');
legend('GLH Features','GLCM Features','GLH-GLCM Features');
axis square;



yhis1 = Result_His(3,:);
yglcm1 = Result_GLCM(3,:);
yHG1 = Result_HG(3,:);

figure();
plot(x,yhis1,'-o','Color',[0 0 1],'LineWidth',1.5, 'MarkerSize',5);
hold on;
plot(x,yglcm1,'-*','Color',[0 1 0],'LineWidth',1.5, 'MarkerSize',5);
hold on;
plot(x,yHG1,'-diamond','Color',[1 0 0],'LineWidth',1.5 ,'MarkerSize',5);

%set(gca,'XLim',[2 36]);
set(gca,'YLim',[0 4]);
%set(gca,'XTick',[2,6,10,14,18,22,26,30,36]);
 xlabel('Number of Hidden Neurons');
 ylabel('Mean Absolute Error');
legend('GLH Features','GLCM Features','GLH-GLCM Features');
axis square;


