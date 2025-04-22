const User = require('../models/User')
const jwt = require('jsonwebtoken')
const bcrypt = require('bcryptjs')
const { validateRegister, validateLogin } = require('../utils/validators')

// Token generator
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: '7d' })
}

// Register
const register = async (req, res) => {
  const error = validateRegister(req.body)
  if (error) return res.status(400).json({ error })

  const { userName, email, password, phone, fullName, gender, dob, addresses, profileImage } = req.body

  const existing = await User.findOne({ email })
  if (existing) return res.status(400).json({ error: 'Email already in use' })

  const hashed = await bcrypt.hash(password, 10)
  const user = await User.create({
    userName,
    email,
    password: hashed,
    phone: phone || null,
    fullName: fullName || null,
    gender: gender || null,
    dob: dob ? new Date(dob) : null,
    addresses: addresses || [],
    profileImage: profileImage || null
  })

  const token = generateToken(user._id)

  console.log(`User registered: ${email}`)

  res.status(201).json({
    message: 'User registered successfully',
    user: {
      id: user._id,
      userName: user.userName,
      email: user.email,
      phone: user.phone,
      addresses: user.addresses,
      fullName: user.fullName,
      profileImage: user.profileImage,
      gender: user.gender,
      dob: user.dob
    },
    token
  })
}

// Login
const login = async (req, res) => {
  const error = validateLogin(req.body)
  if (error) return res.status(400).json({ error })

  const { email, password } = req.body
  const user = await User.findOne({ email })
  if (!user) return res.status(400).json({ error: 'Invalid credentials' })

  const match = await bcrypt.compare(password, user.password)
  if (!match) return res.status(400).json({ error: 'Invalid credentials' })

  const token = generateToken(user._id)

  console.log(`User logged in: ${email}`)

  res.status(200).json({
    message: 'Login successful',
    user: {
      id: user._id,
      userName: user.userName,
      email: user.email,
      phone: user.phone,
      addresses: user.addresses,
      fullName: user.fullName,
      profileImage: user.profileImage,
      gender: user.gender,
      dob: user.dob
    },
    token
  })
}

// Forgot Password
const forgotPassword = async (req, res) => {
  const { email, newPassword } = req.body
  if (!email || !newPassword) return res.status(400).json({ error: 'Email and new password required' })

  const user = await User.findOne({ email })
  if (!user) return res.status(404).json({ error: 'User not found' })

  const hashed = await bcrypt.hash(newPassword, 10)
  user.password = hashed
  await user.save()

  console.log(`Password updated for: ${email}`)

  res.status(200).json({ message: 'Password updated successfully' })
}

// Get User Profile
const getUser = async (req, res) => {
  const userId = req.user.id  // Assuming you're using JWT middleware to authenticate users

  try {
    const user = await User.findById(userId)
    if (!user) return res.status(404).json({ error: 'User not found' })

    console.log(`User fetched: ${user.email}`)

    res.status(200).json({
      message: 'User profile fetched successfully',
      user: {
        id: user._id,
        userName: user.userName,
        email: user.email,
        phone: user.phone,
        addresses: user.addresses,
        fullName: user.fullName,
        profileImage: user.profileImage,
        gender: user.gender,
        dob: user.dob
      }
    })
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch user profile' })
  }
}

// Update Profile
const updateProfile = async (req, res) => {
  const userId = req.user.id
  const updates = req.body

  try {
    const user = await User.findByIdAndUpdate(userId, updates, { new: true })
    if (!user) return res.status(404).json({ error: 'User not found' })

    console.log(`User profile updated: ${user.email}`)

    res.status(200).json({
      message: 'Profile updated successfully',
      user: {
        id: user._id,
        userName: user.userName,
        email: user.email,
        phone: user.phone,
        addresses: user.addresses,
        fullName: user.fullName,
        profileImage: user.profileImage,
        gender: user.gender,
        dob: user.dob
      }
    })
  } catch (err) {
    res.status(500).json({ error: 'Failed to update profile' })
  }
}

module.exports = {
  register,
  login,
  forgotPassword,
  getUser,
  updateProfile,
}
