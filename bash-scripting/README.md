# Bash Scripting

## Why Bash Matters in DevOps
- Bash is fundamental in DevOps for automating system tasks, scripting deployments, managing files, and gluing tools together in CI/CD pipelines.

## Level 1 – The Basics

**Mission:**  
Create an Arena directory, add three files, and list its contents.

**Script:** `level-01-arena.sh`

**Key Learnings:**
- Creating directories with `mkdir`
- Creating files with `touch`
- Listing directory contents with `ls`

**Challenge Overcome:**
Understanding how to automate multiple file operations in a single script instead of running commands manually.

## ------------------------------------

## Level 2 – Variables and Loops

**Mission:**  
Create a script that outputs the numbers 1 to 10, one number per line.

**Script:** `level-02-variables-loops.sh`

**Key Learnings:**

- Using C-style for loops in Bash
- Initialising and incrementing variables
- Controlling loop execution
- Printing values with echo
- Challenge Overcome:
- Getting comfortable with Bash loop syntax and understanding how variables are expanded inside loops.


## ------------------------------------
## Level 3: Conditional Statements

**Mission:** 
Write a script that checks if a file named hero.txt exists in the Arena directory. If it does, print Hero found!; otherwise, print Hero missing!.

**Script:** `level-03-conditionals.sh`

**Key Learnings:**

- Using if / else conditional statements
- Checking file existence with test operators
- Understanding file test flags in Bash
- Controlling script flow based on conditions

**Challenge Overcome:**
Learning the difference between testing strings and testing filesystem objects, and using the correct file test operator for reliable condition checks.

## ------------------------------------

## Level 4 – File Manipulation

**Mission:** 
Create a script that copies all .txt files from the Arena directory to a new directory called Backup.

**Script:** `level-04-file-manipulation.sh`

**Key Learnings:**
- Using glob patterns (*.txt) to match files
- Copying multiple files with a single command
- Understanding source and destination paths
- Working with directories in file operations

**Challenge Overcome:**
Learning how to copy multiple files at once using globbing instead of trying to pipe filenames between commands.

## ------------------------------------

## Level 5 – Boss Battle: Combining Basics

**Mission:** 
Combine core Bash concepts by creating files, checking conditions, moving files, and listing directory contents.

**Script:** level-05-boss-battle.sh

**Key Learnings:**

- Creating and managing directories
- Creating multiple files efficiently
- Checking file existence before performing actions
- Moving files between directories
- Listing contents of multiple directories
**Challenge Overcome:**
Combining file creation, conditional checks, and file movement into a single script while maintaining correct execution order and directory structure.