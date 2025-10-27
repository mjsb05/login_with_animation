# 🧠 Animated Login Screen with Rive

## ✨ Overview
This Flutter project implements an **interactive animated login screen** using **Rive**.  
The main goal is to enhance user experience by combining UI design and animation logic through **state machines** that react dynamically to user input.  

---

## ⚙️ Functionalities
- 👀 **Smart Animation:** The character’s eyes follow your typing and react to focus changes.  
- 🙈 **Hands-Up Effect:** When typing the password, the character covers its eyes.  
- ✅ **Validation Feedback:** Displays success animation when the form is valid.  
- ❌ **Error Animation:** Shows failure animation when inputs are invalid.  
- 🔐 **Email & Password Validation:** Real-time input checking with clear feedback.  
- 👁️ **Password Visibility Toggle:** Allows the user to show/hide password text.  
- 📱 **Responsive Design:** Adjusts to any screen size for smooth UX.

---

## 🎨 What is Rive?
**Rive** is a real-time interactive animation tool that allows developers and designers to create vector animations that respond to user input.  
It bridges the gap between design and code by using **State Machines** to control how animations transition based on app logic.

---

## 🧩 What is a State Machine?
A **State Machine** in Rive defines how an animation changes based on user interactions or logic events.  
It manages the transitions between different animation states (for example, idle → typing → success).  
In this project, the State Machine named `"Login Machine"` controls:
- The character’s gaze (`numLook`)
- The hands movement (`isHandsUp`)
- The checking behavior (`isChecking`)
- The result triggers (`trigSuccess`, `trigFail`)

---

## 💻 Technologies Used
- 🐦 **Flutter** – UI framework for cross-platform apps  
- 🎞️ **Rive** – Animation engine for real-time, interactive motion graphics  
- 💬 **Dart** – Main programming language used for app logic  

---

## 📁 Project Structure
lib/
├── main.dart # Entry point of the app. Initializes the MaterialApp and routes.
└── screens/
└── login_screen.dart # Login screen with UI, validation, and Rive animation logic.


---

## 🔑 Main Files
### 🏁 `main.dart`
- Initializes the Flutter app.  
- Defines the app theme and sets the home screen as `LoginScreen`.

### 🔐 `screens/login_screen.dart`
- Implements the interactive login form.  
- Integrates Rive animation with a **State Machine Controller**.  
- Manages user focus, form validation, and animation triggers.

---

## 🎥 Demo  
![login_with_animation](https://github.com/user-attachments/assets/107f6df9-b30e-4298-b2f5-a1201a8d7969)


---

## 📚 Subject Information
- 🧩 **Subject:** Simulation  
- 👨‍🏫 **Professor:** Rodrigo Fidel Gaxiola Sosa  
- 🎓 **Student:** Mauri José Sandoval Bobadilla  

---

## 🙌 Credits
- 🎨 **Rive Animation:** [Remix of Login Machine](https://rive.app/marketplace/3645-7621-remix-of-login-machine/)  

---

## 💬 Author
Developed by **Mauri José Sandoval Bobadilla** as part of a university project focused on the integration of **interactive animations** and **simulation logic** within mobile applications.  

---

✨ *"Bringing motion to logic, and life to interfaces."* 🚀
