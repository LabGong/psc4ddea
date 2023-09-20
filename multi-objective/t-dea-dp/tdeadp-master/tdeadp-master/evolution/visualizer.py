import matplotlib.pyplot as plt

# this method provides the visualization for preselection, only works for 2-objective case
# the blue '^' are those current theta representative solutions
# the green 'v' is the current theta representative solution to be improved in this iteration
# '.', '*', or 'x' refers to the sampled solutions in the selected category


def visualize_preselection(cid, ref_points, rep_ind, rep_individuals,
                           ps_offs, s_offs, p_offs, distinct_offs,
                           best_ind, toolbox):
    ref_point = ref_points[cid]
    if len(ref_point) != 2:
        return

    print(f"{cid}-th reference point: {ref_point} is considered")
    if rep_ind is not None and best_ind is not None:
        print("The size of category Q1: ", len(ps_offs))
        print("The size of category Q2: ", len(s_offs))
        print("The size of category Q3: ", len(p_offs))
        print("The cluster the selected solution locates: ", best_ind.cluster_id)

        if ps_offs:
            fvs = toolbox.evaluate(ps_offs)
            plt.scatter(fvs[:, 0], fvs[:, 1], marker='.', c='#C0C0C0')
        elif s_offs:
            fvs = toolbox.evaluate(s_offs)
            plt.scatter(fvs[:, 0], fvs[:, 1], marker='*', c='#C0C0C0')
        else:
            fvs = toolbox.evaluate(p_offs)
            plt.scatter(fvs[:, 0], fvs[:, 1], marker='x', c='#C0C0C0')

        bv = toolbox.evaluate(best_ind)
        rv = toolbox.evaluate(rep_ind)

        all_rep_val = toolbox.evaluate(rep_individuals)

        plt.scatter(all_rep_val[:, 0], all_rep_val[:, 1], marker='^', linewidths=5, c='b')
        plt.scatter(rv[0], rv[1], marker='v', linewidths=5, c='g')
        plt.scatter(bv[0], bv[1], marker='o', linewidths=5, c='r')

        plt.show()
    elif distinct_offs:
        fvs = toolbox.evaluate(distinct_offs)
        plt.scatter(fvs[:, 0], fvs[:, 1], marker='+', c='#C0C0C0')

        if best_ind is not None:
            bv = toolbox.evaluate(best_ind)
            plt.scatter(bv[0], bv[1], marker='o', linewidths=5, c='r')
        plt.show()




