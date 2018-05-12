
# DWARF-2 debugging info
# -g3	Debugging level 3
# -O0	No optimization
# -pg	Generate profiling
# -Wall	All warnings
alias cc='gcc -I$HOME/include -gdwarf-2 -g3 -pg -Wall -O0'
alias c++='g++ -I$HOME/include -g3 -Wall -O0 -std=g++17'
