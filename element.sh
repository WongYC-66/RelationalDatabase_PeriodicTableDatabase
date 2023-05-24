#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# check if it has no input
if [[ $1 == "" ]]
then
  echo "Please provide an element as an argument."  
  exit
fi
# has input
input=$1
# echo $input

# check if input is number or symbol or name, then >> number/symbol/name from elements table.
if [[ $input =~ ^[0-9]+$ ]]
then
  # input is number
  if [[ $input =~ ^0$ ]]
  then
    # input is 0, exit
    echo "Please provide an element as an argument."  
    exit
  fi
  ATOMIC_NUMBER=$input
  ELEMENT_SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER ;")" 
  # verify input
  if [[ -z $ELEMENT_SYMBOL ]]
  then
    # invalid. quit.
    echo "I could not find that element in the database."  
    exit
  fi
  ELEMENT_NAME="$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER ;")" 
  
else
  # check if symbol or element_name
  if [[ $input =~ ^[A-Z]$ ||  $input =~ ^[A-Z][A-Za-z]$ ]]   # H or Be or MT
  then
    # is symbol
    ELEMENT_SYMBOL=$input
    ATOMIC_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT_SYMBOL' ;")" 
    # verify input
    if [[ -z $ATOMIC_NUMBER ]]
    then
      # invalid. quit.
      echo "I could not find that element in the database."  
      exit
    fi
    ELEMENT_NAME="$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER ;")" 
  else
    # is name
    ELEMENT_NAME=$input
    ATOMIC_NUMBER="$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT_NAME' ;")" 
    # verify input
    if [[ -z $ATOMIC_NUMBER ]]
    then
      # invalid. quit.
      echo "I could not find that element in the database."  
      exit
    fi
    ELEMENT_SYMBOL="$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER ;")" 
  fi
fi

TYPE_ID="$($PSQL "SELECT type_id FROM properties WHERE atomic_number='$ATOMIC_NUMBER' ;")" 
TYPE="$($PSQL "SELECT type FROM types WHERE type_id='$TYPE_ID' ;")" 
ATOMIC_MASS="$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NUMBER' ;")" 
MELTING_POINT="$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER' ;")" 
BOILING_POINT="$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER' ;")" 

# cleanse data /remove white space
# CUSTOMER_NAME=$(echo $CUSTOMER_NAME | sed -E "s/[‘|’|']//g")  # cleanse input data
ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed -E 's/ //g')
ELEMENT_SYMBOL=$(echo $ELEMENT_SYMBOL | sed -E 's/ //g')
ELEMENT_NAME=$(echo $ELEMENT_NAME | sed -E 's/ //g')
TYPE=$(echo $TYPE | sed -E 's/ //g')
ATOMIC_MASS=$(echo $ATOMIC_MASS | sed -E 's/ //g')
MELTING_POINT=$(echo $MELTING_POINT | sed -E 's/ //g')
BOILING_POINT=$(echo $BOILING_POINT | sed -E 's/ //g')


echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."


# The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.



# echo "$($PSQL "\d properties")"
# echo "$($PSQL "\d elements")"
# echo "$($PSQL "select * from properties")"
# echo "$($PSQL "select * from elements")"



