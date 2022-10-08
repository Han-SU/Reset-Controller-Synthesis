clear
clc


sdpvar x y;


  f=[-2*y,x+0.5*(x^2-0.21)*y;-2*y,0.8*x+5*(x^2-0.21)*y];%the continuous differencial equation of each mode
  TR=[10*(x)^2+10*(y-0.3)^2-1;15*(x)^2+10*(y)^2-1];%the target set of each mode
  X=[x^2+y^2-1;x^2+y^2-1];%the safety set of each mode
  F=[0,1;1,0];%adjacency matrix of the directed graphic 

t1=clock;
Mode_Num=length(F);
Dom=sdpvar(Mode_Num,Mode_Num);
R=sdpvar(Mode_Num,Mode_Num,Mode_Num);
Init=sdpvar(Mode_Num,Mode_Num);
for i=1:Mode_Num
    for j=1:Mode_Num
       if(F(i,j)==1)
          [d,Dom(i,j)]=OscillatorFun([x,y],f(i,:)',TR(i,:),X(i,:),10); 
       end
    end
    for j=1:Mode_Num
        if(F(j,i)==1)
           R(j,i,:)=Dom(i,:);
        end
    end
    Init(i,:)=Dom(i,:);
end
t2=clock;
etime(t2,t1)
