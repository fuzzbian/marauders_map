# Marauder's Map
Marauder's Map is an extension for AFLGo's distance calculation that considers indirect function calls via function pointers.

# How to use

1. Marauder's Map uses SVF-tools to handle function pointers. Download and build [SVF](https://github.com/SVF-tools/SVF).

2. Copy marauders_map.py to the "scripts" directory of AFLGo (the one that contains gen_distance_fast.py) and make sure marauders_map.py is executable (`chmod +x marauders_map.py`).

3. Add the path to were you installed SVF to marauders_map.py (there is a big comment at the beginning of the script, can't miss it).

4. Use marauders_map.py in place of gen_distance_fast.py/genDistance.sh in your fuzzing script (there is an example in the "example" directory).
