# 🍽️ Restaurant Management System - Admin App

## 📌 About the Project

The Restaurant Management System is an admin application developed using Flutter and Laravel.

The application allows restaurant administrators to manage foods, categories, and customer orders from a single dashboard. It communicates with a Laravel REST API backend for data management and authentication.

---

## ✨ Features

### 🔐 Authentication
- Admin login
- Token-based authentication
- Secure API requests
- Logout

### 📊 Dashboard
- View total foods
- View total categories
- View pending orders
- View completed orders
- View recent orders

### 🍔 Food Management
- Add food
- View foods
- Edit food
- Delete food
- Upload food images

### 🗂️ Category Management
- Add category
- View categories
- Edit category
- Delete category
- Upload category images

### 🧾 Order Management
- View all orders
- Filter orders by status
- View order details
- View ordered items
- View total order amount
- Update order status

### 👤 Profile
- View admin profile
- Logout

---

## 🛠️ Technologies Used

### Frontend
- Flutter
- Dart
- Provider
- HTTP
- SharedPreferences

### Backend
- Laravel
- PHP
- Laravel Sanctum
- REST API
- Repository Pattern
- API Resources

### Database
- MySQL

### Tools
- VS Code
- Android Studio
- Postman
- Git & GitHub
- XAMPP

---

## 🏗️ Architecture

The application follows a layered architecture:

Flutter UI
↓
Provider
↓
API Service
↓
Laravel REST API
↓
Repository
↓
Eloquent Model
↓
MySQL

---

## 📱 Screens

- Login Screen
- Dashboard
- Food Management
- Category Management
- Order Management
- Order Details
- Profile

---

## 🚀 Getting Started

### Prerequisites

Make sure you have installed:

- Flutter
- Dart
- PHP
- Composer
- Laravel
- MySQL
- XAMPP

### Clone the Project

```bash
git clone https://github.com/RawalAnuma/restaurant_management_app.git
cd restaurant_management_app

```

## 🔗 Backend

This application uses a Laravel REST API as its backend.

Backend repository:

<your-laravel-repository-link>


## 🗄️ Database

The application uses MySQL to store:

- Users
- Foods
- Categories
- Orders
- Order Items


## 🔑 Authentication

The application uses Laravel Sanctum for token-based authentication.

After successful login, the API returns an authentication token. The Flutter application stores the token and sends it with protected API requests.

Authorization: Bearer <token>


## 🔮 Future Improvements
- Sales and revenue reports
- Payment integration
- Push notifications
- Table management
- Reservation management
- Staff management
- Customer application


## 👩‍💻 Author
Anuma Rawal
B.Sc. (Hons) Computing

