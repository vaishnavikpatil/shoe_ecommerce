

# Full-Stack E-Commerce App

**Full-Stack E-Commerce App** is a complete online shopping platform built using Flutter for the frontend, Node.js with Express for the backend, MongoDB for the database, and AWS for hosting and image storage. The goal was to create a production-ready app with clean architecture and best practices.

## Features

- **User Authentication:** Sign up, login, and manage your account with secure authentication (JWT and bcrypt).
- **Product Catalog:** Browse all products, check out popular items, or view new arrivals.
- **Search and Filters:** Search for products and filter by price, category, and other criteria.
- **Product Details:** View detailed product information (images, descriptions, pricing) and add to cart or favorites.
- **Cart Management:** Review cart items, change quantities, remove items, and place orders.
- **User Profile:** Update personal information and reset password.
- **Responsive Design:** Optimized for a fast, smooth user experience with Flutter's cross-platform capabilities.

## Tech Stack

- **Frontend:** Flutter, Dart
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



## Folder Structure

- **/lib:** Frontend code for screens, widgets, models, and services.
- **/backend:** Contains all the backend code (Node.js, Express, routes, controllers).
- **/config:** Holds configurations like MongoDB connection and AWS S3 integration.
- **/models:** Defines MongoDB models for products, users, and orders.
- **/assets/images:** Stores images for the product catalog.


## Deployment

- Backend is hosted on **AWS EC2**.
- Database is hosted on **MongoDB Atlas**.




## Acknowledgments

- Flutter and Dart for the frontend development.
- Node.js and Express for the backend.
- MongoDB for handling dynamic data.
- AWS for hosting and image storage.


