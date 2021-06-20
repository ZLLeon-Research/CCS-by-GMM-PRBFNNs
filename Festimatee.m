function [Tmodel model_out]=estimatee(setup, selected_input , fit, weighted)
 [No_data input_n]=size(selected_input);  clear input_n;


model_out=zeros(No_data, setup.No_hidden);


for ii=1 : No_data
    con_x=[];
    
    
    %   1
    %   1
    %   1
    %   1
    if(setup.weighted_type>=1)
        con_x=[con_x ones(setup.No_hidden,1)];
    end
    

    %   1   x1  x2   x3
    %   1   x1  x2   x3 
    %   1   x1  x2   x3 
    %   1   x1  x2   x3 
    if(setup.weighted_type>=2)
        for i=1 : setup.No_hidden
            for j=1 : length(setup.No_input)
                temp(i,j) = (selected_input(ii,j));
            end
        end
        con_x=[con_x temp];
    end
    
    % £¨x1x2,x1x3,x1x4,x2x3,x2x4,x3x4£©
 if(setup.weighted_type==3)
        for i=1 : length(setup.No_input)
            for j=i : length(setup.No_input)
                  con_x=[con_x temp(:,i).* temp(:,j)];
            end
        end
 end

%(x1x1,x2x2,x3x3,x4x4)
if(setup.weighted_type==4)
            con_x=[con_x temp.^2];
end
    
%    
%     %
%     %   1   x1  x2   x3   x1x2   x1x3   x2x3  
%     %   1   x1  x2   x3   x1x2   x1x3   x2x3
%     %   1   x1  x2   x3   x1x2   x1x3   x2x3
%     %   1   x1  x2   x3   x1x2   x1x3   x2x3
%     if(setup.weighted_type>=3)
%         
%         if(length(setup.No_input)<=2)
%             temp_re=temp(:,1) .* temp(:,2);
%             con_x=[con_x temp_re];
%         else
%             k=1;
%             for i=1 : length(setup.No_input)-1
%                 for j=i+1 : length(setup.No_input)
%                     temp_re(:,k)=temp(:,i) .* temp(:,j);
%                     k=k+1;
%                 end
%             end
%             
%         end
%         con_x=[con_x temp_re];
%     end
%     clear temp_re  temp;
%     %
%     %   1   x1  x2   x3   x1x2   x1x3   x2x3  x1x1  x2x2  x3x3
%     %   1   x1  x2   x3   x1x2   x1x3   x2x3  x1x1  x2x2  x3x3
%     %   1   x1  x2   x3   x1x2   x1x3   x2x3  x1x1  x2x2  x3x3
%     %   1   x1  x2   x3   x1x2   x1x3   x2x3  x1x1  x2x2  x3x3
%     if(setup.weighted_type==4)
%         for i=1 : setup.No_hidden
%             for j=1 : length(setup.No_input)
%                 temp(i,j) = (     selected_input(ii,j)   )^2;
%             end
%         end
%         con_x=[con_x temp];
%     end
%     
    
    
    %
    for j=1 : setup.No_hidden
            model_out(ii,j)=con_x(j,:) * weighted(j,:)' * fit(ii,j);
    end
    
    
    %
    Tmodel(ii,1)=sum(model_out(ii,:));
    
end


return
