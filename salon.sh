#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e "\nWelcome to My Salon, how can I help you?\n"

SERVICE_LIST=$($PSQL "SELECT service_id,name FROM services ORDER BY service_id")
echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
do
  echo "$SERVICE_ID) $NAME"
done
read SERVICE_ID_SELECTED

GET_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")

while [[ -z $GET_SERVICE_ID ]]
do
  echo -e "\nI could not find that service. What would you like today?"
  echo "$SERVICE_LIST" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  GET_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
done

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$GET_SERVICE_ID")

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

GET_PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $GET_PHONE_NUMBER ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

  ENTER_DATA=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
fi

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
read SERVICE_TIME

MAKE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$GET_SERVICE_ID,'$SERVICE_TIME')")

echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME.\n"
