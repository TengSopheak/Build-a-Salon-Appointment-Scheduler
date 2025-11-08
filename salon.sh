#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e "\nWelcome to My Salon, how can I help you?"

MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "\n#) <service>"
  echo "1) cut"
  echo "2) style"
  echo "3) makeup"
  echo "4) exit"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) CUT_OPTION ;;
    2) STYLE_OPTION ;;
    3) MAKEUP_OPTION ;;
    4) EXIT ;;
    *) MENU "I could not find that service. What would you like today?" ;;
  esac
}

CUT_OPTION() {
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'" | sed -r 's/^ *| *$//g')
  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  # get service_time
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
  INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(phone, name, time) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME', '$SERVICE_TIME')")
}

STYLE_OPTION() {
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  INSERT_NEW_CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'" | sed -r 's/^ *| *$//g')
  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  # get service_time
  echo -e "\nWhat time would you like your style, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo -e "\nI have put you down for a style at $SERVICE_TIME, $CUSTOMER_NAME."
  INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(phone, name, time) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME', '$SERVICE_TIME'")
}

MAKEUP_OPTION() {
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'" | sed -r 's/^ *| *$//g')
  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi
  # get service_time
  echo -e "\nWhat time would you like your makeup, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo -e "\nI have put you down for a makeup at $SERVICE_TIME, $CUSTOMER_NAME."
  INSERT_NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(phone, name, time) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME', '$SERVICE_TIME'")
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MENU