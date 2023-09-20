from evolution.dom import scalar_dominance
from evolution.utils import *

# Main loop of Theta-DEA-DP


def scalar_dom_ea_dp(init_size, toolbox, mu, lambda_, max_evaluations,
                     category_size=300, f_min=None, f_max=None):
    pop = toolbox.population(init_size)   # initialize the population
    toolbox.normalize_variables(pop)   # normalize all decision variables to [-1, 1]

    f_min, f_max = init_obj_limits(f_min, f_max)   # read the limits of the objectives

    full_evaluate(pop, toolbox, f_min, f_max)     # evaluate all the solutions in the initial population
    evaluations = init_size

    archive = []
    archive.extend(pop)    # add the evaluated solutions to archive

    rep_individuals = init_scalar_rep(pop)      # initialize the scalar (theta) representative solutions

    # get non-dominated ones among the scalar (theta) reps
    nd_rep_individuals = get_non_dominated_scalar_rep(rep_individuals)

    # p_rel_map and s_rel_map are used to save the dominance relation between evaluated solutions,
    # avoid repetitive computation
    p_rel_map, s_rel_map = init_dom_rel_map(max_evaluations)

    print("Initiating Pareto-Net:")
    p_model = toolbox.init_pareto_model(archive, p_rel_map, pareto_dominance)  # init Pareto-Net

    print("Initiating Theta-Net:")
    s_model = toolbox.init_scalar_model(archive, s_rel_map, scalar_dominance)  # init Theta-Net

    while evaluations < max_evaluations:
        print("Eval: ", evaluations)

        offsprings = toolbox.variation(pop, lambda_) # produce offspring using genetic operations
        toolbox.normalize_variables(offsprings)

        # use two-stage preselection to select a solution for function evaluation
        individual = toolbox.filter(offsprings, rep_individuals, nd_rep_individuals, p_model, s_model, category_size)

        if individual is None:
            continue

        full_evaluate([individual], toolbox, f_min, f_max)  # evaluate the selected solution
        evaluations += 1

        archive.append(individual)

        # update representative solutions
        if update_scalar_rep(rep_individuals, individual):
            nd_rep_individuals = get_non_dominated_scalar_rep(rep_individuals)

        # truncate the population size to mu
        pop = toolbox.select(pop + [individual], mu)

        # update Pareto-Net
        if p_model is None:
            print("Initiating Pareto-Net:")
            p_model = toolbox.init_pareto_model(archive, p_rel_map, pareto_dominance)
        else:
            print("Pareto-Net is updating:")
            toolbox.update_pareto_model(p_model, archive, p_rel_map, pareto_dominance)

        # update Theta-Net
        if s_model is None:
            print("Initiating Theta-Net:")
            s_model = toolbox.init_scalar_model(archive, s_rel_map, scalar_dominance)
        else:
            print("Theta-Net is updating:")
            toolbox.update_scalar_model(s_model, archive, s_rel_map, scalar_dominance)

        # print the objective values of representative solutions
        print("Scalar (theta) representative solutions: ")
        for ind in rep_individuals.values():
            print(ind.fitness.values)
        print("Non-dominated ones among scalar (theta) representative solutions:")
        for ind in nd_rep_individuals.values():
            print(ind.fitness.values)
        print("*" * 80)

    return archive
