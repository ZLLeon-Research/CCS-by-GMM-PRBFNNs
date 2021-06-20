function [loc]=FCM_te(No_C, input  , V_tr, ex_w  )

%c=-2/(ex_w-1);
c=2/(ex_w-1);
[use1 use2]=size(input);
V = V_tr;

%[단계3] 각각의 클러스터 중심과 데이터와의 거리를 계산하여
%새로운 소속행렬 U(r)생성한다.
D = zeros( use1 , No_C ) ;

for ii=1 : No_C
    for jj=1 : use1
        same=0;
        for kk=1 : use2
         
                temp= (input(jj,kk) - V(ii,kk))^2;
            
            same=same+temp;
        end
        
            D(jj,ii)=sqrt(same);
       
    end
end
new_U = zeros( No_C , use1 );
for iii=1 : No_C
    for jjj=1 : use1
        same=0;
        for kkk=1 : No_C
            
            
                    if( D(jjj,iii)==0 && D(jjj,kkk)==0)
                        temp = 1;
                    elseif(D(jjj,iii)~=0 && D(jjj,kkk)==0)
                        temp = 1;
                    elseif(D(jjj,iii)==0 && D(jjj,kkk)~=0)
                        temp = 0;
                    else
                        temp=( D(jjj,iii) / D(jjj,kkk) )^c;
                    end
            
            same=temp+same;
        end
        
            new_U(iii,jjj)=1/same;
    end
end

loc= new_U';

return;

