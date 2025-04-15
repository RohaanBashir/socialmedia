🌐 Flutter Social Media App
A scalable and maintainable social media application built using Flutter, designed with CLEAN Architecture for robust and testable code. This app integrates Supabase for seamless backend and data management and utilizes BLoC (Business Logic Component) for efficient state management.

🚧 Note: This app is still under development.

✨ Features
🔐 Authentication

Login

Registration

🏠 Home Page

View all posts

Navigate to comments and profiles

📝 Post Creation

Create new posts with text/media support (media coming soon)

💬 Comments

Add and view comments under each post

🙋‍♂️ Profile Management

View other users' profiles

Edit your own profile (username, bio, etc.)

🎯 State Management

BLoC architecture for clean separation of UI and business logic

📱 Responsive UI

Optimized for both mobile and tablet devices

🛠️ Tech Stack

Layer	Technology
UI	Flutter
Architecture	CLEAN Architecture
State Management	BLoC
Backend/Database	Supabase
Authentication	Supabase Auth
📸 Screens
Login Page

Register Page

Home Page

Make Post Page

Comments Page

Profile Page

Edit Profile Page

(Screenshots coming soon!)

🚀 Getting Started
1. Clone the Repository
bash
Copy
Edit
git clone https://github.com/your-username/flutter-social-app.git
cd flutter-social-app
2. Install Dependencies
bash
Copy
Edit
flutter pub get
3. Configure Supabase
Update the lib/core/constants.dart or equivalent file with your Supabase URL and anon key.

4. Run the App
bash
Copy
Edit
flutter run
