const factory = require("../controllers/handlerFactory");
const Product = require("../models/productModel");
const AppError = require("../utils/appError");

const searchProducts = catchAsync(async (req, res, next) => {
  const products = await Product.find({
    name: { $regex: req.params.name, $options: "i" },
  });

  res.status(200).json({
    status: "success",
    data: products,
  });
});

const ratingProduct = catchAsync(async (req, res, next) => {
  const { productId, rating } = req.body;
  let product = await Product.findById(productId);

  // Check if product still exists 
  if (!product) {
    return next(new AppError('Không tìm thấy sản phẩm với ID này.', 404));
  }

  // Retrieve the rating of product accompany with the requested user
  for (let i = 0; i < product.ratings.length; i++) {    
    if (product.ratings[i].userId.toString() === req.user.id) {
      // Delete the current rating
      product.ratings.splice(i, 1);
      break;
    }
  }

  const ratingSchema = {
    userId: req.user.id,
    rating,
  }

  product.ratings.push(ratingSchema);
  product = await product.save();

  res.status(200).json({
    status: 'success',
    data: product
  });
});

const dealOfDay = catchAsync(async (req, res, next) => {
  let products = await Product.find();

  products.sort((a,b) => {
    let aSum = 0;
    let bSum = 0;

    for (let i = 0; i < a.ratings.length; i++) {
      aSum += a.ratings[i].rating;
    }

    for (let j = 0; j < b.ratings.length; j++) {
      bSum += b.ratings[j].rating;
    }

    return aSum < bSum ? 1 : -1;
  });

  res.status(200).json({
    status: 'success',
    data: products[0],
  });
});

const addProduct = factory.createOne(Product);
const getAllProducts = factory.getAll(Product);
const deleteProduct = factory.deleteOne(Product);

module.exports = {
  addProduct,
  getAllProducts,
  deleteProduct,
  searchProducts,
  ratingProduct,
  dealOfDay
  
};
