# Bandit Level 4 → Level 5

# Challenge: The password for the next level is stored in the only human-readable file in the inhere directory.

# Solution: cd inhere
#           ls
#           cat ./-file00
#           cat ./-file01
#           cat ./-file02
#           cat ./-file03
#           cat ./-file04
#           cat ./-file05
#           cat ./-file06
#           cat ./-file07


**Explanation:**
# The files start with -, which causes commands to treat them as options
# Using ./ explicitly tells the shell to treat each entry as a filename
# Most files contain binary (non-readable) data
# -file07 is the only file with readable text
# Displaying its contents reveals the password

# What I learned:
# Files that begin with - must be referenced with a relative path. Not all files contain readable text, so identifying human-readable output is key when searching for passwords.