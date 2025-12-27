## Bandit Level 1 → Level 2

# Challenge: The password for the next level is stored in a file called - located in the home directory.

# Solution: cat ./-

**Explanation:**

# Files named - are treated by most Linux commands as standard input rather than a filename
# Using ./- explicitly tells the shell to treat - as a file in the current directory
# This prevents cat from misinterpreting the filename as an option or input stream
# Running the command outputs the file contents, revealing the password