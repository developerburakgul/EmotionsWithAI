# EmotionsWithAI

EmotionsWithAI is an iOS application that analyzes WhatsApp chats and visualizes emotional states on a calendar. The project is built using modern SwiftUI and MVVM architecture, with dependency management handled via a Container structure.

## Features

- Analyze WhatsApp chat emotions using the [MBWebService](https://github.com/developerburakgul/MBWebService) package
- Visualize emotions on a calendar with the [OBCalendar](https://github.com/oBilet/OBCalendar) component
- Detailed analysis per user and contact
- Supports both free and premium usage modes
- Modern, dynamic UI with SwiftUI

## Technologies & Architecture

- **SwiftUI** for all user interfaces
- **MVVM** pattern for clear separation of logic and UI
- **Dependency Injection (Container)** for managing dependencies
- **SPM (Swift Package Manager)** for all dependencies ([MBWebService](https://github.com/developerburakgul/MBWebService), [OBCalendar](https://github.com/oBilet/OBCalendar))

## Screenshots

Below you can add screenshots of the app. Place your images in the `screenshots/` folder and reference them here.  
Arranged in a 2x4 grid for better visualization:

|             Home Screen             |             Calendar View             |              Chat Import              |           Emotion Analysis            |
| :---------------------------------: | :-----------------------------------: | :-----------------------------------: | :-----------------------------------: |
|    ![Home](screenshots/home.png)    | ![Calendar](screenshots/calendar.png) |   ![Import](screenshots/import.png)   | ![Analysis](screenshots/analysis.png) |
|            User Profile             |              Statistics               |               Settings                |           Premium Features            |
| ![Profile](screenshots/profile.png) |    ![Stats](screenshots/stats.png)    | ![Settings](screenshots/settings.png) |  ![Premium](screenshots/premium.png)  |

_Add or replace images as needed for your project._

## Getting Started

1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/EmotionsWithAI.git
   ```
2. Open the project in Xcode.
3. Ensure all SPM dependencies are resolved automatically.
4. Build and run the project via `EmotionsWithAI.xcodeproj`.

## Main Packages Used

- [MBWebService](https://github.com/developerburakgul/MBWebService): For API requests and analysis operations.
- [OBCalendar](https://github.com/oBilet/OBCalendar): For calendar-based emotion visualization.

## Contribution & License

Feel free to open pull requests for contributions. See the LICENSE file
