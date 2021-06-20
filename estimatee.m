function [Tmodel model_out]=estimatee(setup, selected_input , center_point , dis_constant , weighted)
[No_data input_n]=size(selected_input);  clear input_n;
Tmodel=zeros(No_data,1);

model_out=zeros(No_data, setup.No_hidden);
for ii=1 : No_data
    con_x=[];
    hidden_nodes=zeros(1, setup.No_hidden);
    nomalized_hidden_nodes=zeros(1, setup.No_hidden);
    for j=1 : setup.No_hidden
        temp=0;
        for k=1 :  length(setup.No_input)
            temp=temp + ( (selected_input(ii,k) - center_point(j,k) )^2) / (2*(dis_constant(j,k)^2));
        end
        hidden_nodes(j)=exp(-temp);
    end
    if strcmp( setup.nomal_hidden , 'on' )
        for j=1 : setup.No_hidden
            nomalized_hidden_nodes(j)=hidden_nodes(j)/sum(hidden_nodes(1,:));
        end
    end
    clear temp;
    if(setup.weighted_type>=1)
        con_x=[con_x ones(setup.No_hidden,1)];
    end
    
    if(setup.weighted_type>=2)
        for i=1 : setup.No_hidden
            for j=1 : length(setup.No_input)
                temp(i,j) = (selected_input(ii,j));
            end
        end
        con_x=[con_x temp];
    end
    
    if(setup.weighted_type>=3)
        
        if(length(setup.No_input)<=2)
            temp_re=temp(:,1) .* temp(:,2);
        else
            k=1;
            for i=1 : length(setup.No_input)-1
                for j=i+1 : length(setup.No_input)
                    temp_re(:,k)=temp(:,i) .* temp(:,j);
                    k=k+1;
                end
            end
            
        end
        con_x=[con_x temp_re];
    end
    clear temp_re  temp;
    if(setup.weighted_type==4)
        for i=1 : setup.No_hidden
            for j=1 : length(setup.No_input)
                temp(i,j) = (     selected_input(ii,j)   )^2;
            end
        end
        con_x=[con_x temp];
    end
    
    
    for j=1 : setup.No_hidden
            model_out(ii,j)=con_x(j,:) * weighted(j,:)' * nomalized_hidden_nodes(j);
    end
    Tmodel(ii,1)=sum(model_out(ii,:));   
end
return
