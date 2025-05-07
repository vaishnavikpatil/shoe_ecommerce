# Full-Stack E-Commerce App

**Full-Stack E-Commerce App** is a complete online shopping platform built using **Flutter** for the frontend, **Node.js with Express** for the backend, **MongoDB** for the database, and **AWS** for hosting and image storage. The goal was to create a production-ready app with clean architecture and best practices.

## Features

### User App (Flutter)
- **User Authentication:** Sign up, login, and manage your account with secure authentication (JWT and bcrypt).
- **Product Catalog:** Browse all products, check out popular items, or view new arrivals.
- **Search and Filters:** Search for products and filter by price, category, and other criteria.
- **Product Details:** View detailed product information (images, descriptions, pricing) and add to cart or favorites.
- **Cart Management:** Review cart items, change quantities, remove items, and place orders.
- **User Profile:** Update personal information and reset password.
- **Responsive Design:** Optimized for a fast, smooth user experience with Flutter's cross-platform capabilities.

### Admin Panel (React)
- **Inventory Management:** Add, edit, or delete products.
- **Order Management:** View and update order statuses:
  - Order Accepted, Processing, In Transit, Shipped, Delivered
  - Optional statuses: Cancelled, Returned, Exchanged
- **User Management:** View user list and monitor order history.

## Tech Stack

- **Frontend (User):** Flutter, Dart  
- **Frontend (Admin):** React.js  
- **Backend:** Node.js, Express.js  
- **Database:** MongoDB  
- **Authentication:** JWT, bcrypt  
- **Hosting & Image Storage:** AWS EC2 (Backend), MongoDB Atlas (Database), AWS S3 (Images)

## Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Node.js](https://nodejs.org/en/) for backend development
- [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) for database management
- [AWS CLI](https://aws.amazon.com/cli/) for managing AWS resources
- [React.js](https://reactjs.org/) for the admin dashboard

## Folder Structure

- **/lib:** Flutter frontend code (screens, widgets, models, services)
- **/admin-panel:** React admin panel
- **/backend:** Node.js backend (routes, controllers)
- **/config:** Configuration files (MongoDB connection, AWS S3)
- **/models:** MongoDB models for products, users, and orders
- **/assets/images:** Static assets and product images

## Deployment

- Backend is hosted on **AWS EC2**
- Database is hosted on **MongoDB Atlas**
- Image assets are stored in **AWS S3**

## Acknowledgments

- Flutter and Dart for the frontend development  
- React.js for the admin panel  
- Node.js and Express for the backend  
- MongoDB for handling dynamic data  
- AWS for hosting and image storage
