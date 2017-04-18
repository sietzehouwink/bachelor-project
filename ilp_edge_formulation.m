f = -1 * ones(8,1);
intcon = ones(8,1);
A = [1,0,0,0,0,0,0,0;
     0,1,1,0,0,0,0,0;
     0,0,0,1,1,0,0,0;
     0,0,0,0,0,1,1,0;
     0,0,0,0,0,0,0,1];
b = ones(5,1);
Aeq = [1,-1,0,0,0,0,0,-1;
       -1,1,1,-1,0,0,0,0;
       0,0,-1,1,1,-1,0,0;
       0,0,0,0,-1,1,1,0;
       0,0,0,0,0,0,-1,1];
beq = zeros(5,1);
lb = zeros(8,1);
ub = ones(8,1);
[x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
x
-fval
exitflag
output