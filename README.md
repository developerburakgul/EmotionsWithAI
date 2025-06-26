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

## Demo

You can watch a demo of the application on YouTube:  
[https://youtu.be/RQN4XVUzvTE](https://youtu.be/RQN4XVUzvTE)

## Screenshots


<div align=center>
      <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/Onboarding-1.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/Onboarding-2.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/Onboarding-Last.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/SplashScreen.png">
  <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/HomeScreen.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/HomeScreenEmpty.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/AnalysisTab.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/PersonScreenEmpty.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/PersonScreenNonEmpty.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/SettingsScreen.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/ChatImport.png">
      <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/WhatsappLoading.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/WhatsappEmotionResult.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/WhatsapEmotionAnalysisNonResult.png">

   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/OneTimeAnalysisLoader.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/OneTimeAnalysisResult.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/PersonDetailScreen.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/CalendarScreen.png">

   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/PremiumSheet.png">
   <img height=150 src="https://github.com/developerburakgul/EmotionsWithAI/blob/main/SS/AnalysisTab.png">
   
</div>

<br>
<div>
    <h2 align=center> Screen Record </h2>
</div>

## Getting Started

> **Important:** Before running this project, you need to start the [EmotionWithAIBackend](https://github.com/developerburakgul/EmotionWithAIBackend) backend project on your local machine. The app's analysis and API features will not work properly unless the backend service is running.

1. Clone the repository:
   ```sh
   git clone https://github.com/developerburakgul/EmotionsWithAI.git
   ```
2. Open the project in Xcode.
3. Ensure all SPM dependencies are resolved automatically.
4. Build and run the project via `EmotionsWithAI.xcodeproj`.

## Main Packages Used

- [MBWebService](https://github.com/developerburakgul/MBWebService): For API requests and analysis operations.
- [OBCalendar](https://github.com/oBilet/OBCalendar): For calendar-based emotion visualization.


