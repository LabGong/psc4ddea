import numpy as np

# compute igd value of the solutions obtained by the algorithm, pf_path refers the path to Pareto front


def get_igd(pop, pf_path):
    if len(np.shape(pop)) == 1:
        pop = [pop]

    front = np.loadtxt(pf_path)
    obj_values = np.array([ind.fitness.values for ind in pop])

    return compute_igd(obj_values, front)


def compute_igd(obj_values, front):
    min_values = np.min(front, axis=0)
    max_values = np.max(front, axis=0)

    front = (front - min_values) / (max_values - min_values)
    obj_values = (obj_values - min_values) / (max_values - min_values)

    front = front[:, np.newaxis, :]
    front = np.repeat(front, repeats=len(obj_values), axis=1)

    obj_values = obj_values[np.newaxis, :, :]
    obj_values = np.repeat(obj_values, repeats=len(front), axis=0)

    dist_matrix = np.sqrt(np.sum((front - obj_values) * (front - obj_values), axis=2))

    min_dists = np.min(dist_matrix, axis=1)

    return np.average(min_dists)


