function [PI EPI]=index(setup , model_tr , model_te, y , y_te)
[a b]=size(y);
[c d]=size(y_te);
err=(y-model_tr).^2;
err_te=(y_te-model_te).^2;

if(setup.error_type==1)
    PI=(sum(err))/a;
    EPI=(sum(err_te))/c;
elseif(setup.error_type==2)
    PI=sqrt((sum(err))/a); 
    EPI=sqrt((sum(err_te))/c);
elseif(setup.error_type==3)
    PI=sum(abs(y-model_tr))/a; 
    EPI=sum(abs(y_te-model_te))/c; 
end

return


