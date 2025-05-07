const express = require('express');
const router = express.Router();
const {
  addToCart,
  removeFromCart,
  getCart,
  placeOrder,
  getMyOrders,
  cancelOrder,
  updateOrder,
  getAllOrders,
  getOrdersByUserId
} = require('../controllers/orderController');

const verifyToken = require('../middleware/verifyToken'); 

// Cart
router.post('/cart/add', verifyToken, addToCart);
router.delete('/cart/remove/:productId', verifyToken, removeFromCart);
router.get('/cart', verifyToken, getCart);

// Orders
router.post('/order/place', verifyToken, placeOrder);
router.get('/orders', verifyToken, getMyOrders);
router.post('/order/cancel', verifyToken, cancelOrder);

// Extra order actions
router.get('/orders/all', getAllOrders); 
router.patch('/:orderId', updateOrder);

module.exports = router;
