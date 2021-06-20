function [XTR XTE YTR YTE] = Divdata(setup, X, Y)

[row colum] = size(Y);
TR=setup.TR_Rate/100;
TE=1-TR;

n=1;
l=1;
k=row;
  NofTE=round(row*TE);
    for j=1:row
        IND(j)=j;    
    end
    ind=[];
    
    for j=1:NofTE
        m = ceil(k.*rand);     %TR과 TE를 랜덤하게 뽑기위한 인덱스 생성
        ind(j)=IND(m);
        IND(m)=[];      
        k=k-1;
    end

    for j=1:row-NofTE
        XTR(n,:) = X(IND(j),:);
        YTR(n,:) = Y(IND(j),:);
        n=n+1;
    end

    for j=1 : length(ind)
        XTE(l,:) = X(ind(j),:);
        YTE(l,:) = Y(ind(j),:);
        l=l+1;
    end

return


