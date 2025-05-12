# External Packages

## Core Dependencies

### State Management & Data
- **provider** (^6.0.0)
  - Justification: Used for state management across the app
  - Provides simple and efficient way to manage app state
  - Enables dependency injection and widget rebuilding

- **graphql_flutter** (^5.0.0)
  - Justification: Used to interact with SpaceX GraphQL API
  - Provides type-safe GraphQL queries and mutations
  - Handles caching and network requests efficiently

### UI Components
- **flutter_screenutil** (^5.0.0)
  - Justification: Provides responsive UI scaling
  - Ensures consistent UI across different screen sizes
  - Simplifies responsive design implementation

- **google_fonts** (^4.0.0)
  - Justification: Provides easy access to Google Fonts
  - Ensures consistent typography across the app
  - Handles font loading and caching automatically

### Caching & Storage
- **shared_preferences** (^2.0.0)
  - Justification: Used for local data persistence
  - Stores app settings and cached data
  - Provides simple key-value storage

### Utilities
- **intl** (^0.17.0)
  - Justification: Used for date and number formatting
  - Provides localization support
  - Handles complex date/time operations

- **url_launcher** (^6.0.0)
  - Justification: Used to open external links
  - Handles launching URLs in browser
  - Manages deep linking

## Development Dependencies

### Testing
- **mockito** (^5.0.0)
  - Justification: Used for creating mock objects in tests
  - Simplifies unit testing
  - Enables testing of complex dependencies

- **build_runner** (^2.0.0)
  - Justification: Used to generate code for mocks
  - Automates code generation
  - Required for mockito annotations

### Code Generation
- **json_serializable** (^6.0.0)
  - Justification: Used for JSON serialization
  - Generates type-safe code for JSON handling
  - Reduces boilerplate code

- **freezed** (^2.0.0)
  - Justification: Used for immutable data classes
  - Provides code generation for immutable models
  - Reduces boilerplate code

## Version Management

### Flutter Version Management
- **fvm** (^2.0.0)
  - Justification: Manages multiple Flutter versions
  - Ensures consistent Flutter version across team
  - Simplifies version switching

## Future Considerations

### Planned Dependencies
- **firebase_core** & **firebase_auth**
  - Justification: For future authentication implementation
  - Will enable user accounts and authentication

- **flutter_local_notifications**
  - Justification: For future push notifications
  - Will enable launch notifications

- **cached_network_image**
  - Justification: For better image caching
  - Will improve image loading performance

## Version Control

All package versions are locked in `pubspec.lock` to ensure consistent builds across different development environments. The versions listed above are the minimum required versions, and the actual versions used may be higher based on compatibility requirements.

## Security Considerations

- All packages are from trusted sources (pub.dev)
- Regular security audits are performed
- Dependencies are kept up to date
- No packages with known security vulnerabilities are used 