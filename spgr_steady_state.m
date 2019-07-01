fa = 0:180;
m = 0;

tr = 0.013;
t1 = 1;

s = zeros(length(fa),length(t1));
for ii = 1:length(t1)
    E1 = exp(-tr/t1(ii));
    C = cosd(fa);
    S = sind(fa);
    
    s(:,ii) = S.*(1-E1) ./ (1-C*E1);
end

plot(fa,s);
legend(num2str(t1))