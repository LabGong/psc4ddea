import numpy as np

# This file implements normalization procedure


# normalize the variables, for training neural nets
def var_normalization(individuals, low, up, lv=-1, uv=1):
    if len(np.shape(individuals)) == 1:
        individuals = [individuals]

    variables = np.array(individuals)

    low = np.array(low)
    up = np.array(up)

    normalized_vars = ((variables - low) / (up - low)) * (uv - lv) + lv
    normalized_vars = normalized_vars.tolist()

    for ind, normalized_var in zip(individuals, normalized_vars):
        ind.normalized_var = normalized_var


# use estimated objective limits to normalize objectives
def obj_normalization(individuals, f_min, f_max):
    if len(np.shape(individuals)) == 1:
        individuals = [individuals]

    fvs = np.array([ind.fitness.values for ind in individuals])
    normalized_fvs = (fvs - f_min) / (f_max - f_min)
    normalized_fvs = normalized_fvs.tolist()

    for ind, normalized_obj_values in zip(individuals, normalized_fvs):
        ind.normalized_obj_values = normalized_obj_values







