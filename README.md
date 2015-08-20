# Course: Getting and Cleaning Data
## Course Project - Tidy Data
### Written by Y. Sakoury

# Description
Get data spread over several files. Merge it in a logical way and make it tidy, so it is ready for next steps of analysing it. What it means logical way? Well it depends on the requests. But here we got most of it already arranged nicely but not completely. I tried to see the logical connection between the files. I also tried to guess by the demands detailed in the work (site). For instance should I use the 'Inertial Signals' data? No. Because any way demand 2 asks for Mean() and Std() which here don't exist.

Decisions:
1. What will be the best way to merge the data?
+ 1.1 First, rbind X_test to X_train and Y_test to Y_train.
+ 1.2 Then, cbind the result.
This is a simple yet long way but it gives us a result without the side effects of using 'merge()'. 
2. First, make second column of 'Features.txt' the names of columns. Extraction will be done only on "real" measurements and not calculations. This is done, depending on the explanations in Features_Info.txt.
3. Convert numbers to more descriptive activity names.
4. The names of all parameters obtained by the experiments are very descriptive. Although they contain valuable information to the reader as to what they mean, they are not legal *Variables* names. Now, there are several ways to make them legal. I chose the easiest way of doing it, by using the function 'make.names()'. It's not beautiful but...it's legal!
5. OK, last step. We need the final tidy data. Many ways to achieve this. As usual I tried the simplest and easy way, as shown in classroom; e.g. 'melt()' and 'dcast()'. I think I got the right table (hopefully).
6. Last request is to save data without any headers of any kind, in a textual file, using 'write.table()'.

(See script in the included file run_analysis.R)