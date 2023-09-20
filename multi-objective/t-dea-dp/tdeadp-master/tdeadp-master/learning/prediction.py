import torch
import torch.nn.functional as F
import numpy as np
from evolution.dom import get_inverted_dom_rel

# This file implements dominance prediction in two different scenarios


def nn_predict_dom_intra(pop, net, device): # predict the dominance relation between any two solutions in pop
    size = len(pop)

    label_matrix = np.zeros([size, size], dtype=np.int8)
    conf_matrix = np.ones([size, size])

    data = []
    indexes = []
    for i in range(size):
        for j in range(i + 1, size):
            ind1 = pop[i]
            ind2 = pop[j]
            data.append(ind1.normalized_var + ind2.normalized_var)
            indexes.append((i, j))

    data = torch.tensor(data, device=device).float()

    labels, confidences = nn_predict_dom(data, net)

    for k in range(len(indexes)):
        i = indexes[k][0]
        j = indexes[k][1]

        label_matrix[i, j] = labels[k].item()
        conf_matrix[i, j] = confidences[k].item()

        label_matrix[j, i] = get_inverted_dom_rel(label_matrix[i, j])
        conf_matrix[j, i] = conf_matrix[i, j]

    return label_matrix, conf_matrix


def nn_predict_dom_inter(pop1, pop2, net, device):
    # predict the dominance relation between any two solutions from pop1 and po2 respectively

    size1 = len(pop1)
    size2 = len(pop2)

    label_matrix = np.zeros([size1, size2], dtype=np.int8)
    conf_matrix = np.ones([size1, size2])

    data = []
    indexes = []
    for i in range(size1):
        for j in range(size2):
            ind1 = pop1[i]
            ind2 = pop2[j]
            data.append(ind1.normalized_var + ind2.normalized_var)
            indexes.append((i, j))

    data = torch.tensor(data, device=device).float()
    labels, confidences = nn_predict_dom(data, net)

    for k in range(len(indexes)):
        i = indexes[k][0]
        j = indexes[k][1]

        label_matrix[i, j] = labels[k].item()
        conf_matrix[i, j] = confidences[k].item()

    return label_matrix, conf_matrix


def nn_predict_dom(data, net):
    n = data.shape[1] // 2

    s_data = torch.cat((data[:, n:], data[:, 0:n]), dim=1)

    net.eval()
    with torch.no_grad():
        y = nn_predict(data, net)
        sy = nn_predict(s_data, net)

    max_y, max_y_ids = y.max(dim=1)
    max_sy, max_sy_ids = sy.max(dim=1)

    max_sy_ids = torch.where(max_sy_ids == 0, max_sy_ids, 3 - max_sy_ids)

    labels = torch.where(max_y > max_sy, max_y_ids, max_sy_ids)
    confidences = torch.where(max_y > max_sy, max_y, max_sy)

    return labels, confidences


def nn_predict(data, net, batch_size=1000, max_size=100000):
    if data.shape[0] < max_size:
        y = net(data)
        return F.softmax(y, dim=1)
    else:
        n = data.shape[0]
        y_list = []
        i = 0
        while i < n:
            j = i + batch_size
            if j > n:
                j = n

            bl_data = data[i:j, :]

            y = net(bl_data)
            y = F.softmax(y, dim=1)
            y_list.append(y)

            i = j

        return torch.cat(y_list, dim=0)
