#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWelcome to My Salon, how can I help you?\n"

  # tampilkan daftar services format: #) <service>
  SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
  echo "$SERVICES_LIST" | while IFS="|" read SERVICE_ID NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  # input service id
  read SERVICE_ID_SELECTED

  # validasi service_id
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
    return
  fi

  # input phone
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # cek customer
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

  # kalau belum ada, minta nama dan insert
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    $PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');" > /dev/null
  fi

  # ambil customer_id (setelah insert atau kalau sudah ada)
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

  # input waktu
  echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | xargs), $(echo $CUSTOMER_NAME | xargs)?"
  read SERVICE_TIME

  # insert appointment
  $PSQL "INSERT INTO appointments(customer_id, service_id, time)
         VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');" > /dev/null

  # output final sesuai requirement (tanpa spasi aneh)
  echo -e "\nI have put you down for a $(echo $SERVICE_NAME | xargs) at $SERVICE_TIME, $(echo $CUSTOMER_NAME | xargs)."
}

MAIN_MENU
