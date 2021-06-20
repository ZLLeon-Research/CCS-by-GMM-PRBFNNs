function [x y x_te y_te]=static_data(data_type, repeat)

if(data_type==1)
    file_tr = strcat('cement_train_3240_', strcat(int2str(repeat-1),'.txt'));
    file_te = strcat('cement_test_360_', strcat(int2str(repeat-1),'.txt'));
    
    data_tr = load(file_tr);
    data_te = load(file_te);
    x = data_tr(:,1:6);
    y = data_tr(:,57);
    
    x_te = data_te(:,1:6);
    y_te = data_te(:,57);
elseif(data_type==2)
    file_tr = strcat('cement_train_3240_', strcat(int2str(repeat-1),'.txt'));
    file_te = strcat('cement_test_360_', strcat(int2str(repeat-1),'.txt'));
        
    data_te = load(file_te);
    data_tr = load(file_tr);
    x = data_tr(:,7:56);
    y = data_tr(:,57);
    
    x_te = data_te(:,7:56);
    y_te = data_te(:,57);
elseif(data_type==3)
    file_tr = strcat('cement_train_3240_', strcat(int2str(repeat-1),'.txt'));
    file_te = strcat('cement_test_360_', strcat(int2str(repeat-1),'.txt'));
    
    data_tr = load(file_tr);
    data_te = load(file_te);
    x = data_tr(:,1:56);
    y = data_tr(:,57);
    
    x_te = data_te(:,1:56);
    y_te = data_te(:,57);
end
