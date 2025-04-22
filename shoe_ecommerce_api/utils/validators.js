const validateRegister = ({ userName, email, password }) => {
  if (!userName || !email || !password) return 'All fields are required'
  const emailRegex = /\S+@\S+\.\S+/
  if (!emailRegex.test(email)) return 'Invalid email'
  if (password.length < 6) return 'Password must be at least 6 characters'
  return null
}

const validateLogin = ({ email, password }) => {
  if (!email || !password) return 'Email and password required'
  return null
}
const validateProduct = (data) => {
  if (!data.name || !data.brandname || !data.price) return 'Name, brandname and price are required'
  if (typeof data.price !== 'number') return 'Price must be a number'
  return null
}



module.exports = { validateRegister, validateLogin,validateProduct }
