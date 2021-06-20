function [loc, pot] =FCM(No_C , input, ex_w )

%ex_w=2;
%c=-2/(ex_w-1);
c=2/(ex_w-1);
No_Itreation = 300;


loc=[];
pot=[];
[use1 use2]=size(input);

% 0
old_U=zeros(No_C, use1);

%[�ܰ� 1] �ʱ� �Ҽ���� ����
for i = 1 : No_C
    old_U(i , i ) = 1 ;
    if( i == No_C )
        old_U( No_C , No_C : use1 ) = 1 ;
    end
end

%[�ܰ� 2] �� Ŭ�����Ϳ� ���� �߽� ���͸� ����Ѵ�.
iter =1 ;
com=0.01;  
while ( iter<No_Itreation)
    V = zeros( No_C , use2 ) ;
    extra_V = old_U.^ex_w * input  ;
    
    
    for j=1 : No_C
        for k=1 : use2
            V( j , k  )= extra_V( j ,k  ) / sum( old_U( j , : ).^ex_w ) ;
            %V( j , k  )= extra_V( j ,k  ) / sum( old_U( j , : ).^2 ) ;
        end
    end
    
    %[�ܰ�3] ������ Ŭ������ �߽ɰ� �����Ϳ��� �Ÿ��� ����Ͽ�
    %���ο� �Ҽ���� U(r)�����Ѵ�.

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
    %[�ܰ� 4] U(0) �� U(1)�� ���� �������� ������ �ٽ� ���ο� �Ҽ������ ������
    %�ܰ� 2 �� ����.
    error = old_U - new_U;
    del=max(max(error));
    old_U=new_U;
    if(com>=del)
        break
    end
    iter=iter+1;
end
%[�ܰ� 5] ������ �����ϸ� ����
loc=[loc old_U'];
pot=[pot; V];
return;

