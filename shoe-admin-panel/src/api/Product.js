import axios from 'axios';

const BASE_API_URL = 'baseurl/products';

// Fetch products with pagination
export const getProducts = async () => {
  try {
    const response = await axios.get(`${BASE_API_URL}/all`, {}); // Simple GET request
    console.log("Full Response:", response); // Log the whole response object
    
    // Access the 'data' field from the response
    const products = response.data;
    
    console.log("Products Data:", products); // Log just the data for clarity
    
    return products; // Return the products data directly
  } catch (error) {
    console.error("Error fetching products:", error.response || error.message || error); // Improved error logging
    throw error; // Rethrow the error for further handling
  }
};

// Add a new product
export const addProduct = async (productData) => {
  try {
    const response = await axios.post(BASE_API_URL, productData);
    console.log("Add Product Response:", response);
    
    return response.data;
  } catch (error) {
    console.error("Error adding product:", error.response || error.message || error);
    throw error;
  }
};

// Update a product by ID
export const updateProduct = async (productId, productData) => {
  try {
    const response = await axios.put(`${BASE_API_URL}/${productId}`, productData);
    console.log("Update Response:", response);
    
    return response.data;
  } catch (error) {
    console.error("Error updating product:", error.response || error.message || error);
    throw error;
  }
};

// Remove a product by ID
export const removeProduct = async (productId) => {
  try {
    const response = await axios.delete(`${BASE_API_URL}/${productId}`);
    console.log("Delete Response:", response);
    
    return response.data;
  } catch (error) {
    console.error("Error removing product:", error.response || error.message || error);
    throw error;
  }
};

// Parse CSV text to an array of product objects
function parseCSVToJSON(csvText) {
  try {
    // Split by lines and filter empty ones
    const lines = csvText.split('\n').filter(line => line.trim());
    
    if (lines.length < 2) {
      throw new Error("CSV must contain a header row and at least one data row");
    }
    
    // Extract header row
    const headers = lines[0].split(',').map(header => header.trim());
    
    // Process data rows
    const products = lines.slice(1).map((line, index) => {
      // Handle quoted values with commas inside
      const values = [];
      let inQuotes = false;
      let currentValue = '';
      
      for (let i = 0; i < line.length; i++) {
        const char = line[i];
        
        if (char === '"' && (i === 0 || line[i-1] !== '\\')) {
          inQuotes = !inQuotes;
        } else if (char === ',' && !inQuotes) {
          values.push(currentValue.trim());
          currentValue = '';
        } else {
          currentValue += char;
        }
      }
      
      // Add the last value
      values.push(currentValue.trim());
      
      // Create product object from values
      const product = {};
      
      headers.forEach((header, idx) => {
        if (idx < values.length) {
          const value = values[idx];
          
          // Handle special fields
          if (header === 'sizes' || header === 'images' || header === 'color') {
            // Split by semicolons for array values
            product[header] = value ? value.split(';').map(item => item.trim()) : [];
          } 
          else if (header === 'price' || header === 'discount') {
            // Convert to number
            product[header] = value ? parseFloat(value) : 0;
          }
          else if (header === 'stock') {
            // Convert to integer
            product[header] = value ? parseInt(value, 10) : 0;
          }
          else if (header === 'isFeatured' || header === 'isActive' || 
                   header === 'isPopular' || header === 'isNew') {
            // Convert to boolean
            product[header] = value.toLowerCase() === 'true';
          }
          else {
            // Regular string value
            product[header] = value;
          }
        }
      });
      
      return product;
    });
    
    return products;
  } catch (error) {
    console.error("CSV Parsing Error:", error);
    throw new Error(`Failed to parse CSV: ${error.message}`);
  }
}

// Bulk upload products
export const bulkUploadProducts = async (csvText) => {
  try {
    // Parse CSV text to JSON array
    const products = parseCSVToJSON(csvText);
    console.log("Parsed products:", products);
    
    // Send the products array to the API
    const response = await axios.post(`${BASE_API_URL}/bulk`, { products });
    console.log("Bulk Upload Response:", response);
    
    return response.data;
  } catch (error) {
    console.error("Error bulk uploading products:", error.response?.data || error.message || error);
    throw error;
  }
};