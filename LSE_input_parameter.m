function  con_x=LSE_input_parameter(setup, selected_input)
con_x=[];  [ data_num input_n  ] = size(selected_input);

%Constant term of polynomial
if(setup.weighted_type>=1)
    con_x=[con_x ones(data_num,1)];
end

%linear term of polynomial:  x
if(setup.weighted_type>=2)
   
    con_x=[con_x selected_input];
end


% x1x2 £¨x1x2,x1x3,x1x4,x2x3,x2x4,x3x4£©
 if(setup.weighted_type==3)
        for i=1 : length(setup.No_input)
            for j=i : length(setup.No_input)
                  con_x=[con_x selected_input(:,i).* selected_input(:,j)];
            end
        end
 end

% x*x  (x1x1,x2x2,x3x3,x4x4)
if(setup.weighted_type==4)
            con_x=[con_x selected_input.^2];
end



