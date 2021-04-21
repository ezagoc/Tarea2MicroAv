%% Read
cd('C:/Users/ferna/OneDrive/Escritorio/ProblemSet2');

data = csvread('data_dum.csv',1,0);

data = sparse(data);

%% Generate X
outside = data(:,5);
dis = data(:,10);
id = data(:,3);
choice = data(:,4);
dummies = data(:,20:size(data,2));

X = [outside id dis choice dummies];

X = sparse(X);


%%
beta_start_b = -0.094;
delta_start = ones(1,366);
delta_start(1) = beta_start_b;
tic
options = optimoptions(@fminunc,'Algorithm','quasi-newton','Display','iter','GradObj','off','HessUpdate','bfgs','UseParallel',false,'TolFun',1e-6,'TolX',1e-6,'MaxIter',1e6,'MaxFunEvals',1e6);
[delta_est_b,fval_b,exitflag,output,grad_b,hessian_b] = fminunc(@(delta_b) log_lik_fs(delta_b,X),delta_start,options);
toc