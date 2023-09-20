 This code is associated with the paper: A Data Stream Ensemble Assisted Multifactorial Evolutionary Algorithm for Offline Data-driven Dynamic Optimization, which has been accepted by Evolutionary Computation (ECJ).

===============Contents===============
DBG.m
DynamicChange.m
h_original.mat
w_original.mat
x_peaks_original.mat
phi.mat
composition_func_data.mat
composition_func_M_D5.mat
composition_func_M_D6.mat
composition_func_M_D7.mat
composition_func_M_D8.mat
composition_func_M_D9.mat
composition_func_M_D10.mat
composition_func_M_D11.mat
composition_func_M_D12.mat
composition_func_M_D13.mat
composition_func_M_D14.mat
composition_func_M_D15.mat
performance.m
scoring_Info.mat
readme.txt

Please put all the files in the same folder.

The main function is DBG.m.
The format is "[f,x,FES,dim] = DBG(x,fun_num,change_instance,FES,num_runs,dim,fun_opts)".
Please see the comments in the program for notations of inputs and outputs.
Always let FES=0 in the first place, so that neccessary initialization can be performed.
Similarly, let num_runs=1 first.

In the process of the implementation, the following data will be recorded for use afterwards:
x_peaks (peak positions), h (heights of peaks), w (widths of peaks), theta (rotation angle), dim_change (sign of dimension change increment), FES_last_change (number of performed function evaluations at last change), 
and change_count (count of changes) for F1;
o (optimal positions), h (parameter H in the formula), theta (rotation angle), 
dim_change (sign of dimension change increment), FES_last_change (number of performed function evaluations at last change), and change_count (count of changes) for F2~F6.
The algorithm should detect the non-dimensional change by itself, therefore, it is not allowed to make use of the above information for the detection of a non-dimensional change.
On the other hand, the algorithm is informed when a dimensional change occurs by the output value "dim".

P.S. As the function continues to call external files, running a few examples at the same time will cause interference. To avoid this limitation, users may consider specify the names of the memory files for every run of the algorithm or put them in different folders.

Performance marking is done by the function "performance".
After all the runs of the 49 test cases, the entire vector "marks" will be formed in the file "scoring_Info.mat".
To get the total score, just add all the components in the vector "marks".
