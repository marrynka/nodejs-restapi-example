# Basic example of REST API for book management with Node.js, Express, MongoDB and TypeScript

This is a simple API that saves information about books.

The default URL is: *http://localhost:3000*

+ GET all books

```
Send GET request to http://localhost:3000/books/
```
+ GET one book with ID bookId
```
Send GET request to http://localhost:3000/books/bookId
```
+ ADD new book
```
Send POST request to http://localhost:3000/book with params: title, description, authors(array)
```
+ UPDATE a book
```
Send PUT request to http://localhost:3000/book with params: title, description, authors(array)
```
+ DELETE a book with ID bookId
```
Send DELETE request to http://localhost:3000/book/bookId
```
+ SEARCH in book titles
```
Send GET request to http://localhost:3000/books/searchPhrase
```
