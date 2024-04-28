# CurrencyConverter

CurrencyConverter is a Flutter application that allows users to convert between different currencies.

## Build Instructions

To build the project, follow these steps:

1. Clone the repository: `git clone https://github.com/salahkamal/CurrencyConverter.git`
2. Navigate to the project directory: `cd CurrencyConverter`
3. Install dependencies: `flutter pub get`
4. Get generated dependencies `dart run build_runner build`     
4. Run the app: `flutter run --dart-define=API_KEY=fca_live_mUoVaObSqA7LyEBr56rXJcTz25aTmOJiEJxGF8mM --dart-define=BASE_URL=https://api.freecurrencyapi.com/v1`

## Architecture Design Pattern

CurrencyConverter is built using the Clean Architecture design pattern. Clean Architecture promotes separation of concerns by dividing the application into distinct layers: Presentation, Domain, and Data. This architecture allows for better maintainability, testability, and scalability of the application. Clean Architecture was chosen for CurrencyConverter to ensure a clear separation of business logic from presentation logic, making the codebase easier to understand and maintain.

## Image Loader Library

For image loading in CurrencyConverter, the Flutter team's recommended library `cached_network_image` is used. `cached_network_image` provides efficient and hassle-free image caching and loading from network URLs. It was chosen for CurrencyConverter due to its simplicity, reliability, and widespread adoption within the Flutter community.

## Database Usage

CurrencyConverter uses Flutter Hive as its database for storing user preferences, such as currencies and conversion history. Hive is a lightweight and fast NoSQL database that is optimized for Flutter applications. It offers simplicity, performance, and cross-platform compatibility, making it an ideal choice for storing structured data locally on the device.

