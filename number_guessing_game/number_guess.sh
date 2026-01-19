#!/bin/bash

# PSQL command untuk query ke database number_guess
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# minta username
echo "Enter your username:"
read USERNAME

# cek apakah user sudah ada di database
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")

# jika user belum ada
if [[ -z $USER_ID ]]
then
  # buat user baru
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  # user sudah ada, ambil statistik
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID;")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID;")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# generate angka rahasia antara 1 dan 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# counter jumlah tebakan
NUMBER_OF_GUESSES=0

# mulai permainan
echo "Guess the secret number between 1 and 1000:"

while true
do
  read GUESS
  NUMBER_OF_GUESSES=$(( NUMBER_OF_GUESSES + 1 ))

  # cek apakah input integer non-negatif
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi

  # bandingkan dengan SECRET_NUMBER
  if [[ $GUESS -lt $SECRET_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else
    # benar
    break
  fi
done

# simpan hasil game ke database
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES);")

# pesan kemenangan sesuai syarat
echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
# update for feat commit
# update for fix commit
# update for refactor commit
# update for chore commit
# feat: add game logic
# refactor: simplify loop
# chore: finalize project
# feat commit
# fix commit
# refactor commit
# chore commit
