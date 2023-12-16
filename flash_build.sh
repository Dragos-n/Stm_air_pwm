#!/bin/bash

start_time=$(date +%s)

echo "--Clean--"
make clean
echo "--Make--"
make
echo "--Flash--"
make burn

end_time=$(date +%s)
total_time=$((end_time - start_time))
echo "Total run time: ${total_time} seconds"
