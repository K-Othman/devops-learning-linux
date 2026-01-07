# Bandit Level 9 → Level 10

# Challenge:
# The password for the next level is stored in the file data.txt
# in one of the few human-readable strings, preceded by several '=' characters.

# Solution:
# strings data.txt | grep "==="

# Explanation:
# strings extracts human-readable text from a binary file
# grep filters the output to lines containing several '=' characters
# The resulting line contains the password for the next level

# What I learned:
# Binary files can contain readable strings.
# The strings command is useful for extracting meaningful text
# before applying standard text-processing tools like grep.
