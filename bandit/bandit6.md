# Bandit Level 6 → Level 7

# Challenge:
# The password for the next level is stored somewhere on the server and has the following properties:
# - Owned by user bandit7
# - Owned by group bandit6
# - Exactly 33 bytes in size

# Solution:
# find / -type f -size 33c -user bandit7 -group bandit6 2>/dev/null
# cat /var/lib/dpkg/info/bandit7.password

# Explanation:
# find / searches the entire filesystem starting from root
# -type f restricts the search to regular files
# -size 33c filters files that are exactly 33 bytes in size
# -user bandit7 and -group bandit6 match file ownership
# 2>/dev/null suppresses permission denied errors
# The resulting file contains the password for the next level

# What I learned:
# Searching globally and handling permission errors is essential when
# auditing systems. Redirecting stderr prevents noise from hiding results.
