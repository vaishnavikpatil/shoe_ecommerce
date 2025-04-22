const express = require('express')
const router = express.Router()
const {
  register,
  login,
  forgotPassword,
  getUser,
  updateProfile
} = require('../controllers/authController')

const verifyToken = require('../middleware/verifyToken')


// Auth routes
router.post('/register', register)
router.post('/login', login)
router.post('/forgot-password', forgotPassword)
router.get('/profile', verifyToken, getUser)
router.put('/update-profile', verifyToken, updateProfile)

module.exports = router
