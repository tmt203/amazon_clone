const router = require("express").Router();
const orderController = require("../controllers/orderController");
const { protect, restrictTo } = require("../controllers/authController");


router.use(protect);
router.post("/place-order", restrictTo('user'), orderController.placeOrder);
router.get("/analytics", restrictTo('admin'), orderController.getAnalytics);
router.get("/test", orderController.test);

router.get("/", orderController.getAllOrders);
router.patch("/:id", orderController.updateOrder);

module.exports = router;
