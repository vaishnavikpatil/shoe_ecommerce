const express = require('express')
const router = express.Router()
const {
  addToCart,
  removeFromCart,
  getCart,
  placeOrder,
  getMyOrders,
  cancelOrder
} = require('../controllers/orderController')

const verifyToken = require('../middleware/verifyToken') 

// Cart routes
router.post('/cart/add', verifyToken, addToCart)
// Route to remove product from cart (using DELETE)
router.delete('/cart/remove/:productId', verifyToken, removeFromCart);

router.get('/cart', verifyToken, getCart)

// Order routes
router.post('/order/place', verifyToken, placeOrder)
router.get('/orders', verifyToken, getMyOrders)
router.post('/order/cancel', verifyToken, cancelOrder)

module.exports = router
