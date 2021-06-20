% polynomial-based radial basis function neural networks with Gaussian mixture model (GMM-PRBFNNs)
clc;
clear all;
warning off;
rand('seed',0);

setup=struct('No_hidden',   5, 'nomal_hidden' ,  'on' ,  ...
    'data_rate', [9 1] , 'data_type' , 3  ,  'No_input' , [1:56], ...
    'weighted_type',2 , 'error_type' , 3, 'coeff_type', 2, 'gmmInitial_type',3);

%data_type => 1: GLH features; 2 : GLCM features;  3 : GLH-GLCM features (Other data can be loaded here)
% weighted_type => 1 : constant,     2 : Linear    3 : Quadratic  4 : Modified Quadratic
% error_type    => 1 : MSE           2 : RMSE      3:MAE
% coeff_type    => 1 : WLSE          2 : LSE
% 'gmmInitial_type'= > 1 £º no optimazition  2£º Initial value of GMM
% optimized by PSO  3£º Initial value of GMM optimized by FCM

% FCM,GMM
IG='GMM';

setup.kfold = 10;
setup.Rearrange = 'use';   %  use or unuse
setup.TR_Rate= 90;

n_fold=10;
weighted=[];

minmax = load('MinMax.txt');
ymin = minmax(1,57);
ymax = minmax(2,57);

