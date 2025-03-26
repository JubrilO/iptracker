# IPTracker

A mobile application that helps you find the geographic location of IP addresses.

## Features

- Enter any IPv4 address to look up its geographic location
- Get your current IP address with a single tap
- View locations on an interactive map
- See location details including coordinates, city, and country
- Zoom controls for map navigation
- Error handling for invalid inputs and network failures

## Architecture

The app is built using clean architecture principles with the following components:

### Core Layer
- **Result**: A generic class for handling success and failure states
- **Failure**: Abstract class for different types of errors
- **DioClient**: Network client for making HTTP requests
- **Routes**: Central routing configuration for app navigation

### Services Layer
- **IPService**: Base abstract service defining IP geolocation operations
- **IPAPIService**: Implementation for ipapi.co API integration
- **IPifyService**: Implementation for ipify.org API integration
- **IPServiceProvider**: ChangeNotifier-based service provider for IP-related operations

### Features Layer
- **IPData**: Model for IP geolocation data
- **IPRepository**: Repository for fetching IP data with caching
- **HomeViewModel**: View model for the home screen with IP lookup logic
- **MapViewModel**: View model for the map screen
- **HomeScreen**: UI for entering IPs and initiating lookups
- **MapScreen**: UI for displaying IP location on a map

## State Management

The app uses Provider for state management with the following structure:
- **ChangeNotifierProvider** for ViewModels (HomeViewModel, MapViewModel)
- **Provider** for services and repositories
- Dependency injection through Provider context

## Tech Stack

- **Flutter**: UI framework
- **Dio**: HTTP client for API requests
- **Provider**: State management
- **flutter_map**: Map display (based on OpenStreetMap)
- **latlong2**: Geographical coordinate handling
- **Mockito**: Mocking for unit tests
- **build_runner**: Code generation for testing
- **flutter_lints**: Static code analysis

## Screenshots
<img width="362" alt="Screenshot 2025-03-26 at 05 46 43" src="https://github.com/user-attachments/assets/c226cd3d-d203-4734-a483-b77a0efdbb8c" />
<img width="368" alt="Screenshot 2025-03-26 at 05 46 55" src="https://github.com/user-attachments/assets/0b600910-9212-434b-b734-843eed885ae9" />

## Setup and Installation

1. Clone the repository:
```bash
git clone https://github.com/jubrilo/iptracker.git
```

2. Install dependencies:
```bash
cd iptracker
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Testing

The application includes comprehensive tests for key components:

- **Repository Tests**: Testing API interactions and data caching in IPRepository
- **ViewModel Tests**: Testing business logic in HomeViewModel and MapViewModel
- **Widget Tests**: Testing core UI components and interactions

Run tests with:
```bash
# Run all tests
flutter test

# Generate mocks (if needed)
flutter pub run build_runner build
```

## API Usage

The app uses the the following API services
- [ipapi.co](https://ipapi.co/)
- [ipify.org](https://ipify.org/)


## License

This project is licensed under the MIT License - see the LICENSE file for details.
