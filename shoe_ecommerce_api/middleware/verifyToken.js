const jwt = require('jsonwebtoken')

const verifyToken = (req, res, next) => {
  const authHeader = req.headers.authorization
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized' })
  }

  const token = authHeader.split(' ')[1]

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET)

    // Attach full payload if you need roles, etc.
    req.user = decoded

    next()
  } catch (err) {
    console.error('Token verification error:', err.message)
    res.status(401).json({ error: 'Invalid token' })
  }
}

module.exports = verifyToken
