from evolution.dom import access_dom_rel
import torch
import numpy as np
import torch.nn as nn


# This file implements some Utility Functions about training

def prepare_dom_data(archive, rel_map, dom, start=0, data_kind='tensor', device='cpu'):
    n = len(archive)

    data = []
    for i in range(start, n):
        for j in range(start, n):
            if i == j:
                continue

            r = access_dom_rel(i, j, archive, rel_map, dom)
            d = archive[i].normalized_var + archive[j].normalized_var + [r]
            data.append(d)

    return get_packed_data(data, data_kind, device)


def prepare_new_dom_data(archive, rel_map, dom, spilt_loc, start=0, data_kind='tensor', device='cpu'):
    n = len(archive)

    data = []

    for i in range(start, spilt_loc):
        for j in range(spilt_loc, n):
            r1 = access_dom_rel(i, j, archive, rel_map, dom)
            d1 = archive[i].normalized_var + archive[j].normalized_var + [r1]

            r2 = access_dom_rel(j, i, archive, rel_map, dom)
            d2 = archive[j].normalized_var + archive[i].normalized_var + [r2]

            data.append(d1)
            data.append(d2)

    for i in range(spilt_loc, n):
        for j in range(spilt_loc, n):
            if i == j:
                continue;

            r = access_dom_rel(i, j, archive, rel_map, dom)
            d = archive[i].normalized_var + archive[j].normalized_var + [r]
            data.append(d)

    return get_packed_data(data, data_kind, device)


def load_batched_dom_data(data, batch_size):
    batched_data = []
    n = data.shape[0]
    r = torch.randperm(n)
    data = data[r, :]

    j = 0
    while j < n:
        k = min(j + batch_size, n)
        x = data[j:k, :-1]
        y = data[j:k:, -1].long()
        batched_data.append((x, y))
        j = k

    return batched_data


def compute_class_weight(class_labels):
    n_examples = len(class_labels)

    class_labels = class_labels.cpu().numpy()
    n_zero = np.sum(class_labels == 0)
    n_one = np.sum(class_labels == 1)
    n_two = n_examples - n_zero - n_one

    if n_zero == 0 or n_one == 0 or n_two == 0:
        return None

    w_zero = n_examples / (3. * n_zero)
    w_one = n_examples / (3. * n_one)
    w_two = n_examples / (3. * n_two)

    return w_zero, w_one, w_two


def train_nn(data, data_loader, net, criterion, optimizer, batch_size, epochs):
    net.train()
    for epoch in range(epochs):  # loop over the dataset multiple times
        running_loss = 0.0
        batched_data = data_loader(data, batch_size)

        for i, d in enumerate(batched_data):
            # get the inputs; data is a list of [inputs, labels]
            inputs, labels = d

            # zero the parameter gradients
            optimizer.zero_grad()

            # forward + backward + optimize
            outputs = net(inputs)

            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()

            running_loss += loss.item()

        print(f"Epoch {epoch + 1}: {running_loss / len(batched_data)}")


def get_packed_data(data, data_kind, device):
    if data_kind == 'tensor':
        return torch.tensor(data, device=device).float()
    elif data_kind == 'ndarray':
        return np.array(data)
    else:
        raise ValueError(f"{data_kind} is not a supported kind of data")


def get_start_pos(total_size, max_window_size):
    if max_window_size is not None and total_size > max_window_size:
        return total_size - max_window_size
    else:
        return 0


def reset_parameters(m):
    if type(m) == nn.Linear:
        m.reset_parameters()


def get_accuracy(true_labels, pred_labels):
    acc0 = acc_for_class(true_labels, pred_labels, 0)
    acc1 = acc_for_class(true_labels, pred_labels, 1)
    acc2 = acc_for_class(true_labels, pred_labels, 2)
    return acc0, acc1, acc2


def acc_for_class(true_labels, pred_labels, cls):
    pls = pred_labels[true_labels == cls]

    if len(pls) == 0:
        return 1

    return (pls == cls).sum().item() / len(pls)
