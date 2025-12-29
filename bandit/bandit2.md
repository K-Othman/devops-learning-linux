## Bandit Level 2 → Level 3

# Challenge:The password for the next level is stored in a file called --spaces in this filename-- located in the home directory

# Solution: cat ./--sapces\ in\ this\ filename--

**Explanation:**

# Filenames containing spaces must be escaped so the shell treats them as a single argument
# The backslash (\) tells the shell to include the space as part of the filename
# Using ./ explicitly references the file in the current directory
# Running the command outputs the file contents, revealing the password