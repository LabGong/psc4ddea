import random

# This file implements three alternative kinds of orders to scan clusters.


# SeqCounter considers clusters sequentially
class SeqCounter:
    def __init__(self, size):
        self.theCount = -1
        self.size = size

    def __call__(self):
        self.theCount += 1
        if self.theCount == self.size:
            self.theCount = 0

        return self.theCount


# PerCounter considers clusters sequentially, but it shuffles the cluster ids in every repetition
class PerCounter:
    def __init__(self, size):
        self.index = -1
        self.size = size
        self.list = list(range(size))

    def __call__(self):
        self.index += 1
        if self.index == self.size:
            self.index = 0
            random.shuffle(self.list)

        return self.list[self.index]


# Consider clusters randomly
class RandCounter:
    def __init__(self, size):
        self.theCount = -1
        self.size = size

    def __call__(self):
        self.theCount = random.randrange(self.size)
        return self.theCount

