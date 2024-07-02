const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  products: [{
    product: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Product',
    },
    quantity: {
      type: Number,
      required: true,
    }
  }],
  totalPrice: {
    type: Number,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  status: {
    type: Number,
    default: 0 // 0 - pending, 1 - completed, 2 - received, 3 - delivered
  }
}, {
  timestamps: true,
  toJSON: {
    virtuals: true
  }
});

orderSchema.virtual('id').get(function () {
  return this._id.toHexString();
});

orderSchema.pre(/^find/, function (next) {
  this.populate('products.product');
  next();
});

const Order = mongoose.model('Order', orderSchema);

module.exports = Order;