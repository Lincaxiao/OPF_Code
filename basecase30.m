data = case30;
res = runpf(data);
Ploss = sum(res.branch(:, 14) + res.branch(:, 16));
Cost = sum(data.gencost(:, 5) .* data.gen(:, 2) .^ 2 + data.gencost(:, 6) .* data.gen(:, 2));
disp(['The initial cost is ', num2str(Cost)]);
disp(['The initial power loss is ', num2str(Ploss)]);