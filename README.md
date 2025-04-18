## 👤 Author
**Saravanan V**

## 🔑 Getting a TMDB API Key

1. Go to the [TMDB website](https://www.themoviedb.org/signup) and **create an account** (or log in if you already have one).
2. Once logged in, click your profile icon and go to **[Settings → API](https://www.themoviedb.org/settings/api)**.
3. Scroll down and click on the API section.
4. You will need to:
   - **Accept the Terms and Conditions**.
   - **Provide Application details**, such as:
     - **Application Name**
     - **Application URL / Domain**
     - **Application Summary**
     - **Contact Info**
5. Submit the form. Once approved, you’ll be able to access:
   - Your **API Key** — used in most TMDB endpoints.
   - Your **Bearer Token** — optional, for advanced use.
6. Use the **API Key** in your `.env` file.

## ⚙️ API Key Configuration

1. Create a `.env` file in the root directory of the project.
2. Copy the contents of `.env.example` to your `.env` file.
3. Replace `your_api_key_here` with your actual TMDB API key.

## 🚀 How to Build and Run the Project
1. **Clone the repository**: First, clone the project to your local machine using Git.

2. **Install dependencies**: After cloning, make sure to install the required dependencies by running flutter pub get.

3. **Set up the .env file**: Copy the .env.example file to .env and add your TMDB API Key there.

4. **Run the project**: Finally, run the project on your emulator or device using flutter run.

## 🛠️ Flutter Version
 - This project was built using Flutter version 3.22.2.
 - Make sure you are using this version for proper compatibility.
 - If needed, update your Flutter to the latest version using the flutter upgrade command.

## 📦 Dependencies
1. **provider**: State management for Flutter.

Version: ^6.0.5

2. **dio**: A powerful HTTP client for making network requests.

Version: ^5.0.0

3. **cached_network_image**: For loading and caching images from the internet.

Version: ^3.3.1

4. **intl**: Used for internationalization and formatting dates and currencies.

Version: ^0.20.2

5. **flutter_dotenv**: Loads environment variables (like API keys) from a .env file.

Version: ^5.1.0

## 🧱 Architecture & State Management
**State Management**

1. The app uses Provider for state management, which is officially recommended by Google for simple and scalable state handling in Flutter.

2. Provider integrates smoothly with the widget tree and allows clean separation between UI and business logic.

**Architecture**

1. The project follows a layered architecture for better separation of concerns:

2. Provider (Controller) – Manages app state and logic.

3. Services – Handles API requests (e.g., using Dio).

4. Models – Defines data structures from the TMDB API.

5. UI – Widgets that present data and react to state changes.

This approach ensures modular, maintainable, and testable code.

## ⚠️ Known Limitations
- **No Movie Trailers**: The movie detail screen only displays basic information, and does not currently show trailers or cast members.
- **Error Handling**: While basic error handling is implemented, it might not cover all edge cases.
- **No Pagination Control**: There is no option for users to manually select or navigate to different pages of movies, apart from scrolling down for more movies.
