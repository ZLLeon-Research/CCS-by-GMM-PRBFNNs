
figure();
plot(Tmodel_te,':og')
hold on
plot(abs(y_te),'-*');
legend('Output','Target')
ylabel('CCS(Mpa)','fontsize',12)
xlabel('Test Sample','fontsize',12)





figure();
xx = NoHidden;
yy = exw;

for i = 1 : 5
    for j = 1 :17
        
        %mseR(i,j) = Result(2*i-1,2*j-1);
        mseR(i,j) = Result(2*i,2*j-1);
    end
end

%surf(xx,yy,mseR);
%mesh(xx,yy,mseR);
%surfc(xx,yy,mseR);

meshz(xx,yy,mseR);

%waterfall(xx,yy,mseR);

%plot3(xx,yy,mseR);

%axis([2 22 1.1 3 4.1 4.4]);
set(gca,'xtick',[5 10 15 22]);
set(gca,'ytick',[1.1 1.5 2.0 2.5 3]);
%set(gca,'ztick',[]);

xlabel('Hidden Number','FontSize',16)
ylabel('Fuzzification Factor','FontSize',16);
zlabel('Mean Absolute  Error','FontSize',16);






