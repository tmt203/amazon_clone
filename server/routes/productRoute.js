const router = require("express").Router();
const { protect, restrictTo } = require("../controllers/authController");
const productController = require("../controllers/productController");

router.use(protect);
router.get("/search/:name", productController.searchProducts);
router.post("/rate-product", productController.ratingProduct);
router.get("/deal-of-day", productController.dealOfDay);

router.post("/", restrictTo("admin"), productController.addProduct);
router.get("/", productController.getAllProducts);
router.delete("/:id", restrictTo("admin"), productController.deleteProduct);

module.exports = router;
