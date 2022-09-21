# Example
This is a small example for Marauder's Map. The SUT was generated with [dungeon_master](https://github.com/fuzzbian/dungeon_master). It contains an indirect function call to showcase the functionality of Marauder's Map.

# How to use

1. Get Marauder's Map ready to use as explained in the main README.

2. Add the path to were you installed AFLGo to fuzz.sh (there is a big comment at the beginning of the script, can't miss it).

3. Run the fuzz script on the SUT: `sh fuzz.sh SUT.c`
