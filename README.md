run_analysis.R ReadMe
==============

R script performs the following actions:
1. reads in data
2. filters x columns to ones that have "mean" or "std" in the name
3. appends columns for subject, x, and y to both test and train sets
4. creates useful column names using the features.txt descrpitions
5. appends rows from test and train sets
6. joins to get descriptive values for "Y" from activity.labels
7. summarizes mean values for each subject and activity by variable
8. writes out tidy result file

