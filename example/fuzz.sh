#!/bin/bash

# BUILD SUT FOR AFLGO
# PASS PATH TO SUT AS COMMAND LINE ARGUMENT FOR THIS SCRIPT

# DON'T FORGET TO SET CORE PATTERN
# sudo sysctl -w kernel.core_pattern="core"

# SET PATH TO AFLGO HERE !!!
export AFLGO="[PATH]/aflgo"

# SETTING PATH TO SUBJECT
export SUBJECT="${PWD}";
mkdir obj-aflgo; mkdir obj-aflgo/temp
export TMP_DIR=$SUBJECT/obj-aflgo/temp

# SETTING THE TARGET
export TARGETS="$1:7121\n"
echo -e "${TARGETS}" > $TMP_DIR/BBtargets.txt

# COMPILE SUT FOR DISTANCES
export CC=$AFLGO/afl-clang-fast; export CXX=$AFLGO/afl-clang-fast++
export CC_AFLGO=$AFLGO/afl-clang-fast; export CXX_AFLGO=$AFLGO/afl-clang-fast++
export CFLAGS="-O0 -g"
export LDFLAGS=-lpthread
export ADDITIONAL="-targets=$TMP_DIR/BBtargets.txt -outdir=$TMP_DIR -flto -fuse-ld=gold -Wl,-plugin-opt=save-temps"
export DRIVER_DIR=$TMP_DIR/fuzz
export LIB_DIR=$SUBJECT/obj-aflgo/lib
export INCLUDE_DIR=$SUBJECT

mkdir ${DRIVER_DIR}
cd ${SUBJECT}

${CC_AFLGO} ${CFLAGS} ${ADDITIONAL} -I ${INCLUDE_DIR} -v $1 -o "${DRIVER_DIR}/test_driver"

cd $TMP_DIR; 
cat $TMP_DIR/BBnames.txt | rev | cut -d: -f2- | rev | sort | uniq > $TMP_DIR/BBnames2.txt && mv $TMP_DIR/BBnames2.txt $TMP_DIR/BBnames.txt
cat $TMP_DIR/BBcalls.txt | sort | uniq > $TMP_DIR/BBcalls2.txt && mv $TMP_DIR/BBcalls2.txt $TMP_DIR/BBcalls.txt

# USE MARAUDER'S MAP IN PLACE OF gen_distance_fast.py
# $AFLGO/scripts/gen_distance_fast.py $DRIVER_DIR $TMP_DIR test_driver
$AFLGO/scripts/marauders_map.py $DRIVER_DIR $TMP_DIR test_driver


# BUILD SUT WITH DISTANCE INSTRUMENTATION
export AFL_USE_ASAN=1 
export ADDITIONAL="-distance=$TMP_DIR/distance.cfg.txt -fPIC -O0 -flto -fuse-ld=gold -Wl,-plugin-opt=save-temps"
cd ${SUBJECT}

${CC_AFLGO} ${CFLAGS} ${ADDITIONAL} -v $1 -o "${DRIVER_DIR}/test_driver"

# RUN AFLGO
cd $DRIVER_DIR
mkdir in; echo "" > in/in

$AFLGO/afl-fuzz -i in -o afl-out -m none -t $((60 * 1000)) ${DRIVER_DIR}/test_driver