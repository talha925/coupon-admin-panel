# Coupon Admin Panel

## Project Overview

A Flutter web application for managing coupons, stores, and categories. This admin panel provides a comprehensive interface for administrators to create, update, and monitor discount coupons across different stores and categories.

## Features

- **Authentication & Authorization**: Secure login system for administrators
- **Store Management**: Add, edit, and manage store information
- **Category Management**: Create and organize coupon categories
- **Coupon Creation & Management**: Design coupons with customizable parameters
- **Image Upload**: Support for uploading and managing store logos and promotional images
- **User-Friendly Interface**: Intuitive dashboard for easy navigation
- **Responsive Design**: Works across different device sizes and orientations

## Folder Structure

The project follows the MVVM (Model-View-ViewModel) architecture to ensure separation of concerns and maintainability:

```
lib/
├── data/           # Data classes and local data sources
├── model/          # Data models and entities
├── repository/     # Repository layer connecting ViewModels with data sources
├── res/            # Resources like strings, colors, and themes
├── services/       # API service implementations and network clients
├── utils/          # Utility functions and helper classes
├── view/           # UI components and screens
├── view_model/     # ViewModels connecting Views with Models
└── main.dart       # Application entry point
```

### MVVM Implementation

- **Model**: Represents the data and business logic
- **View**: The UI components that display data and send user actions to ViewModel
- **ViewModel**: Acts as a mediator between View and Model, handles UI logic and state

## State Management

The application uses Provider for state management:

- **Provider Package**: Implements a reactive state management approach
- **ChangeNotifier**: Base class for all ViewModels to notify listeners of state changes
- **MultiProvider**: Provides multiple ViewModels to the widget tree
- **Consumer & Provider.of**: Methods to access state in the UI components

Example of state management implementation:

```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AdminViewModel()),
    ChangeNotifierProvider(create: (_) => StoreViewModel()),
    ChangeNotifierProvider(create: (_) => CouponViewModel()),
    // Other providers
  ],
  child: MaterialApp(
    // App configuration
  ),
)
```

## Navigation

The application implements a declarative navigation approach:

- **Custom Router**: Handles navigation between different screens
- **State-Based Navigation**: Screen transitions based on application state
- **No Direct Navigator Usage**: Avoids direct usage of Navigator in favor of state-based routing

## API Integration

The application integrates with backend services using:

- **Dio**: HTTP client for making API requests
- **Repository Pattern**: Abstracts data fetching logic from the ViewModels

API authentication flow:

1. User enters credentials on login screen
2. Credentials are validated through API
3. JWT token is received and stored using `shared_preferences`
4. Token is attached to subsequent API requests
5. Token refresh mechanism handles expiration

## Running the Project

### Prerequisites

- Flutter SDK (version 3.4.0 or higher)
- Dart SDK (version 3.4.1 or higher)
- An IDE (VS Code, Android Studio, or IntelliJ)

### Setup

1. Clone the repository:

   ```
   git clone [repository-url]
   cd coupon_admin_panel
   ```

2. Install dependencies:

   ```
   flutter pub get
   ```

3. Run the application:
   ```
   flutter run -d chrome  # For web
   flutter run            # For other platforms
   ```

### Debug Mode

Run the application in debug mode:

```
flutter run --debug
```

## Deployment Guide

### Web Deployment

1. Build the web version:

   ```
   flutter build web
   ```

2. Deploy the `build/web` directory to your web server or hosting service (Firebase Hosting, Netlify, etc.)

### Mobile Deployment

1. Build the application:

   ```
   flutter build apk      # Android
   flutter build ios      # iOS
   ```

2. Follow the respective platform guidelines for publishing to app stores.

## Contributions

Contributions to the project are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Coding Guidelines

- Follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Write tests for new features
- Keep the code modular and maintainable
- Document complex logic and functions

## License

This project is licensed under the [MIT License](LICENSE).
