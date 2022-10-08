clear
clc

sdpvar x y;

f=[0.1, -0.2;0.1+y, -0.2-x];
G=[x^2+y^2-1;0];
TR=[0;(x+0.5)^2+(y+0.5)^2-0.2];
Initage=[1,0];
X=[x^2+y^2-4;x^2+y^2-1];
F=[0,1;0,0];

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
            end
        end
    end
end
for i=1:length(T)
    Trace_Len=length(T{i});
    if(Trace_Len==1)
        [d,Dom(T{i},T{i})]=AircraftFun([x,y],f(T{i},:)',TR(T{i},:),X(T{i},:),10,T{i});
        if (degree(Dom(T{i},T{i}))>0)
            Init(1,T{i})=Dom(T{i},T{i});
            break;
        end
    else
        [d,Dom(T{i}(Trace_Len-1),T{i}(Trace_Len))]=AircraftFun([x,y],f(T{i}(Trace_Len),:)',TR(T{i}(Trace_Len),:),X(T{i}(Trace_Len),:),10,T{i}(Trace_Len));
        if(degree(Dom(T{i}(Trace_Len-1),T{i}(Trace_Len)))==0)
            continue;
        else
            if (Trace_Len-1==1)
                [d,Dom(T{i}(1),T{i}(1))]=AircraftFun([x,y],f(T{i}(1),:)',G(T{i}(1),:),X(T{i}(1),:),10,T{i}(1));
                if(degree(Dom(T{i}(1),T{i}(1)))~=0)
                    Init(1,T{i}(1))=Dom(T{i}(1),T{i}(1));
                    R(T{i}(Trace_Len-1),T{i}(Trace_Len))=Dom(T{i}(Trace_Len-1),T{i}(Trace_Len));
                    break;
                end
            else
                for j=Trace_Len-1:-1:2
                    [d,Dom(T{i}(j-1),T{i}(j))]=AircraftFun([x,y],f(T{i}(j),:)',G(T{i}(j),:),X(T{i}(j),:),10,T{i}(j));
                    if (degree(Dom(T{i}(j-1),T{i}(j)))==0)
                        break;
                    end
                end
                if(j>2 || degree(Dom(T{i}(1),T{i}(2)))==0)
                    continue;
                end
                [d,Init(1,T{i}(1))]=AircraftFun([x,y],f(T{i}(1),:)',G(T{i}(1),:),X(T{i}(1),:),10,T{i}(1));
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