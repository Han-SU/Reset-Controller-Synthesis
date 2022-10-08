clear
clc
yalmip('clear');

sdpvar x1 x2 x3 x4;
x=[x1,x2,x3,x4];

f=[x2,3*x1+2*x4+1/150,x4,-2*x2+1/150;x2,4.5*x1+3*x4+1/50,x4,-3*x2+1/50;x2,-3*x1-2*x4+1/150,x4,+2*x2+1/150]; 
TR=[0;0;(x1+1)^2+(x2-1)^2+x3^2+x4^2-1];
G=[(x1+1)^2+(x2+1)^2+x3^2+x4^2-1;(x1-1)^2+(x2-1)^2+x3^2+x4^2-1;0];
Initage=[1,1,1];
X=[x1^2+x2^2+x3^2+x4^2-1;x1^2+x2^2+x3^2+x4^2-1;x1^2+x2^2+x3^2+x4^2-1];
F=[0,1,0;0,0,1;1,0,0];

 t1=clock;
T={0};
count=0;
Mode_Num=length(F);
Dom=sdpvar(Mode_Num,Mode_Num);
Init=sdpvar(1,Mode_Num);
R=sdpvar(Mode_Num,Mode_Num);
assign(R,zeros(Mode_Num,Mode_Num));
assign(Init,zeros(1,Mode_Num));


for i=1:Mode_Num
    if(Initage(i)==1)
        if(value(TR(i))~=0)
            count=count+1;
            T{count}=i;
        end
        for j=1:Mode_Num
            if(F(i,j)==1)
                if(value(TR(j))~=0)
                    count=count+1;
                    T{count}=[i,j];
                end
                for k=1:Mode_Num
                    if (F(j,k)==1)
                        if(value(TR(k))~=0)
                            count=count+1;
                            T{count}=[i,j,k];
                        end
                    end
                end
            end
        end
    end
end
for i=1:length(T)
    Trace_Len=length(T{i});
    if(Trace_Len==1)
        [d,Dom(T{i},T{i})]=CWHFun(x,f(T{i},:)',TR(T{i},:),X(T{i},:),10);
        if (degree(Dom(T{i},T{i}))>0)
            Init(1,T{i})=Dom(T{i},T{i});
            break;
        end
    else
        [d,Dom(T{i}(Trace_Len-1),T{i}(Trace_Len))]=CWHFun(x,f(T{i}(Trace_Len),:)',TR(T{i}(Trace_Len),:),X(T{i}(Trace_Len),:),10);
        if(degree(Dom(T{i}(Trace_Len-1),T{i}(Trace_Len)))==0)
            continue;
        else
            if (Trace_Len-1==1)
                [d,Dom(T{i}(1),T{i}(1))]=CWHFun(x,f(T{i}(1),:)',G(T{i}(1),:),X(T{i}(1),:),10);
                if(degree(Dom(T{i}(1),T{i}(1)))~=0)
                    Init(1,T{i}(1))=Dom(T{i}(1),T{i}(1));
                    R(T{i}(Trace_Len-1),T{i}(Trace_Len))=Dom(T{i}(Trace_Len-1),T{i}(Trace_Len));
                    break;
                end
            else
                for j=Trace_Len-1:-1:2
                    [d,Dom(T{i}(j-1),T{i}(j))]=CWHFun(x,f(T{i}(j),:)',G(T{i}(j),:),X(T{i}(j),:),10);
                    if (degree(Dom(T{i}(j-1),T{i}(j)))==0)
                        break;
                    end
                end
                if(j>2 || degree(Dom(T{i}(1),T{i}(2)))==0)
                    continue;
                end
                [d,Init(1,T{i}(1))]=CWHFun(x,f(T{i}(1),:)',G(T{i}(1),:),X(T{i}(1),:),10);
                for j=1:Trace_Len-1
                    R(T{i}(j),T{i}(j+1))=Dom(T{i}(j),T{i}(j+1)); 
                end
                break;
            end
            
        end
    end
end
t2=clock;
etime(t2,t1)