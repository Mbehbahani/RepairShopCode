function best=bestcpoint(FMIP)

maxobj1=max(FMIP(1,:));
maxobj2=max(FMIP(2,:));
for i=1:size(FMIP,2)
    c1=(maxobj1-FMIP(1,i))/maxobj1;
    c2=(maxobj2-FMIP(2,i))/maxobj2;
    a=min(c1,c2);
    compoint(i)=a;
    
end
[~,point]=max(compoint);

best=[FMIP(1,point),FMIP(2,point)];

end