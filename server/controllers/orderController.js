const catchAsync = require("../utils/catchAsync");
const factory = require("../controllers/handlerFactory");
const Order = require("../models/orderModel");
const Product = require("../models/productModel");
const User = require("../models/userModel");

const placeOrder = catchAsync(async (req, res, next) => {
  const { cart, totalPrice, address } = req.body;
  let products = [];

  // Decrease product's quantity corresponding to the ones in cart
  for (let i = 0; i < cart.length; i++) {
    let product = await Product.findById(cart[i].product._id);
    if (product.quantity >= cart[i].quantity) {
      product.quantity -= cart[i].quantity;
      products.push({ product, quantity: cart[i].quantity });
      await product.save();
    } else {
      return res.status(400).json({
        status: "fail",
        message: `${product.name} không thỏa số lượng yêu cầu.`,
      });
    }
  }

  // Empty the user's cart
  await User.findByIdAndUpdate(req.user._id, { cart: [] });

  // Create new order
  const order = await Order.create({
    products,
    totalPrice,
    address,
    user: req.user,
  });

  res.status(200).json({
    status: "success",
    data: order,
  });
});

const getAnalytics = catchAsync(async (req, res, next) => {
  const orders = await Order.find();
  let totalEarnings = 0;

  for (let i = 0; i < orders.length; i++) {
    for (let j = 0; j < orders[i].products.length; j++) {
      totalEarnings +=
        orders[i].products[j].quantity * orders[i].products[j].product.price;
    }
  }

  const mobilesEarnings = await productSalesByCategory("Điện thoại");
  const essentialsEarnings = await productSalesByCategory("Yếu phẩm");
  const deviceEarnings = await productSalesByCategory("Thiết bị");
  const booksEearnings = await productSalesByCategory("Sách");
  const fashionEarnings = await productSalesByCategory("Thời trang");

  const earnings = {
    totalEarnings,
    mobilesEarnings,
    essentialsEarnings,
    deviceEarnings,
    booksEearnings,
    fashionEarnings,
  };

  res.status(200).json({
    status: "success",
    data: earnings,
  });
});

// Support funcs
async function productSalesByCategory(category) {
  const categoryEarnings = await Order.aggregate([
    {
      $unwind: "$products", // Deconstruct the products array
    },
    {
      $lookup: {
        from: "products", // Products collection name is "products"
        localField: "products.product",
        foreignField: "_id",
        as: "product", // Rename the result array as "product"
      },
    },
    {
      $unwind: "$product", // Deconstruct the product array
    },
    {
      $match: {
        "product.category": category, // Filter products by category
      },
    },
    {
      $group: {
        _id: null,
        earnings: {
          $sum: { $multiply: ["$product.price", "$products.quantity"] },
        }, // Calculate total earnings
      },
    },
  ]);

  // Extract earnings from the result
  const earnings =
    categoryEarnings.length > 0 ? categoryEarnings[0].earnings : 0;

  return earnings;
}

const test = catchAsync(async (req, res, next) => {
  const categoryEarnings = await Order.aggregate([
    {
      $unwind: "$products", // Deconstruct the products array
    },
    {
      $lookup: {
        from: "products", // Assuming your products collection name is "products"
        localField: "products.product",
        foreignField: "_id",
        as: "product", // Rename the result array as "product"
      },
    },
    {
      $unwind: "$product", // Deconstruct the product array
    },
    {
      $match: {
        "product.category": "Điện thoại", // Filter products by category
      },
    },
    {
      $group: {
        _id: null,
        earnings: {
          $sum: { $multiply: ["$product.price", "$products.quantity"] },
        }, // Calculate total earnings
      },
    },
  ]);

  // Extract earnings from the result
  const earnings =
    categoryEarnings.length > 0 ? categoryEarnings[0].earnings : 0;

  return res.json(earnings);
});

module.exports = {
  test,
  placeOrder,
  getAnalytics,
  getAllOrders: factory.getAll(Order),
  updateOrder: factory.updateOne(Order),
};
