import numpy as np
import random

# This file implements LHS and Random method to initialize the population


# LHS initialization
def lhs_init_population(pcls, ind_init, low, up, n=None):
    contents = lhs_sampling(low, up, n)
    return pcls(ind_init(c) for c in contents)


# Random initialization
def random_init_population(pcls, ind_init, low, up, n=None):
    dim = len(low)
    if n is None:
        n = 11 * dim - 1
    return pcls(ind_init(uniform(low, up)) for _ in range(n))


def lhs_sampling(low, up, n_samples=None):
    dim = len(low)
    if n_samples is None:
        n_samples = 11 * dim - 1

    crd_matrix = np.vstack([np.random.permutation(n_samples) for i in range(dim)]).T
    rnd_matrix = np.random.rand(n_samples, dim)

    xl = np.array([low] * n_samples)
    xu = np.array([up] * n_samples)
    interval = (xu - xl) / n_samples

    return xl + (crd_matrix + rnd_matrix) * interval


def uniform(low, up, size=None):
    try:
        return [random.uniform(a, b) for a, b in zip(low, up)]
    except TypeError:
        return [random.uniform(a, b) for a, b in zip([low] * size, [up] * size)]



