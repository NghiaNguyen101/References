#!/bin/bash

# clean and make again for the most updated lib
echo "run make file"
echo
make clean
make

LWP=liblwp.a
OLWP=liblwp-i686.a 

echo
echo "Start Testing"
echo

# compile with lib
for file in $(ls tests/input/* ); do
   echo "-- Testing with file ${file} --"
   BASE=`basename ${file} .c`

   cc ${file} ${LWP} -m32 -g -o tests/myexe/${BASE}
   cc ${file} ${OLWP} -m32 -g -o tests/expectexe/${BASE}

   # add permission to run
   chmod 700 tests/myexe/${BASE}
   chmod 700 tests/expectexe/${BASE}
   
   # run the executable
   tests/myexe/${BASE} > tests/output/${BASE}.out
   tests/expectexe/${BASE} > tests/output/${BASE}.expect

   tests/myexe/${BASE} -z > tests/output/${BASE}Zero.out
   tests/expectexe/${BASE} -z > tests/output/${BASE}Zero.expect

#  tests/myexe/${BASE} -l > tests/output/${BASE}Last.out
#  tests/expectexe/${BASE} -l > tests/output/${BASE}Last.expect

   # diff result
   diff tests/output/${BASE}.out tests/output/${BASE}.expect
   diff tests/output/${BASE}Zero.out tests/output/${BASE}Zero.expect
#  diff tests/output/${BASE}Last.out tests/output/${BASE}Last.expect
done

# remmove output file
rm -f tests/output/*
rm -f tests/myexe/*
rm -f tests/expectexe/*

echo
