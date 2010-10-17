#!/bin/bash
for file in `ls results`; do perl bargraph.pl results/$file > graphs/$file.eps; done
