%% Initialization
%  Initialize the world, Q-table, and hyperparameters
%Initialize world
s = gwinit(1);
Q = rand(s.ysize+2,s.xsize+2, 4);

%setting positions outside the world (illegal moves) to minus infinity
Q(:,1,:) = -inf;
Q(:,s.xsize+2,:) = -inf;
Q(1,:,:) = -inf;
Q(s.ysize+2,:,:) = -inf;

%initialize hyperparameters
episodes = 3000; 
a = [1,2,3,4];
a_prob = [1,1,1,1];
eps = 0.99;
eta  = 0.3;
gamma = 0.9;

%% Training loop
%  Train the agent using the Q-learning algorithm.

for i=1:episodes
    init_pos = s.pos
    state = s;
    while s.isterminal==0
        
        %choose and take action
        y = state.pos(1);
        x = state.pos(2);
        action = chooseaction(Q, y, x, a, a_prob, eps);
        state = gwaction(action);
        
        %observe new state
        r = state.feedback;
        new_y = state.pos(1);
        new_x = state.pos(2);
        
        %update Q
        Q_max = getpolicy(Q);
        Q(y,x,action) = (1-eta)*Q(y,x,action)+eta*(r+gamma*Q_max(new_y, new_x));
        
        gwdraw()
        
    end
    
end

%% Test loop
%  Test the agent (subjectively) by letting it use the optimal policy
%  to traverse the gridworld. Do not update the Q-table when testing.
%  Also, you should not explore when testing, i.e. epsilon=0; always pick
%  the optimal action.

