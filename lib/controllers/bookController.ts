import * as mongoose from 'mongoose';
import { BookSchema } from '../models/bookSchema';
import { Request, Response } from 'express';

const Book = mongoose.model('Book', BookSchema);


function handleDbResponse(res: Response): (err, book) => void {
  return function(err, book) {
    if (err) {
      res.send(err);
    }
      res.json(book);
  }
}

export class BookController {

  public addNewBook(req: Request, res: Response) {
    let newBook = new Book(req.body);

    newBook.save(handleDbResponse(res));
  }

  public getBooks(req: Request, res: Response) {
    Book.find({}, handleDbResponse(res));
  }

  public getBooksByName(req: Request, res: Response) {
    Book.find(
      { title: new RegExp(".*" + req.params.bookTitle + ".*", "i") },
      handleDbResponse(res)
    );
  }
  public getBookWithID(req: Request, res: Response) {
    Book.findById(req.params.bookId, handleDbResponse(res));
  }

  public updateBook(req: Request, res: Response) {
    Book.findOneAndUpdate(
      { _id: req.params.bookId },
      req.body,
      { new: true },
      handleDbResponse(res)
    );
  }

  public deleteBook(req: Request, res: Response) {
    Book.remove({ _id: req.params.bookId }, (err, book) => {
      if (err) {
        res.send(err);
      }
      res.json({
        message: 'Successfully deleted book with id: '
          + req.params.bookId
      });
    });
  }
}
