const express = require('express');
const router = express.Router();
const {
  addProduct,
  updateProduct,
  removeProduct,
  getProductList,
  getProductDetails,
  filterProduct,
  getPopularProducts,
  getNewArrivals,
  bulkUploadProducts
} = require('../controllers/productController');

// Routes without verifyToken middleware
router.post('/', addProduct);
router.put('/:id', updateProduct);
router.delete('/:id', removeProduct);
router.get('/all', getProductList);
router.get('/filter', filterProduct);
router.get('/popular', getPopularProducts);
router.get('/newArrivals', getNewArrivals);
router.get('/:id', getProductDetails);

// Bulk upload endpoint - no token verification needed
router.post('/bulk-upload', bulkUploadProducts);

module.exports = router;