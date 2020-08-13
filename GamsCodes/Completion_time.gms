*Gams code for the problem size: 4×24 (for the second Objective: minimize completion time)
*Article's code:A Multi-Objective Mixed Integer Programming for Automobile Repair Shop Scheduling;
* A Real Case Study
* M. Behbahani et al., 2020

sets
r /1*4/
c /1*6/
j /1*4/
alias(j,jj)
alias(c,cc);

parameter T(r);
$ call gdxxrw  schedule.xlsx par T rng=Sheet1!t38:u41 rdim=1 cdim=0
$ gdxin schedule.gdx
$ load T
$gdxin

parameter I(r);
$ call gdxxrw  schedule.xlsx par I rng=Sheet1!q38:r41 rdim=1 cdim=0
$ gdxin schedule.gdx
$ load I
$gdxin

parameter e(c,j,r);
$ call gdxxrw  schedule.xlsx par e rng=Sheet1!i37:n61 rdim=2 cdim=1
$ gdxin schedule.gdx
$ load e
$gdxin

parameter d(c,j);
$ call gdxxrw  schedule.xlsx par d rng=Sheet1!i64:m70 rdim=1 cdim=1
$ gdxin schedule.gdx
$ load d
$gdxin

parameter ST(r);
$ call gdxxrw  schedule.xlsx par ST rng=Sheet1!x38:y41 rdim=1 cdim=0
$ gdxin schedule.gdx
$ load ST
$gdxin

scalar M /2000/;

variable z;
positive variable Ov(r), Id(r);
positive variable Ct(c);
positive variable f(c,j);
binary variable a(c,j,r),x(cc,jj,c,j,r),Fx(c,j,r),v(c,jj,j),Fv(c,j);

equations
obj
co1
co2
co3
co4
co5
co6
co7
co8
co9
co10
co11
co12
co13
co14
co15
;

*obj .. z=e=sum(r,T(r)*Ov(r)+ I(r)*Id(r));

obj .. z=e=sum(c,Ct(c));

co1(c,j,r) .. a(c,j,r)=l=e(c,j,r);

co2(c,j,r) .. a(c,j,r)=e=Fx(c,j,r)+sum(cc$(ord(cc) <> ord(c)),sum(jj,x(cc,jj,c,j,r)));

co3(c,j) .. sum(r,a(c,j,r))=e=Fv(c,j)+sum(jj$(ord(jj) <> ord(j)),v(c,jj,j));

co4(r,c,j,cc,jj)$(ord(cc) <> ord(c)) .. f(c,j)=g=d(c,j)+f(cc,jj)+(x(cc,jj,c,j,r)-1)*M;

co5(c,j,r) .. f(c,j)=g=d(c,j)+(Fx(c,j,r)-1)*M;

co6(c,j,jj)$(ord(jj) <> ord(j)) .. f(c,j)=g=d(c,j)+ f(c,jj)+(v(c,jj,j)-1)*M;

co7(c,j,r) .. Ov(r)=g=f(c,j)+(a(c,j,r)-1)*M-ST(r);

co8(r) .. Id(r)=g=ST(r)+Ov(r)-sum(c,sum(j,a(c,j,r)*d(c,j)));

co9(c,j) .. sum(r,a(c,j,r))=e=1;

co10(r) .. sum(c,sum(j,Fx(c,j,r)))=e=1;

co11(c) .. sum(j,Fv(c,j))=e=1;

co12(r,cc,jj) .. sum(c$(ord(c)<>ord(cc)),sum(j,x(cc,jj,c,j,r)))=l=a(cc,jj,r);

co13(c,jj) .. sum(j$(ord(j)<>ord(jj)),v(c,jj,j))=l=1;

co14(c,j,jj) .. Ct(c)=g=f(c,j)-f(c,jj)+d(c,jj)+(Fv(c,jj)-1)*M ;

co15(r) .. Ov(r)=l=180 ;

model repair /all/;
option optca=0,optcr=0,reslim=3600, mip=cplex;
solve repair using mip min z;
display z.l,f.l,a.l,x.l,Fx.l,v.l,Fv.l,Ct.l;
display e;







