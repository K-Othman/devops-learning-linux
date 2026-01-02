# Bandit Level 5 → Level 6

# Challenge: The password for the next level is stored in a file somewhere under the inhere directory and has the following properties:
# - Human-readable
# - Exactly 1033 bytes in size
# - Not executable

# Solution: cd inhere
# find . -type f -size 1033c ! -executable -exec file {} ; | grep text
# cat ./maybehere07/.file2


**Explanation:**
# find . searches recursively through the current directory and all subdirectories
# -type f restricts the search to regular files only
# -size 1033c filters files that are exactly 1033 bytes
# ! -executable excludes files that have execute permissions
# -exec file {} ; checks the file type of each matching file
# grep text filters the output to human-readable text files
# The resulting file contains the password for the next level

# What I learned:
# The find command is extremely powerful for locating files based on multiple conditions. Combining find with file and grep allows precise filtering without manually checking each directory.