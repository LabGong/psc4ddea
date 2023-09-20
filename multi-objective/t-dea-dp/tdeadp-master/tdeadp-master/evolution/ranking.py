
# This file implements non-dominated sorting procedure


def non_dominated_ranking(individuals, dom):
    size = len(individuals)
    in_degree = [0] * size
    dominated = [[] for _ in range(size)]

    for i in range(size):
        for j in range(i + 1, size):
            flag = dom(individuals[i], individuals[j])
            if flag == 1:
                in_degree[j] += 1
                dominated[i].append(j)
            elif flag == 2:
                in_degree[i] += 1
                dominated[j].append(i)

    fronts = []
    while True:
        ids = [i for i in range(size) if in_degree[i] == 0]
        fr = [individuals[i] for i in ids]
        if fr:
            fronts.append(fr)
            for i in ids:
                in_degree[i] = -1
                for j in dominated[i]:
                    in_degree[j] -= 1
        else:
            break

    return fronts
