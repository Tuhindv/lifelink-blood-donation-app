
# 🩸 LifeLink – Blood Donation App

LifeLink is a Flutter-based blood donation application designed to connect blood donors with people who need blood. The goal is to make finding blood donors easier, faster, and more accessible.

## ✨ Features

- 🔐 User Authentication with Firebase Authentication
- 🏠 Dashboard after successful login
- 📝 Donor Registration
- 🔍 Search donors by blood group and district
- 🩸 Support for all major blood groups
- 🔒 Donor contact information sharing based on privacy preferences
- ☁️ Cloud Firestore integration for donor data storage
- 👤 User Profile Management
- 📱 Android APK for installation and testing

## 🛠️ Technologies Used

- **Frontend:** Flutter & Dart
- **Authentication:** Firebase Authentication
- **Database:** Cloud Firestore
- **Development Tools:** Visual Studio Code, Flutter SDK
- **Version Control:** Git & GitHub

## 📱 Application Workflow

1. Users register or log in to the application.
2. After successful login, they access the Dashboard.
3. Users can register as blood donors.
4. Donor information is stored in Cloud Firestore.
5. Users search for donors by blood group and district.
6. Donor contact information is shared according to the donor's privacy preferences.

## 🚀 Getting Started

### Prerequisites

Before running the project, make sure you have installed:

- Flutter SDK
- Dart SDK
- Git
- Visual Studio Code
- Android SDK (for Android development)
- A Firebase project

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Tuhindv/lifelink-blood-donation-app.git
```

**2. Navigate to the project directory**

```bash
cd lifelink
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Configure Firebase**

Configure Firebase for your application and ensure that the Android app is registered with the correct package name.

**5. Run the application**

```bash
flutter run
```

To check for code issues, run:

```bash
flutter analyze
```

## 🔥 Firebase Setup

LifeLink uses Firebase Authentication and Cloud Firestore.

To run the project with your own Firebase configuration:

1. Create a project in the Firebase Console.
2. Register your Android application.
3. Configure Firebase for Flutter.
4. Enable the required Firebase Authentication sign-in method.
5. Create a Cloud Firestore database.
6. Configure Firestore Security Rules to protect donor information.

**Security Note:** Donor information, especially mobile numbers, should only be accessible to authorized users according to the donor's consent and the application's privacy rules.

## 📲 Download LifeLink App

You can download the LifeLink Android APK from Google Drive:

[**Download LifeLink APK**](https://drive.google.com/file/d/1m8uMeQewLIhnMbGlBsTSftB_wgf6iCGm/view?usp=sharing)

If the download link does not work, check that Google Drive sharing is set to **Anyone with the link – Viewer**.

## 🔮 Future Improvements

- 🚨 Emergency blood request system
- 🔔 Notifications for urgent blood requests
- 📍 Location-based donor search
- 💬 Improved communication between donors and recipients
- 🔐 Enhanced privacy and security
- 📈 Improved donor availability management

## 👨‍💻 Developer

Developed as a Flutter semester project to help connect blood donors with people in need.

**GitHub Repository:**  
https://github.com/Tuhindv/lifelink-blood-donation-app

## 📄 License

No license has been specified yet.
