#!/bin/bash
PSQL="psql -U freecodecamp periodic_table -X --tuples-only -c"
# remove the non existent element atomic_number 1000
#REMOVE_ELEMENT=$($PSQL "DELETE FROM elements WHERE atomic_number=1000")
#DROP_COLUMN=$($PSQL "ALTER TABLE properties DROP COLUMN IF EXISTS type")

#check if argument is empty
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  # if yes output message Please provide an element as an argument.
else
  # check the argument: if it's a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # search for the input in atomic_number column in database.
    DB_SEARCH=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    #search for the input in name or symbol column in database.
    DB_SEARCH=$($PSQL "SELECT atomic_number, name, symbol, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
  fi
  
  #if the input argument not found in database
  if [[ -z $DB_SEARCH ]]
  then
    # message not found
    echo "I could not find that element in the database."
  else
    #split the search into various variables and output in required format.
    echo $DB_SEARCH | while read A BAR B BAR C BAR D BAR E BAR F BAR G
    do
      echo "The element with atomic number $A is $B ($C). It's a $D, with a mass of $E amu. $B has a melting point of $F celsius and a boiling point of $G celsius."
    done
  fi

fi
