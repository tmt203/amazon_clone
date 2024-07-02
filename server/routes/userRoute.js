const router = require('express').Router();
const userController = require('../controllers/userController');
const authController = require('../controllers/authController');

// Protect all routes after this middleware
router.use(authController.protect);

router.post("/add-to-cart", userController.addToCart);
router.post("/remove-from-cart", userController.removeFromCart);

router.get("/me", userController.getMe, userController.getUser);
router.patch("/updateMe", userController.updateMe);

module.exports = router;