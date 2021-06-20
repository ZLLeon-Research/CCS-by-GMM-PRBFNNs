function  con=input_parameter(setup, selected_input , center_point , dis_constant)
con_x=[]; con=[];
if(setup.weighted_type>=1)
    con_x=[con_x ones(setup.No_hidden,1)];
end

if(setup.weighted_type>=2)
    for i=1 : setup.No_hidden
        for j=1 : length(setup.No_input)
            temp(i,j) = (selected_input(j) - center_point(i,j))/(dis_constant(i,j));
        end
    end
    con_x=[con_x temp];
end

if(setup.weighted_type>=3)
    
    if(length(setup.No_input)<=2)
        temp_re=temp(:,1) .* temp(:,2);
         con_x=[con_x temp_re];
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
            temp(i,j) = (     (selected_input(j) - center_point(i,j))/(dis_constant(i,j))  )^2;
        end
    end
    con_x=[con_x temp];
end
for i=1 :  setup.No_hidden
con=[con con_x(i,:);];
end
con=con';