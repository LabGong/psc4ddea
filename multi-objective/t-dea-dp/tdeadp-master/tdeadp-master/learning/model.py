import torch.nn as nn


class NeuralNet(nn.Module):  # defines deep feedforward neural nets
    def __init__(self, input_size, hidden_size=200, num_hidden_layers=2, output_size=3, activation='relu'):
        super(NeuralNet, self).__init__()
        act_fun = get_activation(activation)
        self.input_size = input_size
        self.first_hidden_layer = nn.Sequential(nn.Linear(input_size, hidden_size), act_fun)
        self.out_layer = nn.Linear(hidden_size, output_size)

        self.hidden_layers = [self.first_hidden_layer]
        for _ in range(num_hidden_layers - 1):
            layer = nn.Sequential(nn.Linear(hidden_size, hidden_size), act_fun)
            self.hidden_layers.append(layer)

        if num_hidden_layers != 0:
            self.hidden_layers = nn.ModuleList(self.hidden_layers)
        else:
            self.out_layer = nn.Linear(input_size, output_size)
            self.hidden_layers = []

    def forward(self, x):
        for layer in self.hidden_layers:
            x = layer(x)

        x = self.out_layer(x)
        return x


def get_activation(activation):
    if activation == "relu":
        return nn.ReLU()
    elif activation == "tanh":
        return nn.Tanh()
    elif activation == "sigmoid":
        return nn.Sigmoid()
    else:
        raise RuntimeError("activation should be relu/tanh/sigmoid, not %s." % activation)

