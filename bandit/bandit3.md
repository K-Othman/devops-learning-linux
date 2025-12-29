## Bandit Level 3 → Level 4

# Challenge: The password for the next level is stored in a hidden file in the inhere directory.

# Solution: cd inhere
#           ls -a
#           cat ...Hiding-From-You


**Explanation:**

# cd inhere moves into the directory where the file is located
# ls -a lists all files, including hidden ones (files starting with a dot)
# The file name starts with dots, making it hidden by default
# cat ...Hiding-From-You displays the contents of the hidden file, revealing the password