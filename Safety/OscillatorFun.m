function [diagnostics,poly]=OscillatorFun(x_arry,f,TR,X,degree)

tic
[V,coe]= polynomial(x_arry,degree);
obj=3.14159265359*coe(1)+0.785398163397*coe(4)+0.785398163397*coe(6)+0.392699081699*coe(11)+0.1308996939*coe(13)+0.392699081699*coe(15)+0.245436926062*coe(22)+0.0490873852123*coe(24)+0.0490873852123*coe(26)+0.245436926062*coe(28)+0.171805848243*coe(37)+0.0245436926062*coe(39)+0.0147262155637*coe(41)+0.0245436926062*coe(43)+0.171805848243*coe(45)+0.128854386182*coe(56)+0.0143171540203*coe(58)+0.00613592315154*coe(60)+0.00613592315154*coe(62)+0.0143171540203*coe(64)+0.128854386182*coe(66);
[diagnostics,v]=reach_avoidnoobstacle(x_arry,degree,TR,X,f,obj,V,coe);
toc

if diagnostics.problem == 0
 disp('Solver thinks it is feasible')
elseif diagnostics.problem == 1
 disp('Solver thinks it is infeasible')
else
 disp('Something else happened')
end
sdisplay(v'*double(coe))
poly=v'*double(coe);