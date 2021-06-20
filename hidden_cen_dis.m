function [center_point , dis_constant]= hidden_cen_dis(setup, selected_input)
[No_data b] = size(selected_input);    clear b;
%---------------------center-point part-------------------------%
Input_boundary=zeros(1, length(setup.No_input));
for i=1 : length(setup.No_input)
    Input_boundary(i)=abs(max(selected_input(:,i))-min(selected_input(:,i)));
end
center_point=zeros(setup.No_hidden ,length(setup.No_input));

for j=1 : length(setup.No_input)
    temp=Input_boundary(j)/(setup.No_hidden+1);
    for i=1 : setup.No_hidden
        center_point(i,j)= min(selected_input(:,j))+temp;
        temp=temp+Input_boundary(j)/(setup.No_hidden+1);
    end
end
%-------------------distribution constant part---------------------%
dis_constant=zeros(setup.No_hidden ,length(setup.No_input));

for j=1 : length(setup.No_input)
    for i=1 : setup.No_hidden
        width=(selected_input(:,j)-center_point(i,j)*ones(No_data,1));
        dis_constant(i,j)=sqrt(sum(width.*width)/No_data);
    end
end