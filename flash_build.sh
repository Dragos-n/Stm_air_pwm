#!/bin/bash
echo "--Clean--"
make clean
echo "--Make--"
make
echo "--Flash--"
make burn