const express = require('express')
const router = express.Router()
const {
  addProduct,
  getProductList,
  getProductDetails,
  filterProduct,
  getPopularProducts,
  getNewArrivals
} = require('../controllers/productController')
const verifyToken = require('../middleware/verifyToken')

// Routes
router.post('/', verifyToken, addProduct)
router.get('/all', getProductList)
router.get('/filter', filterProduct)
router.get('/popular', getPopularProducts)
router.get('/newArrivals', getNewArrivals)
router.get('/:id', getProductDetails)

module.exports = router
