import numpy as np

# This file implements the clustering operator in the original Theta-DEA
# For each solution, cluster_id means the cluster it locates at
# scalar_dist means the scalar distance
# we provide several alternative distances , default is PBI, corresponding to theta-dominance


def cluster_scalarization(individuals, ref_points, scalar_func='PBI', theta=5.0, ro=0.05):
    if len(np.shape(individuals)) == 1:
        individuals = [individuals]

    cf = np.array([ind.normalized_obj_values for ind in individuals])
    ref_points_t = ref_points.T  # ref_points_t = [n_obj, r]

    ref_norm = np.linalg.norm(ref_points_t, axis=0)  # ref_norm = [r, ]
    cf_norm = np.linalg.norm(cf, axis=1).reshape(-1, 1)  # cf_norm = [N, 1]

    d1s = cf.dot(ref_points_t) / ref_norm  # d1s = [N, r]
    d2s = np.sqrt(cf_norm * cf_norm - d1s * d1s)  # d2s = [N, r]

    indexes = np.argmin(d2s, axis=1)

    for ind, index in zip(individuals, indexes):
        ind.cluster_id = index

    if scalar_func == 'PBI':
        compute_pbi_dist(individuals, d1s, d2s, theta)
    elif scalar_func == 'TCH':
        compute_tch_dist(individuals, ref_points)
    elif scalar_func == 'I_TCH':
        compute_inverted_tch_dist(individuals, ref_points)
    elif scalar_func == "A_TCH":
        compute_augmented_tch_dist(individuals, ref_points, ro)
    elif scalar_func == "WS":
        compute_weighted_sum_dist(individuals, ref_points)
    else:
        raise ValueError(f"{scalar_func} is not a valid scalar function")


def compute_pbi_dist(individuals, d1s, d2s, theta):
    for ind, d1, d2 in zip(individuals, d1s, d2s):
        index = ind.cluster_id
        ind.scalar_dist = d1[index] + theta * d2[index]


def compute_tch_dist(individuals, ref_points):
    for ind in individuals:
        ref_point = ref_points[ind.cluster_id]
        norm_values = np.array(ind.normalized_obj_values)
        ind.scalar_dist = np.max(ref_point * norm_values)


def compute_inverted_tch_dist(individuals, ref_points):
    for ind in individuals:
        ref_point = ref_points[ind.cluster_id]
        ref_point = np.where(ref_point == 0, 1e-6, ref_point)

        norm_values = np.array(ind.normalized_obj_values)
        ind.scalar_dist = np.max(norm_values / ref_point)


def compute_weighted_sum_dist(individuals, ref_points):
    for ind in individuals:
        ref_point = ref_points[ind.cluster_id]
        norm_values = np.array(ind.normalized_obj_values)
        ind.scalar_dist = np.dot(ref_point, norm_values)


def compute_augmented_tch_dist(individuals, ref_points, ro):
    for ind in individuals:
        ref_point = ref_points[ind.cluster_id]
        norm_values = np.array(ind.normalized_obj_values)
        ind.scalar_dist = np.max(ref_point * norm_values) + ro * np.dot(ref_point, norm_values)


