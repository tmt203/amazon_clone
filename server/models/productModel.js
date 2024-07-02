const mongoose = require('mongoose');
const ratingSchema = require('./ratingSchema');

const productSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true,
    trim: true
  },
  images: [
    { type: String, required: true }
  ],
  price: {
    type: Number,
    required: true
  },
  quantity: {
    type: Number,
    required: true
  },
  category: {
    type: String,
    required: true
  },
  ratings: [ratingSchema]
}, {
  timestamps: true,
  toJSON: {
    virtuals: true
  }
});

productSchema.virtual('id').get(function () {
  return this._id.toHexString();
});

const Product = mongoose.model('Product', productSchema);

module.exports = Product;