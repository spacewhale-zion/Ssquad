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

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-username/your-repository-name.git
cd your-repository-name
