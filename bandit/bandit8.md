# Bandit Level 8 → Level 9

# Challenge:
# The password for the next level is stored in the file data.txt
# and is the only line of text that occurs only once.

# Solution:
# sort data.txt | uniq -u

# Explanation:
# sort arranges all lines in data.txt in alphabetical order
# uniq -u prints only lines that appear exactly once
# Sorting is required because uniq only works on adjacent duplicate lines
# The output of this command reveals the unique line containing the password

# What I learned:
# Combining commands with pipes allows complex text processing.
# sort and uniq together are commonly used to identify unique
# or duplicate entries in large datasets.
