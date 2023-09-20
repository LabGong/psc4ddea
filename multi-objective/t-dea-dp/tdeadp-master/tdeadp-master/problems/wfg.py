from pymop.problem import Problem
import autograd.numpy as anp
import optproblems.wfg
from optproblems import Individual

# define the wrapper for WFG problems in optproblems.wfg


class WFG(Problem):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_var=n_var, n_obj=n_obj, n_constr=0)
        self.n_position_params = n_position_params

    def _evaluate(self, x, out, *args, **kwargs):
        solutions = [Individual(s) for s in x]
        self.func.batch_evaluate(solutions)
        out["F"] = anp.array([s.objective_values for s in solutions])


class WFG1(WFG):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_obj=n_obj, n_var=n_var, n_position_params=n_position_params)
        self.func = optproblems.wfg.WFG1(n_obj, n_var, n_position_params)
        self.xl = self.func.min_bounds
        self.xu = self.func.max_bounds


class WFG2(WFG):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_obj=n_obj, n_var=n_var, n_position_params=n_position_params)
        self.func = optproblems.wfg.WFG2(n_obj, n_var, n_position_params)
        self.xl = self.func.min_bounds
        self.xu = self.func.max_bounds


class WFG3(WFG):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_obj=n_obj, n_var=n_var, n_position_params=n_position_params)
        self.func = optproblems.wfg.WFG3(n_obj, n_var, n_position_params)
        self.xl = self.func.min_bounds
        self.xu = self.func.max_bounds


class WFG4(WFG):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_obj=n_obj, n_var=n_var, n_position_params=n_position_params)
        self.func = optproblems.wfg.WFG4(n_obj, n_var, n_position_params)
        self.xl = self.func.min_bounds
        self.xu = self.func.max_bounds


class WFG5(WFG):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_obj=n_obj, n_var=n_var, n_position_params=n_position_params)
        self.func = optproblems.wfg.WFG5(n_obj, n_var, n_position_params)
        self.xl = self.func.min_bounds
        self.xu = self.func.max_bounds


class WFG6(WFG):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_obj=n_obj, n_var=n_var, n_position_params=n_position_params)
        self.func = optproblems.wfg.WFG6(n_obj, n_var, n_position_params)
        self.xl = self.func.min_bounds
        self.xu = self.func.max_bounds


class WFG7(WFG):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_obj=n_obj, n_var=n_var, n_position_params=n_position_params)
        self.func = optproblems.wfg.WFG7(n_obj, n_var, n_position_params)
        self.xl = self.func.min_bounds
        self.xu = self.func.max_bounds


class WFG8(WFG):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_obj=n_obj, n_var=n_var, n_position_params=n_position_params)
        self.func = optproblems.wfg.WFG8(n_obj, n_var, n_position_params)
        self.xl = self.func.min_bounds
        self.xu = self.func.max_bounds


class WFG9(WFG):
    def __init__(self, n_obj=3, n_var=10, n_position_params=2):
        super().__init__(n_obj=n_obj, n_var=n_var, n_position_params=n_position_params)
        self.func = optproblems.wfg.WFG9(n_obj, n_var, n_position_params)
        self.xl = self.func.min_bounds
        self.xu = self.func.max_bounds

