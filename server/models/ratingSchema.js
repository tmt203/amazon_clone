const mongoose = require('mongoose');

const ratingSchema = mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  rating: {
    type: Number,
    required: true
  }
});

module.exports = ratingSchema;