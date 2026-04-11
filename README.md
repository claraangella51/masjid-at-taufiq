Masjid At-Taufiq - Smart Mosque Attendance & Activity Management System

Masjid At-Taufiq is a production-grade Flutter mobile application designed to manage mosque activities digitally. It focuses on attendance tracking, jamaah management, and event organization to improve efficiency and transparency in mosque operations.

🕌 Features
	•	Digital Attendance (Presensi): Record attendance for jamaah and events in real-time
	•	User Management: Manage jamaah profiles including name, batch, and training/group data
	•	QR / Manual Check-in: Flexible attendance system (QR-based or manual input)
	•	Activity Tracking: Monitor participation in mosque programs and events
	•	History Log: Complete record of attendance and activities
	•	Authentication System: Secure login for admins and users
	•	Firebase Integration: Real-time database and cloud-based backend
	•	Multi-Platform: Built with Flutter for Android, scalable to iOS, web, and desktop

🎯 Program & Activity Categories

Ibadah (Worship Activities)
	•	Sholat Berjamaah 🕌
	•	Kajian Rutin 📖
	•	Dzikir & Doa 🤲

Pendidikan (Education)
	•	Tahfidz Al-Qur’an 📘
	•	Kelas Keislaman 🧠
	•	Pelatihan Remaja Masjid 🎓

Sosial (Social Activities)
	•	Bakti Sosial 🤝
	•	Donasi & Zakat 💰
	•	Kegiatan Ramadhan 🌙

📱 App Navigation

The app uses a structured navigation system with main menus:
	1.	Beranda (Dashboard) - Overview of attendance, user stats, and recent activities
	2.	Presensi - Attendance recording (QR/manual input)
	3.	Data Jamaah - Manage user/jamaah information
	4.	Riwayat - Attendance and activity logs

Additional screen:
	•	Profil & Pengaturan - User profile and system configuration

🚀 Quick Start

Prerequisites
	•	Flutter 3.10.8+
	•	Dart SDK
	•	Android API 21+ or iOS 11.0+
	•	Firebase account (for backend)

Installation
	1.	Clone/navigate to project:

cd /Users/claraangella/Flutter_Project/masjid_at_taufiq

	2.	Install dependencies:

flutter pub get

	3.	Configure Firebase:
	•	Download google-services.json from Firebase Console
	•	Place in android/app/
	•	For iOS, download GoogleService-Info.plist and add to Xcode project
	4.	Run the app:

# Android
flutter run -d android

# iOS
flutter run -d ios

🏗️ Architecture

The app follows a clean architecture pattern with feature-first folder structure:

lib/
├── core/               # Theme, routing, Firebase services
├── features/           # Feature modules (auth, attendance, users, etc.)
├── shared/             # Reusable widgets and utilities
├── main.dart
└── app.dart

State Management: Riverpod
Routing: Go Router
Database: Firebase Realtime Database / Firestore
Authentication: Firebase Auth
Notifications: Firebase Cloud Messaging

For detailed architecture documentation, see ARCHITECTURE.md￼.

🔑 Key Concepts

Attendance Workflow
	•	Users check in via QR code or manual input
	•	Data is stored in Firebase in real-time
	•	Admin can monitor attendance instantly
	•	Each record is linked to user profile and activity

Role-Based Access
	•	Admin: Full access (manage users, view reports, control system)
	•	User/Jamaah: Limited access (attendance & activity participation)

Activity Tracking
	•	Each event/activity has its own attendance list
	•	Historical data can be filtered by date, activity, or user

🎨 Design Highlights
	•	Islamic-Themed UI: Green tones, clean layouts, and calm visual design
	•	User-Friendly Interface: Simple navigation for all age groups
	•	Responsive Design: Works across various screen sizes
	•	Bahasa Indonesia: Fully localized for Indonesian users
	•	Accessibility: Clear icons, readable typography, and structured layout

🔐 Security Considerations

For production deployment, ensure:
	•	Proper Firebase security rules
	•	Role-based access control (RBAC)
	•	Secure authentication and session management
	•	Data privacy for jamaah information
	•	Protection against unauthorized attendance manipulation

📊 Demo Mode

The app may run in demo mode with sample data:
	•	Dummy jamaah profiles
	•	Simulated attendance records
	•	Sample activity logs

To switch to real Firebase data, configure providers and backend integration.

🛠️ Development

Project Structure Highlights
	•	Modular Features: Each feature (auth, attendance, jamaah) is independent
	•	Reusable Widgets: Common UI components in shared/widgets/
	•	Strong Typing: Null-safe Dart implementation
	•	Riverpod Providers: Reactive and scalable state management

Key Files
	•	lib/main.dart - App entry point
	•	lib/app.dart - Root app widget
	•	lib/core/theme/app_theme.dart - Theme configuration
	•	lib/core/router/app_router.dart - Navigation setup
	•	lib/core/firebase/firebase_service.dart - Firebase backend

📝 Notes
	•	Prototype Scale: Suitable for small to medium mosque communities
	•	Android First: Optimized for Android devices
	•	Scalable System: Can expand to multi-mosque system
	•	Extensible: Supports adding features like donation tracking, announcements, etc.
	•	Localization Ready: Currently Indonesian, adaptable to other languages

🐛 Troubleshooting

Firebase initialization error?
	•	Ensure Firebase config files are correctly placed
	•	Verify Firebase project settings

Build errors?

flutter clean
flutter pub get --upgrade
flutter pub get

Hot reload not working?
	•	Use hot restart or full rebuild

📚 Further Reading
	•	See ARCHITECTURE.md￼ for technical details
	•	Flutter docs: https://flutter.dev
	•	Riverpod docs: https://riverpod.dev
	•	Firebase Flutter: https://firebase.flutter.dev

📄 License

This project is provided as a prototype implementation for mosque digital management systems.

⸻

Version: 1.0.0
Last Updated: April 2026
Flutter: 3.10.8+

Made with ❤️ for digital transformation of mosques in Indonesia 🕌✨

masjid_at_taufiq
