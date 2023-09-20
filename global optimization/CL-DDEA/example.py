import os 
os.environ['TF_CPP_MIN_LOG_LEVEL']='3'
import numpy as np
import time
import os
import main
import benchmark

dir_name = 'lab'
max_iter = 100
max_run = 20
info_flag = False

if not os.path.isdir(dir_name):
    os.mkdir(dir_name)

def run_benchmark(f, ds, max_iter=max_iter, max_run=max_run, info_flag=info_flag):
    lower_bound, upper_bound = benchmark.get_bound(f)
    for d in ds:
        ys = []
        for i in range(max_run):
            time1 = time.time()
            ret = main.main(
                f=f,
                d=d,
                max_iter=max_iter,
                run=i+1,
                max_run=max_run,
                lower_bound=lower_bound,
                upper_bound=upper_bound,
                info_flag=info_flag,
            )
            time2 = time.time()
            if info_flag:
                print(f'\n{i}: total time = {time2 - time1}\n')
            y = f(ret).reshape(-1)
            ys.append(y)
        ys = np.array(ys)
        np.savetxt(f'{dir_name}/{f.__name__}_d={d}_y.csv', ys, delimiter="\t")


if __name__ == "__main__":
    run_benchmark(f=benchmark.rastrigin, ds=[100], info_flag=True)

