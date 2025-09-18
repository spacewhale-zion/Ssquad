# 🎉 Venue Booking App - Full Stack Mobile Application

This repository contains the source code for a complete **mobile application** built with a **Flutter frontend** and a **Node.js backend**.  
The app allows users to browse service categories, submit detailed venue booking requests, and includes a **role-based authentication system** for users and administrators.

---

## ✨ Features

- **User Authentication**: Secure sign-up and login functionality for both regular users and admins.  
- **Role-Based Access Control**:
  - **Users**: Can browse categories and submit detailed venue booking requests.  
  - **Admins**: Can add new service categories and view all user booking requests.  
- **Dynamic Home Screen**: Fetches and displays a list of service categories directly from the backend.  
- **Detailed Booking Form**: Comprehensive form for users to specify event requirements (dates, number of guests, catering preferences, budget, etc.).  
- **Secure Backend**:
  - RESTful API with **Node.js, Express, MongoDB**  
  - **Secret Admin Key** → Admins can only be created during signup with a secret key  
  - **API Security** → Rate limiting & throttling to protect against brute-force and DoS attacks  

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (Dart)  
- **Backend**: Node.js, Express.js  
- **Database**: MongoDB (Mongoose)  
- **Authentication**: JSON Web Tokens (JWT), bcryptjs  

---

## 📦 Prerequisites

Before you begin, make sure you have:

- [Node.js](https://nodejs.org/) (includes npm)  
- [MongoDB](https://www.mongodb.com/) or a [MongoDB Atlas](https://www.mongodb.com/atlas) account  
- [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- A code editor like **VS Code**  
- An **Android Emulator**, **iOS Simulator**, or a physical device  

---

## 🚀 Getting Started

To run the application, you need to set up both **backend** (server) and **frontend** (Flutter app).

---

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-username/your-repository-name.git
cd your-repository-name
```

---

### 2️⃣ Backend Setup (server directory)

Navigate to the backend folder:

```bash
cd server
```

Install dependencies:

```bash
npm install
```

Create an `.env` file in the **server root** with the following variables:

```env
MONGO_URI=your_mongodb_connection_string
PORT=3000
JWT_SECRET=your_super_secret_and_long_random_string
ADMIN_SECRET_KEY=your_very_secret_admin_password
```

Run the backend server:

```bash
npm start
```

The server will run at:
👉 [http://localhost:3000](http://localhost:3000)



To populate categories:

```bash
curl -X POST http://localhost:3000/api/categories/seed
```

---

### 3️⃣ Frontend Setup (frontend directory)

Navigate to the frontend folder:

```bash
cd ../frontend
```

Install dependencies:

```bash
flutter pub get
```

#### 🔑 Frontend Environment Variables

Create an `.env` file in the **frontend root** (same level as `pubspec.yaml`) and add your backend API URL:

```env
API_BASE_URL=http://10.0.2.2:3000/api   # For Android Emulator
# API_BASE_URL=http://localhost:3000/api  # For iOS/Flutter Web
```

This value will be loaded inside your Flutter app using `flutter_dotenv`.

Example usage in `ApiConstants.dart`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
}
```

Run the Flutter app:

```bash
flutter run
```

The app will connect to the backend using the `API_BASE_URL` from `.env`.

---

## 📱 How to Use the App

### 🔑 Creating an Account

* **User Account**: Sign up with your name, email, and password → role = `user`
* **Admin Account**: Select `admin` role during signup and enter the `ADMIN_SECRET_KEY` from your backend `.env`

### 🎯 Functionality

* **Users**:

  * Browse all categories
  * Select a category → Fill out venue booking form → Submit request

* **Admins**:

  * Add new service categories
  * View all user-submitted banquet requests

---

## 📌 Notes

* Make sure the backend server is running **before starting the Flutter app**.
* Replace placeholder values in `.env` files with your actual MongoDB connection string, API base URL, and secret keys.
* ⚠️ On Flutter Web, `.env` variables are bundled in the frontend → do **not** store sensitive information there (only safe values like API URLs).

---

---
