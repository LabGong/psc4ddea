# -*- coding: utf-8 -*-

import numpy as np
import tqdm

import crossover
import mutation
import selection
import preprocs

def main(**kw):
    """
    Return:
        The best solutions in each iteration
    """
    
    config = preprocs.procs_params(kw)
    procs_model(config)

    # evolutionary algorithm
    # stores the best solution in every iteration
    ret = []
    pop = config["pop"]
    if config["info_flag"]:
        pbar = tqdm.tqdm(range(config["max_iter"]))
        pbar.set_description(f'{config["f"].__name__} {config["d"]}d - {config["run"]}/{config["max_run"]}')
    else:
        pbar = range(config["max_iter"])
    for i in pbar:
        config["iter"] = i + 1

        pop1 = crossover.sbx(
            pop=pop,
            lower_bound=config["lower_bound"],
            upper_bound=config["upper_bound"],
            pc=config["pc"],
            eta_c=config["eta_c"]
        )
        pop2 = mutation.poly_mutation(
            pop=np.vstack((pop, pop1)),
            lower_bound=config["lower_bound"],
            upper_bound=config["upper_bound"],
            pm=config["pm"],
            eta_m=config["eta_m"]
        )

        pop = np.vstack((pop, pop1, pop2))

        pop_idx = selection.select(
            pop=pop,
            config=config
        )

        # update the population
        pop = pop[pop_idx]
        # store the best individual
        ret.append(pop[0])

    return np.array(ret)

def procs_model(config):
    import time
    from cmp import CmpModel
    if config["info_flag"]:
        time1 = time.time()
    
    # train the comparison model
    samples_x, samples_y = config["samples"]
    config["cmp_model"] = CmpModel()
    config["cmp_model"].fit(
        samples_x,
        samples_y
    )

    if config["info_flag"]:
        time2 = time.time()
        print("{run}: Compare model build time = ".format(run=config["run"]), time2 - time1)
        time.sleep(1) # In order to be compatible with the output of tqdm
