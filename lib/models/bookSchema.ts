import * as mongoose from 'mongoose';

const Schema = mongoose.Schema;

export const BookSchema = new Schema({
    title: {
        type: String,
        required: [true, 'Book title is required.']
    },
    description: {
        type: String,
        required: false
    },
    authors: {
        type: [String],
        validate : {
          validator : function(array) {
            return array.length > 0;
          },
          message: 'At least one author per book is required.'
        }
    },
    created_date: {
        type: Date,
        default: Date.now
    }
});
