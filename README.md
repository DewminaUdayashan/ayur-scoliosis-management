# SpineAlign - Ayurveda Scoliosis Management System

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

A comprehensive Flutter application designed to help manage scoliosis through traditional Ayurvedic approaches combined with modern technology. This app provides personalized treatment plans, exercise routines, and progress tracking for scoliosis patients using Ayurvedic principles.

## 🎯 Project Overview

SpineAlign is a mobile application that bridges the gap between traditional Ayurvedic medicine and modern healthcare technology for scoliosis management. The app offers:

- **Personalized Assessment**: AI-driven scoliosis severity analysis
- **Ayurvedic Treatment Plans**: Customized treatment recommendations based on Ayurvedic principles
- **Exercise Tracking**: Guided yoga asanas and therapeutic exercises
- **Progress Monitoring**: Visual progress tracking with spine curve analysis
- **Consultation System**: Connect with Ayurvedic practitioners
- **Educational Resources**: Comprehensive information about scoliosis and Ayurveda

## ✨ Features

### 🔐 Authentication

- Secure user registration and login
- Profile management
- Patient data privacy protection

### 🏠 Dashboard

- Personalized health overview
- Treatment progress summary
- Quick access to key features

### 📊 Assessment & Monitoring

- Spine curvature analysis
- Progress tracking with visual charts
- Photo-based posture assessment
- Regular health check-ins

### 🧘‍♀️ Treatment Plans

- Customized Ayurvedic treatment protocols
- Yoga asana recommendations
- Herbal remedy suggestions
- Lifestyle modification guidance

### 📚 Educational Resources

- Scoliosis information library
- Ayurvedic principles and practices
- Exercise tutorials and videos
- Nutrition guidelines

## 🛠️ Tech Stack

### Frontend

- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Riverpod** - State management with hooks
- **Go Router** - Declarative routing
- **Google Fonts** - Typography

### Architecture

- **Clean Architecture** - Separation of concerns
- **MVVM Pattern** - Model-View-ViewModel
- **Repository Pattern** - Data abstraction
- **Dependency Injection** - Riverpod providers

### Development Tools

- **Build Runner** - Code generation
- **Riverpod Generator** - Provider code generation
- **Custom Lint** - Code quality enforcement
- **JSON Serializable** - Model serialization

## 📁 Project Structure

```text
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── extensions/         # Dart extensions
│   │   └── theme.dart     # Theme extensions
│   ├── utils/             # Utility functions
│   ├── router.dart        # App routing configuration
│   └── theme.dart         # App theme configuration
├── models/                 # Data models
├── providers/             # Riverpod providers
├── screens/               # UI screens
│   ├── auth/             # Authentication screens
│   ├── home/             # Home/dashboard screens
│   └── splash/           # Splash screen
└── main.dart             # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator (for iOS development)
- Android Emulator (for Android development)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/DewminaUdayashan/ayur-scoliosis-management.git
   cd ayur-scoliosis-management
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code**

   ```bash
   dart run build_runner build
   ```

4. **Run the app**

   ```bash
   flutter run
   ```

### Development Setup

1. **Enable code generation watch mode** (for development)

   ```bash
   dart run build_runner watch
   ```

2. **Run linting**

   ```bash
   flutter analyze
   ```

3. **Run tests**

   ```bash
   flutter test
   ```

## 📱 Screenshots

> Screenshots will be added as the application development progresses.

## 🤝 Contributing

We welcome contributions to SpineAlign! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style Guidelines

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart)
- Use meaningful variable and function names
- Add documentation for public APIs
- Write tests for new features
- Ensure code passes all linting rules

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Developer**: Dewmina Udayashan
- **Repository**: [ayur-scoliosis-management](https://github.com/DewminaUdayashan/ayur-scoliosis-management)

## 📞 Support

For support and questions:

- Create an issue on GitHub
- Contact the development team

## 🔮 Roadmap

- [ ] Complete authentication system
- [ ] Implement scoliosis assessment algorithms
- [ ] Add Ayurvedic treatment database
- [ ] Integrate with healthcare APIs
- [ ] Add multilingual support
- [ ] Implement offline mode
- [ ] Add wearable device integration

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Ayurvedic practitioners for domain expertise
- Open source community for valuable packages
- Research community for scoliosis management insights

---

**Note**: This is an academic/research project focused on exploring the integration of traditional Ayurvedic medicine with modern technology for scoliosis management.