#!/bin/bash
echo "input the nuber to check"
read num
if [[ "$num" =~ ^[0-9]+$ ]]; then
  echo -n "The $num is "
    if [ $(($num % 2)) -ne 0 ]; then
echo "odd"
else 
echo "even"
    fi
else
echo "the input was invalid, try with a valid interger."
fi