function smapStack = CalculatesmapStack(emapStack)
[N,T] = size(emapStack);

csum1 = cumsum(emapStack==1,1);
csum2 = cumsum(emapStack==2,1);

score = csum1 + repmat(csum2(end,:),N,1) - csum2;
% figure,imagesc(score);
[min_val min_pos] = min(score,[],1);
smapStack = ones(N,T);
for i = 1:T
    smapStack(1:min_pos(i),i) = 2;
end