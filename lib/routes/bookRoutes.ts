import {Request, Response} from "express";
import { BookController } from "../controllers/bookController";


export class Routes {

  public bookController: BookController = new BookController();

  public routes(app): void {
    app.route('/')
      .get((req: Request, res: Response) => {
        res.status(200).send({
            message: 'Hello, this is index page and doesn\'t do much. ' +
              'But anyway, welcome to the book management API.'
        })
      }
    );

    app.route('/books/:bookTitle?')
      .get((req: Request, res: Response) => {
        if (!req.params.bookTitle) {
          return this.bookController.getBooks(req, res);
        } else {
          return this.bookController.getBooksByName(req, res);
        }
      }
    );

    app.route('/book/:bookId?')
      .post(this.bookController.addNewBook)
      .get(this.bookController.getBookWithID)
      .put(this.bookController.updateBook)
      .delete(this.bookController.deleteBook);
  }
}
