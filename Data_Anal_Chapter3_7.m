sample = rand(100, 10);

% for i=1:1:100
%     
% end
pd = fitdist(sample(:,1), 'Normal');
paramci(pd)