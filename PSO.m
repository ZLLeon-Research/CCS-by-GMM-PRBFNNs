function [BestSol] = PSO(X,K)

CostFunction=@(position) MyCost2(position,X,K);    % Cost Function

n = K;
row = size(X,1);

nVar = n;                   % Number of Decision Variables

VarMin=[ones(1,n)];          % Lower Bound of Decision Variables
VarMax=row*[ones(1,n)];          % Upper Bound of Decision Variables


%% PSO Parameters

MaxIt=5;      % Maximum Number of Iterations
nPop=10;        % Population Size (Swarm Size)
MaxtFE = MaxIt * nPop;
%MaxIt * nPop;

w=1;                % Inertia Weight
wdamp=0.99;         % Inertia Weight Damping Ratio

phi = 4.1;

c1=1.5;             % Personal Learning Coefficient
c2=2.0;             % Global Learning Coefficient

% Constriction Coefficients
% phi1=2.05;
% phi2=2.05;
% phi=phi1+phi2;
% chi=2/(phi-2+sqrt(phi^2-4*phi));
% w=chi;          % Inertia Weight
% wdamp=1;        % Inertia Weight Damping Ratio
% c1=chi*phi1;    % Personal Learning Coefficient
% c2=chi*phi2;    % Global Learning Coefficient



% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;

FEs = 0;


%% Initialization
empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Sol=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.Sol=[];

particle=repmat(empty_particle,nPop,1);

BestSol.Cost=-inf;

for i=1:nPop
    
    % Initialize Position
    particle(i).Position=(VarMax-VarMin).*rand(1,nVar)+VarMin;
    
    % Initialize Velocity
    particle(i).Velocity=zeros(1,nVar);
        
    % Evaluation    
    [particle(i).Cost, particle(i).Sol]=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    particle(i).Best.Sol=particle(i).Sol;
    
    if i==1
        BestSol = particle(1).Best;
    end
    % Update Global Best
    if particle(i).Best.Cost>BestSol.Cost        
        BestSol=particle(i).Best;        
    end
    
end

BestCost=zeros(MaxIt,1);


%% PSO Main Loop
for it = 1:MaxIt    
    if FEs > MaxtFE
        break;
    end
        
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(1,nVar).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(1,nVar).*(BestSol.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
    
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
                              
        
        % Evaluation        
        FEs = FEs + 1;    
        
        
        
        [particle(i).Cost, particle(i).Sol] = CostFunction(particle(i).Position);
        FEfitness(FEs) = particle(i).Cost;
        
                
        % Update Personal Best
        if particle(i).Cost>particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            particle(i).Best.Sol=particle(i).Sol;
            
            % Update Global Best
            if particle(i).Best.Cost>BestSol.Cost
                
                BestSol=particle(i).Best;
                
            end
            
        end
        
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    BestCost(it)=BestSol.Cost;
    
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    w=w*wdamp;
    
%     % Plot Best Solution
%     figure(2);
%     PlotSolution(BestSol.Sol,S);
%     pause(0.001);
          
end

%% Results

figure;
plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');

end



