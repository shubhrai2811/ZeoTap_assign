# Real-Time Weather Monitoring

Real-Time Weather Monitoring is a Flutter application that provides up-to-date weather information for various cities. It offers features like real-time weather updates, temperature alerts, and historical weather data visualization.

## Features

- Real-time weather updates for multiple cities
- Temperature alerts system
- Historical weather data visualization
- Search functionality for adding new cities
- Settings for customizing temperature units (Celsius/Fahrenheit)
- Dark mode theme with gradient background

## Getting Started

### Prerequisites

- Flutter SDK (version 2.0 or later)
- Dart SDK (version 2.12 or later)
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/shubhrai2811/ZeoTap_assign.git
   ```

2. Navigate to the project directory:
   ```
   cd real-time-weather-monitoring
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/`: Contains the main Dart code for the application
  - `screens/`: UI screens of the app
  - `widgets/`: Reusable UI components
  - `models/`: Data models
  - `providers/`: State management using Provider
  - `services/`: API and database services
  - `core/`: Core functionalities and themes

## Dependencies

This project uses the following main dependencies:

- `flutter`: The main framework
- `provider`: For state management
- `http`: For making API calls
- `sqflite`: For local database storage
- `flutter_local_notifications`: For sending local notifications
- `shared_preferences`: For storing user preferences

For a full list of dependencies, please refer to the `pubspec.yaml` file.

## Configuration

To use this application, you need to set up an API key from OpenWeatherMap:

1. Here for Demonstration purposes, I have used my own API key.

## Usage

- The home screen displays the current weather for saved cities
- Use the search icon to add new cities
- Tap on a city card to view detailed weather information
- Use the alerts screen to set up temperature alerts
- Access the settings screen to change temperature units


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Weather data provided by [OpenWeatherMap](https://openweathermap.org/)
- Icons from [Material Design Icons](https://materialdesignicons.com/)
