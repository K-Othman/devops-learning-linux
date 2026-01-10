# Bandit Level 11 → Level 12

# Challenge:
# The password for the next level is stored in the file data.txt,
# where all lowercase (a-z) and uppercase (A-Z) letters have been
# rotated by 13 positions.

# Solution:
# cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'

# Explanation:
# tr translates characters from one set to another
# The first set represents the original alphabet
# The second set represents the alphabet rotated by 13 positions
# Applying ROT13 again decodes the text and reveals the password

# What I learned:
# ROT13 is a reversible character substitution cipher.
# The tr command can be used to apply character transformations
# directly from the command line.
