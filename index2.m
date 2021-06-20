function [PI EPI PI_rm EPI_rm]=index2(setup , model_tr , model_te, y , y_te, ymin,ymax)

[a b]=size(y);
[c d]=size(y_te);


%Inverse normalization of network output
model_teRever = mapRever(model_te,ymin,ymax);
%Inverse normalization of test set
y_teRever =  mapRever(y_te,ymin,ymax);

%train error
model_trRever = mapRever(model_tr,ymin,ymax);

%Inverse normalization of train set
yRever =  mapRever(y,ymin,ymax);

err=(yRever-model_trRever).^2;
err_te=(y_teRever-model_teRever).^2;

PI_rm=sqrt((sum(err))/a); 
EPI_rm=sqrt((sum(err_te))/c);

if(setup.error_type==1)
    PI=(sum(err))/a;
    EPI=(sum(err_te))/c;
elseif(setup.error_type==2)
    PI=sqrt((sum(err))/a); 
    EPI=sqrt((sum(err_te))/c);
elseif(setup.error_type==3)
    PI=sum(abs(yRever-model_trRever))/a; 
    EPI=sum(abs(y_teRever-model_teRever))/c; 
end

return


