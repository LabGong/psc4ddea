import torch
from learning.utils import prepare_dom_data, compute_class_weight, load_batched_dom_data, train_nn
from learning.model import NeuralNet
import torch.nn as nn

# This file implements the procedure to initiate the Pareto-Net or Theta-Net


def init_dom_nn_classifier(archive, rel_map, dom, device, input_size,
                           hidden_size, num_hidden_layers, epochs, batch_size=32,
                           activation='relu', lr=0.001, weight_decay=0.00001):
    data = prepare_dom_data(archive, rel_map, dom, data_kind='tensor', device=device)

    weight = compute_class_weight(data[:, -1])

    if weight is None:
        return None

    net = NeuralNet(input_size, hidden_size, num_hidden_layers,
                    activation=activation).to(device)

    weight = torch.tensor(weight, device=device).float()
    criterion = nn.CrossEntropyLoss(weight=weight)

    optimizer = torch.optim.Adam(net.parameters(), lr=lr, weight_decay=weight_decay)

    train_nn(data, load_batched_dom_data, net, criterion, optimizer, batch_size, epochs)

    return net

