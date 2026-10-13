# 🩸 LifeLink – Blood Donation App

LifeLink is a Flutter-based blood donation application designed to connect blood donors with people who need blood. The goal of this project is to make finding blood donors easier, faster, and more accessible.

## ✨ Features

- 🔐 User Authentication with Firebase
- 🏠 Dashboard after successful login
- 📝 Donor Registration
- 🔍 Search donors by blood group and district
- 🔒 Donor phone numbers are protected and should only be visible with the donor's permission
- ☁️ Firebase Firestore integration for donor data storage

## 🛠️ Technologies Used

- **Frontend:** Flutter & Dart
- **Authentication:** Firebase Authentication
- **Database:** Cloud Firestore
- **Development Tools:** VS Code, Flutter SDK, Git & GitHub

## 📱 Application Workflow

1. Users log in to the application.
2. After successful login, they access the Dashboard.
3. Donors register by providing their information.
4. Users search for donors by blood group and district.
5. Donor contact information is shared only according to the donor's privacy permissions.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Firebase project
- Android SDK (for running on Android devices)

### Installation

1. Clone the repository:

   ```bash
   git clone YOUR_GITHUB_REPOSITORY_URL
   ```

2. Open the project directory:

   ```bash
   cd lifelink
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Configure Firebase for your project.

5. Run the application:

   ```bash
   flutter run
   ```

## 🔥 Firebase Setup

This project uses Firebase Authentication and Cloud Firestore.

To run the application, configure Firebase for your own project and ensure that Firestore Security Rules protect donor information.

**Important:** Donor phone numbers must not be exposed to unauthorized users. Implement appropriate authentication, authorization, and Firestore Security Rules.

## 🔮 Future Improvements

- Push notifications for urgent blood requests
- Blood request posting and management
- Donor availability status
- Location-based donor search
- Improved privacy and security controls

## 👨‍💻 Developer

Developed as a Flutter application project to help connect blood donors with people in need.

## 📄 License

C:\flutter\bin\flutter.bat run -d edge --web-hostname localhost


This project is available for educational and learning purposes. Add an appropriate open-source license if you plan to distribute or reuse the code publicly.
