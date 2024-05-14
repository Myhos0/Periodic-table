#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

REGEX='s/^[ \t]*//;s/[ \t]*$//'

if [[ -z "$1" ]]
then
  echo "Please provide an element as an argument."
  exit
fi

DATA_ELEMENT(){
  if [[ -z $ATOMIC_NUMBER ]]; then
    echo "I could not find that element in the database."
    exit
  fi
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER" | sed "$REGEX")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER" | sed "$REGEX")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER" | sed "$REGEX")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID" | sed "$REGEX")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER" | sed "$REGEX")
  MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER" | sed "$REGEX")
  BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER" | sed "$REGEX")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  exit
}

if [[ $1 =~ ^[0-9]+$ ]]; then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements where atomic_number = $1" | sed "$REGEX")
  DATA_ELEMENT $ATOMIC_NUMBER
fi

if [[ $1 =~ ^[A-Z]{1}[a-zA-Z]?$ ]];then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements where symbol = '$1'" | sed "$REGEX")
  DATA_ELEMENT $ATOMIC_NUMBER
fi

if [[ $1 =~ ^[A-Z][a-z]*$ ]];then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements where  name = '$1'" | sed "$REGEX")
  DATA_ELEMENT $ATOMIC_NUMBER
fi

echo "I could not find that element in the database."
