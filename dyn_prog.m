% preliminaries %
cepath='~/Downloads/compecon2011'
path([cepath '/CEtools'],path)

% set model parameters %
price = 1;
sbar = 100;
delta = 0.9;

% set state variables %
S = (0:sbar)';
X = (0:sbar)';
n = length(S);
m = length(X);

f = zeros(n,m);
	for i=1:n
		for k=1:m
			if X(k)<=S(i)
				f(i,k) = price*X(k)-(X(k)^2)./(1+S(i));
			else
				f(i,k) = -inf;
			end
		end
	end

g = zeros(n,m);
	for i=1:n
		for k=1:m
			snext = S(i)-X(k);
			g(i,k) = getindex(snext,S);
		end
	end

model.reward = f;
model.transfunc = g;
model.discount = delta;

[v,x,pstar] = ddpsolve(model);

optset('ddpsolve','algorithm','funcit');

sinit = max(S); nyrs = 15;
spath = ddpsimul(pstar,sinit,nyrs);
plot(1:16, spath)