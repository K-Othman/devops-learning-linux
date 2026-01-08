# Bandit Level 10 → Level 11

# Challenge:
# The password for the next level is stored in the file data.txt,
# which contains base64 encoded data.

# Solution:
# cat data.txt | base64 -d

# Explanation:
# cat outputs the contents of data.txt
# base64 -d decodes base64-encoded input into readable text
# The decoded output reveals the password for the next level

# What I learned:
# Base64 is commonly used to encode data for safe transport.
# Linux provides built-in tools to decode encoded content,
# making it easy to retrieve original information from encoded files.
