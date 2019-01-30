#!/bin/sh

URL=http://127.0.0.1:3000
BOOK_TITLE="Picture of Dorian Gray"
BOOK_TITLE_UPDATED="Picture of Dorian Orange"
AUTHOR="Oscar Wilde"

TEST_OK=0

#Test index page returns ok

STATUS_CODE=`curl -s -o /dev/null -w "%{http_code}" $URL`

if [[ $STATUS_CODE != "200" ]]; then
  echo "Test 1 ERROR: Index page broken"
else
  echo "Test 1 OK: Index page ok - response code 200."
  ((TEST_OK = TEST_OK + 1))
fi

#Test adding new book

ID=`curl -s -d "title=$BOOK_TITLE&authors=$AUTHOR" -X POST $URL/book \
    | python -c "import sys, json; print(json.load(sys.stdin)['_id'])"`
ID_LENGTH=${#ID}
if [[ $ID_LENGTH != 24 ]]; then
  echo "Test 2 ERROR: Problem with adding the book."
else
  echo "Test 2 OK: Added book with $ID ID"
  ((TEST_OK = TEST_OK + 1))
fi

#Test the added book title is correct

RETURNED_TITLE=`curl -s -X GET $URL/book/$ID \
    | python -c "import sys, json; print(json.load(sys.stdin)['title'])"`
if [[ $RETURNED_TITLE != $BOOK_TITLE ]]; then
  echo "Test 3 ERROR: Didn't return the same book title."
else
  echo "Test 3 OK: $RETURNED_TITLE  is the title of the requested book."
  ((TEST_OK = TEST_OK + 1))
fi

#Test book updating

ID_RETURNED=`curl -s -d "title=$BOOK_TITLE_UPDATED" -X PUT $URL/book/$ID \
    | python -c "import sys, json; print(json.load(sys.stdin)['_id'])"`
if [[ $ID_RETURNED != $ID ]]; then
  echo "Test 4 ERROR: Book data wasn't updated correctly."
else
  echo "Test 4 OK: Book update ok."
  ((TEST_OK = TEST_OK + 1))
fi

#Test book updated

RETURNED_TITLE=`curl -s -X GET $URL/book/$ID \
    | python -c "import sys, json; print(json.load(sys.stdin)['title'])"`
if [[ $RETURNED_TITLE != $BOOK_TITLE_UPDATED ]]; then
  echo "Test 5 ERROR: Didn't return the updated book title."
else
  echo "Test 5 OK: $RETURNED_TITLE  is the updated title of the requested book."
  ((TEST_OK = TEST_OK + 1))
fi

#Test book deleting

DELETED_MESSAGE=`curl -s -X DELETE $URL/book/$ID \
    | python -c "import sys, json; print(json.load(sys.stdin)['message'])"`
if [[ $DELETED_MESSAGE != *"Successfully deleted"* ]]; then
  echo "Test 6 ERROR: Book not deleted"
else
  echo "Test 6 OK: Book deleted"
  ((TEST_OK = TEST_OK + 1))
fi

#Test book deleted

RETURNED_VALUE=`curl -s -X GET $URL/book/$ID`
if [[ $RETURNED_VALUE != "null" ]]; then
  echo "Test 6 ERROR: Book still in the db."
else
  echo "Test 6 OK: Book no longer in the db."
  ((TEST_OK = TEST_OK + 1))
fi

echo " $TEST_OK tests out of 7 passed."
