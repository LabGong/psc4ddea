function [FrontNo, NoF, NoC] = T_ENS (Population, nSort)
% Efficient non-dominated sort based on M-1 Tree
% accomplished in a non-recursive way, only the structures of vector and
% matrix are used
% Copyright 2016 BIMK Group
%
% Input: 
%        Population: a N-by-M matrix, which stands for the population on
%                    objective space, each row of Y stands for one solution, 
%                    and each column stands for one dimension
%             nSort: number of individuals being sorted at least
% Output:         
%           FrontNo: front number of each solution
%               NoF: number of total fronts
%               NoC: number of total comparisons

	[N,M]   = size(Population);     % N = population size, M = number of objectives
    NoC     = 0;                    % Number of Comparisons
    NoF     = 0;                    % Number of fronts
    FrontNo = inf(1,N);             % front number of each solution
    % sort the population in ascending order according to the first
    % objective value, if two solutions have the same value on the first
    % objective value, sort them according to the next objective value
    [Population,rank] = sortrows(Population);
    % the set of fronts (trees)
    % Forest(i) means the NO. of the root of the i-th tree
    % e.g., Population(Forest(i),:) is the root of the i-th tree
    Forest = zeros(1,N);
    % the NO. of children of each node
    % e.g., Population(Children(i,j),:) is the j-th child of Population(i,:)
    Children = zeros(N,M-1);
    % the site of the most left existent child of each node 
    % e.g., Population(Children(i,LeftChild(i)),:) is the most left
    % existent child of Population(i,:)
    LeftChild = zeros(1,N) + M;
    % the NO. of father of each node
    % e.g., Population(Father(i),:) is the father of Population(i,:);
    Father = zeros(1,N);
    % the site of the next existent brother of each node
    % e.g., Population(Children(Father(i),Brother(i)),:) is the next
    % existent brother of Population(i,:)
    Brother = zeros(1,N) + M;
    % the objective rank of each solution
    [~,ORank] = sort(Population(:,2:M));
    [~,ORank] = sort(ORank);
    [~,ORank] = sort(-ORank,2);
    ORank     = ORank + 1;
    % start the non-dominated sorting
    while sum(FrontNo<inf) < min(nSort,N)
        % start sorting on a new front (tree)
        NoF = NoF + 1;              
        % let the first solution in the remanining population be the root
        % of the NoF-th tree
        Remain      = find(FrontNo==inf);
        Forest(NoF) = Remain(1);
        FrontNo(Remain(1)) = NoF;
        % for each solution having not been sorted, compare it with the
        % solutions in the NoF-th tree, to see whether it is dominated by
        % someone in the tree. And if it is not dominated by anyone, insert
        % it into the tree
        for p = Remain(2:end)
            % store the site for pruning of each node during this iteration
            Pruning = zeros(1,N);
            % compare p with the solutions in the tree, start with the root
            q = Forest(NoF);
            while true
                % compare p with q
                Dominated = true;
                for m = 1 : M-1
                    if Population(p,ORank(q,m)) < Population(q,ORank(q,m))
                        Dominated = false;
                        break;
                    end
                end
                NoC = NoC + 1;
                % p is dominated by q, so p can not be insert into the tree
                if Dominated
                    break;
                % p is not dominated by q, compare p with the next solution
                else
                    % stores the site for pruning of q
                    Pruning(q) = m;
                    % if the left most existent child of q has not been
                    % pruned, compare p with it
                    if LeftChild(q) <= Pruning(q)
                        q = Children(q,LeftChild(q));
                    % otherwise find the next existent brother of q
                    else
                        % find the next existent brother of q, if it is
                        % still be pruned, go back to find the next
                        % existent brother of q's father, until a satisfied
                        % one is found.
                        while Father(q) && Brother(q) > Pruning(Father(q))
                            q = Father(q);
                        end
                        % if a satisfied one is found, compare p with it
                        if Father(q)
                            q = Children(Father(q),Brother(q));
                        % otherwise means that no solution dominating p is
                        % found in the tree
                        else
                            break;
                        end
                    end
                end
            end
            % no solution dominating p is found, insert p into the tree
            if ~Dominated
                % put p into the current front
                FrontNo(p) = NoF;
                % find the father of p, i.e., the right most node which is
                % not pruned in the tree
                q = Forest(NoF);
                while Children(q,Pruning(q))
                    q = Children(q,Pruning(q));
                end
                % let p be the child of q
                Children(q,Pruning(q)) = p;
                % let q be the father of p
                Father(p) = q;
                % if p is the left most child of q
                if LeftChild(q) > Pruning(q)
                    % update the "LeftChild" of q, and the "Brother" of p
                    Brother(p) = LeftChild(q);
                    LeftChild(q) = Pruning(q);
                % otherwise
                else
                    % find the previous existent brother of p
                    bro = Children(q,LeftChild(q));
                    while Brother(bro) < Pruning(q)
                        bro = Children(q,Brother(bro));
                    end
                    % update the "Brother" of p and the previous existent
                    % brother
                    Brother(p) = Brother(bro);
                    Brother(bro) = Pruning(q);
                end
            end
        end
    end
    FrontNo(rank) = FrontNo;
end