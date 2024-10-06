# Citizen Squad

Citizen Squad is an open-source Flutter application aimed at empowering citizens to report issues like abandoned vehicles, potholes, and garbage directly to the relevant authorities (RTO for vehicles and municipal corporations for public infrastructure). The app uses modern Flutter development practices, integrates with APIs like Google Maps and Parivahan, and stores data on Firebase and MongoDB.

## Features
- **Report Abandoned Vehicles:** Uses the Parivahan API to fetch vehicle details and notify the RTO.
- **Report Potholes & Garbage:** Integrates with Google Maps API for real-time location tracking to help report issues to municipal corporations.
- **Dashcam Feature:** Automatically captures and reports potholes while driving, using the phone's camera.
- **Google Maps Integration:** Helps users mark locations easily for accurate reporting.
- **Real-time Notifications:** Keeps users informed about the status of their reports.
- **Multi-platform Support:** The app works on both Android and iOS.

## Tech Stack
- **Frontend:** Flutter with Provider for state management.
- **Backend:** Firebase, MongoDB.
- **APIs Used:**
  - **Google Maps API** for location tracking and reporting.
  - **Parivahan API** for abandoned vehicle information.

## Getting Started
If you're new to Flutter or contributing to open-source projects, follow these steps to get started:

### Prerequisites
- Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Install a code editor like [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
- Set up [Firebase](https://firebase.google.com/) and [MongoDB](https://www.mongodb.com/)

### Setup Instructions
1. Clone this repository:
    ```bash
    git clone https://github.com/Shubham-zone/citizen-squad.git
    ```
2. Install dependencies:
    ```bash
    flutter pub get
    ```
3. Set up Firebase in your project:
   - Add your `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) in the respective directories.
4. Set up the necessary API keys:
   - Ensure you have the API keys for **Google Maps** and **Parivahan API**.

5. Run the app:
    ```bash
    flutter run
    ```

## Contributing
We welcome contributions from the community! To contribute, follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Make your changes and commit with clear messages.
4. Push your changes and create a pull request.

---

## 👀 Our Contributors

- We extend our heartfelt gratitude for your invaluable contribution to our project! Your efforts play a pivotal role in elevating this project to greater heights.
- Make sure you show some love by giving ⭐ to our repository.

<div align="center">
  <a href="https://github.com/Shubham-Zone/Citizen_Squad">
    <img src="https://contrib.rocks/image?repo=Shubham-Zone/Citizen_Squad&&max=100" />
  </a>
</div>

---

## Issues & Feature Requests
If you encounter any issues or have suggestions for new features, feel free to [open an issue](https://github.com/Shubham-zone/citizen-squad/issues).

## Contact
For questions or suggestions, please reach out to the maintainers or open an issue in the repo.
