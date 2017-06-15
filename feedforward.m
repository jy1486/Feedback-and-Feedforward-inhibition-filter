

k=0.4;
%e1=ones(10,0:0.1:1);
%e1 = [0.1:0.1:1]';
e1=ones(10,1);
e2=zeros(10,1);
e=[e1;e2];
%e=e+k*r0;
nend = size(e,1);
y = zeros(nend,1);
for j=1:nend
    if j == 1
        y(j) = e(j) - k *(e(j+1));
    elseif j == nend
        y(j) = e(j) - k *(e(j-1));
    else
    y(j) = e(j) - k *(e(j-1) + e(j+1));
    end
end

for i = 1:size(x,1)
    hold on;
    subplot(2,1,1);
    line([i,i],[0,1],'Color', [x(i) x(i) x(i)],'LineWidth',16.5)
    hold off;
end
subplot(2,1,2); 
plot((1:nend),y)
%y
%plot(1:size(e,1),e)