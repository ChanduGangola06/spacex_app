# SpaceX App

A Flutter application that provides information about SpaceX launches, rockets, and company details using the SpaceX GraphQL API.

## Features

- 🚀 Launch Explorer: View upcoming and past SpaceX launches
- 🛸 Rocket Catalog: Browse through SpaceX's rocket fleet
- 🏢 Company Information: Learn about SpaceX's history and current status
- 📱 Responsive Design: Works on both mobile and desktop platforms
- 💾 Offline Support: Caches data for offline viewing

## Setup Instructions

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/spacex_app.git
cd spacex_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Architecture Overview

### Provider Pattern
The app uses the Provider pattern for state management, with the following key providers:
- `HomeProvider`: Manages the main data flow and API calls
- `AppCacheProvider`: Handles local data caching
- `ThemeProvider`: Manages app theming

### Data Flow
1. **API Layer**
   - Uses GraphQL for data fetching
   - Implements SpaceX's GraphQL API
   - Handles data caching and offline support

2. **Provider Layer**
   - Manages state and business logic
   - Handles data caching
   - Provides data to UI components

3. **UI Layer**
   - Implements Material Design
   - Responsive layouts for different screen sizes
   - Custom widgets for data display

### Design Decisions

1. **GraphQL over REST**
   - Chosen for efficient data fetching
   - Allows precise data requirements
   - Reduces over-fetching

2. **Provider Pattern**
   - Simple and effective state management
   - Easy to test and maintain
   - Good for medium-sized applications

3. **Caching Strategy**
   - Implements local caching for offline support
   - Uses SharedPreferences for persistent storage
   - Cache invalidation after 24 hours

## Known Issues

1. **Cache Initialization**
   - Occasional `LateInitializationError` for `_prefs` field
   - Workaround: Ensure `AppCacheProvider.init()` is called before accessing cache

2. **Data Loading**
   - Null check operator errors in some cases
   - Workaround: Added null checks in data loading methods

3. **UI Responsiveness**
   - Some layout issues on very small screens
   - Workaround: Use responsive helper for layout adjustments

## Future Improvements

1. **Performance**
   - Implement pagination for launches and rockets
   - Add image caching for better performance
   - Optimize GraphQL queries

2. **Features**
   - Add user authentication
   - Implement favorites system
   - Add push notifications for upcoming launches
   - Include more detailed rocket information

3. **Testing**
   - Increase unit test coverage
   - Add integration tests
   - Implement widget tests

4. **UI/UX**
   - Add dark mode support
   - Implement custom animations
   - Add more interactive elements

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- SpaceX for providing the GraphQL API