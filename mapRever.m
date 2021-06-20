function [mapy]=mapRever(data,min,max)
d = max - min; 

mapy = d.*data+min;

end