for dataType = 3:3
    setup.data_type = dataType;
    
    if setup.data_type ==1
        setup.No_input = [1:6];
    elseif setup.data_type ==2
        setup.No_input = [1:50];
    elseif setup.data_type ==3
        setup.No_input = [1:56];
    end
    
    ex_w = 2.0;
    NoHidden = [8];
    SizeNoHidden = size(NoHidden,2);
    
    for ssNoHidden = 1:1:SizeNoHidden
        setup.No_hidden = NoHidden(1,ssNoHidden);
        for repeat=1 : setup.kfold
            fprintf('%d fold cross validation\n', repeat);
            %%training set and test set of cross validation
            cd datafiles
            [x y x_te  y_te]=static_data(setup.data_type,repeat);
            cd ..
            
            selected_input = [];   selected_input_te =[];
            for i= 1 : length(setup.No_input)
                selected_input=[selected_input x( : , setup.No_input(i))];
                selected_input_te=[selected_input_te x_te( : , setup.No_input(i))];
            end
            [ No_data un ]=size(selected_input);
            if strcmp(IG, 'FCM')
                [fitness , V] = FCM(setup.No_hidden , selected_input, ex_w);
                fitness_te = FCM_te(setup.No_hidden , selected_input_te, V, ex_w);
            elseif strcmp(IG, 'GMM')
                if setup.gmmInitial_type ==1
                    [varargout,Gmodel]= gmm(selected_input, setup.No_hidden);
                elseif setup.gmmInitial_type ==2
                    %Initial value of GMM optimized by PSO
                    [BestSol] = PSO(selected_input,setup.No_hidden);
                    varargout = BestSol.Sol.varargout;
                    Gmodel = BestSol.Sol.model;
                elseif setup.gmmInitial_type ==3
                    %Initial value of GMM optimized by FCM
                    [fitness , V] = FCM(setup.No_hidden , selected_input, ex_w);
                    [varargout,Gmodel,costF] = gmmC(selected_input, setup.No_hidden ,V);
                end
                fitness = gmm_te(selected_input,Gmodel);
                fitness_te = gmm_te(selected_input_te, Gmodel);
            end
            
            %% update weight
            if(setup.coeff_type==1)
                para_x=LSE_input_parameter(setup, selected_input); %para_x  1£¬x1, x2£¬x3,x4, x1x2,x1x3,x1x4,x2x3,x2x4,x3x4, x1x1,x2x2,x3x3,x4x4
                for iii=1 : setup.No_hidden
                    W=diag( fitness(:,iii));
                    xx=para_x' * W * para_x;
                    yy=para_x'* W * y;
                    weight=regress(yy,xx);
                    weighted(iii,:)=weight';
                end
                
            elseif(setup.coeff_type==2)
                w=[];
                para_x=LSE_input_parameter(setup, selected_input);
                [p q] = size(para_x);
                for i=1 : setup.No_hidden
                    for k=1 : q
                        w=[w  para_x(:,k).* fitness(:,i)];
                    end
                end
                xx=w'* w;
                yy=w'* y;
                weight=regress(yy,xx);
                b=length(weight)/setup.No_hidden; bbb=1;
                for i=1 : setup.No_hidden
                    weighted(i,1:b)=weight(bbb: b*i);
                    bbb=bbb+b;
                end
            end
            
            %% Traning & Testing evulation per iteration
            if strcmp(IG,'FCM')
                [Tmodel_tr Tmodel_out_tr ] = Festimatee(setup, selected_input , fitness, weighted);  %Tmodel_tr:   the output of the NN corresponding to each data£» Tmodel_out_tr:   the output of each hidden node corresponding to each data multiplied by the subsequent fuzzy rules
                [Tmodel_te Tmodel_out_te ] = Festimatee(setup, selected_input_te , fitness_te ,weighted);
            elseif strcmp(IG,'GMM')
                [Tmodel_tr Tmodel_out_tr ] = Festimatee(setup, selected_input , fitness, weighted);  %Tmodel_tr:   the output of the NN corresponding to each data£» Tmodel_out_tr:   the output of each hidden node corresponding to each data multiplied by the subsequent fuzzy rules
                [Tmodel_te Tmodel_out_te ] = Festimatee(setup, selected_input_te , fitness_te ,weighted);
            end
            
            if strcmp(setup.Rearrange, 'use')
                [ PI , EPI, PI_rm , EPI_rm] = index2(setup , Tmodel_tr , Tmodel_te, y , y_te, ymin, ymax);
            else
                [ PI , EPI ] = index(setup , Tmodel_tr , Tmodel_te, y , y_te);
            end
            
            fprintf(' PI  : %.10f\t\t' , PI);
            fprintf(' EPI  : %.10f\t\t' , EPI);
            fprintf('\n');
            
            To_PI(repeat)=PI;  To_EPI(repeat)=EPI;  To_PI_rm(repeat)=PI_rm;  To_EPI_rm(repeat)=EPI_rm;
        end
        fprintf(' PI : %f    %f \n',mean(To_PI), std(To_PI) );
        fprintf(' EPI : %f    %f \n', mean(To_EPI), std(To_EPI));
        
        if setup.data_type ==1
            Result_His(1,ssNoHidden) = mean(To_PI);
            Result_His(2,ssNoHidden) = std(To_PI);
            Result_His(3,ssNoHidden) = mean(To_EPI);
            Result_His(4,ssNoHidden) = std(To_EPI);
            
            Result_His_rm(1,ssNoHidden) = mean(To_PI_rm);
            Result_His_rm(2,ssNoHidden) = std(To_PI_rm);
            Result_His_rm(3,ssNoHidden) = mean(To_EPI_rm);
            Result_His_rm(4,ssNoHidden) = std(To_EPI_rm);
        elseif setup.data_type ==2
            Result_GLCM(1,ssNoHidden) = mean(To_PI);
            Result_GLCM(2,ssNoHidden) = std(To_PI);
            Result_GLCM(3,ssNoHidden) = mean(To_EPI);
            Result_GLCM(4,ssNoHidden) = std(To_EPI);
            
            Result_GLCM_rm(1,ssNoHidden) = mean(To_PI_rm);
            Result_GLCM_rm(2,ssNoHidden) = std(To_PI_rm);
            Result_GLCM_rm(3,ssNoHidden) = mean(To_EPI_rm);
            Result_GLCM_rm(4,ssNoHidden) = std(To_EPI_rm);
        elseif setup.data_type ==3
            Result_HG(1,ssNoHidden) = mean(To_PI);
            Result_HG(2,ssNoHidden) = std(To_PI);
            Result_HG(3,ssNoHidden) = mean(To_EPI);
            Result_HG(4,ssNoHidden) = std(To_EPI);
            
            Result_HG_rm(1,ssNoHidden) = mean(To_PI_rm);
            Result_HG_rm(2,ssNoHidden) = std(To_PI_rm);
            Result_HG_rm(3,ssNoHidden) = mean(To_EPI_rm);
            Result_HG_rm(4,ssNoHidden) = std(To_EPI_rm);
        end
        clear weighted;
    end
end


filename=sprintf('results\\hidden_type%d.mat',setup.weighted_type);
save(filename);



