const User = require("../models/userModel");
const Product = require("../models/productModel");
const factory = require("../controllers/handlerFactory");
const AppError = require("../utils/appError");

const addToCart = catchAsync(async (req, res, next) => {
  const { productId } = req.body;
  const product = await Product.findById(productId);
  const user = req.user;

  if (user.cart.length === 0) {
    user.cart.push({ product, quantity: 1 });
  } else {
    let isProductExisted = false;
    let i = 0;

    for (; i < user.cart.length; i++) {
      if (user.cart[i].product._id.toString() === productId) {
        isProductExisted = true;
        break;
      }
    }

    if (isProductExisted) {
      user.cart[i].quantity++;
    } else {
      user.cart.push({ product, quantity: 1 });
    }
  }

  await user.save({ validateBeforeSave: false });

  return res.status(200).json({
    status: "success",
    message: "Thêm sản phẩm hoàn tất.",
    data: user,
  });
});

const removeFromCart = catchAsync(async (req, res, next) => {
  const { productId } = req.body;
  const product = await Product.findById(productId);
  const user = req.user;

  if (user.cart.length === 0 || !product) {
    return next(new AppError("Sản phẩm này chưa có trong giỏ hàng.", 404));
  }

  let i = 0;

  for (; i < user.cart.length; i++) {
    if (user.cart[i].product._id.toString() === productId) {
      break;
    }
  }

  if (user.cart[i].quantity === 1) {
    user.cart.splice(i, 1);
  } else {
    user.cart[i].quantity--;
  }

  await user.save({ validateBeforeSave: false });

  return res.status(200).json({
    status: "success",
    message: "Xóa sản phẩm hoàn tất.",
    data: user,
  });
});

const filterObj = (obj, ...allowedFields) => {
  const newObj = {};
  Object.keys(obj).forEach((el) => {
    if (allowedFields.includes(el)) newObj[el] = obj[el];
  });

  return newObj;
};

module.exports = {
  addToCart,
  removeFromCart,
  getMe: (req, res, next) => {
    req.params.id = req.user.id;
    next();
  },
  updateMe: catchAsync(async (req, res, next) => {
    // Return error if user POSTs password data
    if (req.body.password || req.body.passwordConfirm) {
      return next(
        new AppError(
          "This route is not for password updates. Please use /updateMyPassword.",
          400
        )
      );
    }

    // Filtered out unwanted fields names that are not allowed to be updated
    const filteredBody = filterObj(req.body, "name", "email", "address");
    if (req.file) filteredBody.photo = req.file.filename;

    // Update user document
    const updatedUser = await User.findByIdAndUpdate(
      req.user._id,
      filteredBody,
      {
        new: true,
        runValidators: true,
      }
    );

    res.status(200).json({
      status: "success",
      data: updatedUser,
    });
  }),
  getAllUsers: factory.getAll(User),
  getUser: factory.getOne(User),

  // Do NOT update passwords with this!
  updateUser: factory.updateOne(User),
  deleteUser: factory.deleteOne(User),
};
