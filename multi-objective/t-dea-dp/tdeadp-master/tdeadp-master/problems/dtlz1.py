from pymop.problem import Problem
import autograd.numpy as anp

# This is a modified DTLZ1 problem, according to the ParEGO paper
# 20 * pi in the cosine term is replaced with 2 * pi to reduce the ruggedness of the function


class DTLZ1a(Problem):
    def __init__(self, n_var=6, n_obj=2):
        self.k = n_var - n_obj + 1
        super().__init__(n_var=n_var, n_obj=n_obj, n_constr=0, xl=0, xu=1, type_var=anp.double)

    def g1(self, X_M):
        return 100 * (self.k + anp.sum(anp.square(X_M - 0.5) - anp.cos(2 * anp.pi * (X_M - 0.5)), axis=1))

    def _evaluate(self, x, out, *args, **kwargs):
        X_, X_M = x[:, :self.n_obj - 1], x[:, self.n_obj - 1:]
        g = self.g1(X_M)

        f = []
        for i in range(0, self.n_obj):
            _f = 0.5 * (1 + g)
            _f *= anp.prod(X_[:, :X_.shape[1] - i], axis=1)
            if i > 0:
                _f *= 1 - X_[:, X_.shape[1] - i]
            f.append(_f)

        out["F"] = anp.column_stack(f)