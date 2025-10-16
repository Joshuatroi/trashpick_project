# TrashPick Mobile

A mobile-based application designed to enhance the efficiency, transparency, and sustainability of barangay-level waste collection operations. TrashPick connects residents, barangay officials, and administrators through a centralized mobile platform that streamlines collection operations and promotes community participation in sustainable waste practices.

---

## ♻️ Core Features

### 🕒 Real-Time Collection Schedules
- Displays up-to-date waste collection timetables per area  
- Sends reminders before collection time  
- Notifies residents of schedule changes or delays  
- Synchronizes automatically when the device is online  

### 📸 Resident Reporting System
- Allows residents to report overflowing bins or missed pickups  
- Supports photo attachments for issue verification  
- Automatically tags reports with location and timestamp  
- Enables direct feedback from barangay officials  

### 🏛️ Barangay Official Tools
- Manage and update waste collection routes  
- Post community announcements and updates  
- Review and respond to resident reports  
- Send real-time alerts to residents during emergencies or route adjustments  

### 🧑‍💼 Administrative Oversight
- Create, monitor, and revoke barangay official accounts  
- Manage resident and official data securely  
- Track system activity and ensure compliance with data policies  
- Maintain transparency through real-time monitoring dashboards  

### 📲 Accessibility & Usability
- Simple, intuitive interface designed for Android devices  
- Consistent navigation and responsive design  
- Offline access for residents with automatic data synchronization  

---

## ⚙️ Technology Stack
- **Framework:** Flutter  
- **Backend Services:** Firebase (Auth, Firestore, Cloud Messaging)  
- **Platform:** Android 8.0 (Oreo) and above  
- **Database:** Firestore NoSQL  

---

## 🌱 Future Enhancements
- Integration with **Google Maps API** for route visualization  
- Expansion to multi-barangay and municipal waste systems  

---


## Project Structure
```text
trashpick/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── screens/ # Screen /UI of the app
│   ├── widgets/ # Reusable UI elements like buttons, text fields, etc
│   ├── services/ # Handles logic for authentication, APIs, and data storage
│   ├── models/ # Collection of data
│   ├── providers/ # Interactions outside the app
│   ├── utils/ # Function or logic used in the app
│   ├── routes/ # Manages navigation and screen routing
│   └── config/ # Global configurations and environment settings
├── assets/ # Static assets for the app
│   ├── images/
│   ├── icons/
│   └── fonts/
└── test/ # Unit and widget tests   

