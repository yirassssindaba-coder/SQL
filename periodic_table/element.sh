#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

INPUT="$1"

# cari berdasarkan atomic_number (angka) atau symbol/name (string)
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  ELEMENT_ROW=$($PSQL "
    SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
    FROM elements e
    JOIN properties p USING(atomic_number)
    JOIN types t USING(type_id)
    WHERE e.atomic_number = $INPUT;
  ")
else
  # match symbol atau name (case-insensitive)
  ELEMENT_ROW=$($PSQL "
    SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
    FROM elements e
    JOIN properties p USING(atomic_number)
    JOIN types t USING(type_id)
    WHERE LOWER(e.symbol) = LOWER('$INPUT')
       OR LOWER(e.name) = LOWER('$INPUT');
  ")
fi

if [[ -z $ELEMENT_ROW ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MP BP <<< "$ELEMENT_ROW"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
# element lookup script
# database connection setup
# refactor structure
# finalize project
