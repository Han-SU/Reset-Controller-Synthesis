
function [diagnostics,v]=reach_avoidnoobstacle(x1,degree,TR,X,f,obj,V,coe)

[w,coew]=polynomial(x1,degree);
V1=jacobian(V,x1')*f;
w1=jacobian(w,x1')*f;
degree1=degree+1;

[s0,coe0]=polynomial(x1,degree1);
[s1,coe1]=polynomial(x1,degree1);
[s2,coe2]=polynomial(x1,degree1);
[s3,coe3]=polynomial(x1,degree1);
[s4,coe4]=polynomial(x1,degree1);

% F=[sos(-V1+s1*X),sos(V-w1+s2*X),sos(V-s4*X),...,
%     coe>=-1000,coe<=1000,coew>=-1000,coew<=1000,...,
%      sos(s0),sos(s1),sos(s2),sos(s3)];
F=[sos(-V1+s1*X-s0*TR),sos(V-w1+s2*X-s3*TR),sos(V-s4*X),...,
    coe>=-1000,coe<=1000,coew>=-1000,coew<=1000,...,
     sos(s0),sos(s1),sos(s2),sos(s3)];
ops = sdpsettings('solver','mosek','sos.newton',1,'sos.congruence',1);
diagnostics = solvesdp(F,obj,ops,[coe;coew;coe0;coe1;coe2;coe3;coe4]);
v = monolist(x1,degree);

end