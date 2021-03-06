%% Initialization
%  Initialize the world, Q-table, and hyperparameters
%Initialize world
world = 3;
s = gwinit(world);
Q = rand(s.ysize,s.xsize, 4);

%setting positions outside the world (illegal moves) to minus infinity
%limit up
Q(1,:,2) = -inf;

%limit down
Q(end,:,1) = -inf;

%limit left
Q(:,1,4) = -inf;

%limit right
Q(:,end,3) = -inf;

%initialize hyperparameters
episodes = 300; 
a = [1,2,3,4];
a_prob = [1,1,1,1];
eps_init = 1.0;
eta_init  = 1.0;
gamma = 0.9;
gwdraw()

%% Training loop
%  Train the agent using the Q-learning algorithm.
breakpoint = 1;
eps = eps_init;
eta = eta_init;
tic;
for i=1:episodes
    
    while s.isterminal==0
        
        %choose and take action
        y = s.pos(1);
        x = s.pos(2);
        [action, oa] = chooseaction(Q, y, x, a, a_prob, eps);
        s = gwaction(action);
        
        %observe new state
        r = s.feedback;
        new_y = s.pos(1);
        new_x = s.pos(2);
        
        %update Q
        Q_max = getvalue(Q);
        if Q(y,x,action)~= -inf %will avoid to change -inf to NaN
            Q(y,x,action) = (1-eta)*Q(y,x,action)+eta*(r+gamma*Q_max(new_y, new_x));
        end
        %gwdraw()
        
    end

    
    if i > breakpoint*episodes
        
        eps = eps-eps_init/(episodes*(1-breakpoint));
        
        %uncomment for world 1 and 3
        %eta = eta + eta_init/(breakpoint*episodes);

    end

    s = gwinit(world);
end
toc
toc-tic
 %% Test loop
%  Test the agent (subjectively) by letting it use the optimal policy
%  to traverse the gridworld. Do not update the Q-table when testing.
%  Also, you should not explore when testing, i.e. epsilon=0; always pick
%  the optimal action.

s=gwinit(world);

while s.isterminal==0
        
        %choose and take action
        y = s.pos(1);
        x = s.pos(2);
        [action, oa] = chooseaction(Q, y, x, a, a_prob, 0);
        s = gwaction(oa);

        gwdraw()
        
end
%% Get policy and value
P = getpolicy(Q);

figure(1)
gwdraw("episode", episodes, "policy", P)

figure(2)
V= getvalue(Q);
imagesc(V)
title("World 3 V-function")
colorbar
%% test moves

s = gwaction(4);
gwdraw()

