function [diagnostics,poly]=AircraftFun(x_arry,f,TR,X,degree,mode)
tic
[V,coe]= polynomial(x_arry,degree);

if(mode==2)
    obj=3.14159265359*coe(1)+0.785398163397*coe(4)+0.785398163397*coe(6)+0.392699081699*coe(11)+0.1308996939*coe(13)+0.392699081699*coe(15)+0.245436926062*coe(22)+0.0490873852123*coe(24)+0.0490873852123*coe(26)+0.245436926062*coe(28)+0.171805848243*coe(37)+0.0245436926062*coe(39)+0.0147262155637*coe(41)+0.0245436926062*coe(43)+0.171805848243*coe(45)+0.128854386182*coe(56)+0.0143171540203*coe(58)+0.00613592315154*coe(60)+0.00613592315154*coe(62)+0.0143171540203*coe(64)+0.128854386182*coe(66);
else
    obj=12.5663706144*coe(1)+18.8495559215*coe(4)+18.8495559215*coe(6)+48.6946861306*coe(11)+16.2315620435*coe(13)+48.6946861306*coe(15)+153.152641863*coe(22)+30.6305283725*coe(24)+30.6305283725*coe(26)+153.152641863*coe(28)+536.721469912*coe(37)+76.6744957017*coe(39)+46.004697421*coe(41)+76.6744957017*coe(43)+536.721469912*coe(45)+2013.22092971*coe(56)+223.691214413*coe(58)+95.8676633197*coe(60)+95.8676633197*coe(62)+223.691214413*coe(64)+2013.22092971*coe(66);
end
%========================compute reach avoid set====================================

[diagnostics,v]=reach_avoidnoobstacle(x_arry,degree,TR,X,f,obj,V,coe);
toc

if diagnostics.problem == 0
 disp('Solver thinks mode  is feasible')
elseif diagnostics.problem == 1
 disp('Solver thinks mode  is infeasible')
else
 disp('Something else happened for mode 1')
end

poly=v'*double(coe);
sdisplay(poly)