#!/usr/bin/env bash

# Script to build templates by 'mg_questasim_templates', run:
# 1. remove previous output files
# 2. build output files

rm Makefile alias.do example1_tb.sv wave_example1_tb.do

mg_questasim_templates example1
