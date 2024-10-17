<img src="https://github.com/user-attachments/assets/966893c3-0e1f-44a0-aa83-8b6ba205c0bb" alt="App Icon" width=200/>

# Tasky App

Tasky is a task management app built using a combination of **SwiftUI**, **UIKit**, and **Swift**. It leverages modern Swift development practices, including **Swift Concurrency**, **CoreData**, **animations**, and **dependency injection**. The app follows the **MVVM (Model-View-ViewModel)** pattern and **Clean Architecture** principles to ensure a scalable and maintainable codebase.

## Features

- **Swift Concurrency**: Used to handle background operations and improve the responsiveness of the app.
- **CoreData**: Local storage of tasks with persistent data management.
- **Animations**: Smooth, custom animations that enhance the user experience.
- **Beautiful UI Elements**: A carefully crafted and responsive user interface, combining both UIKit and SwiftUI.
- **Dependency Injection**: Implemented to keep the code modular and easy to test.
- **Swift Testing**: Includes unit tests and integration tests for various parts of the app.
- **Protocols**: Protocol-oriented programming to ensure loose coupling and flexibility.
- **JSON Decoding**: Handles JSON parsing efficiently to work with remote or local data.
- **Background Fetching**: Support for fetching data in the background using **background tasks**.
- **Local Notifications**: Integrated with **UNUserNotifications** to remind users of tasks.
- **Custom Extensions**: Reusable components and extensions to streamline development.
- **Localizables**: Multi-language support for internationalization.
- **Appearance Manipulation**: Customizable app appearance for user experience.
- **App Intro**: App Intro will help to clarify things up.

## Architecture

The app follows the **MVVM** (Model-View-ViewModel) pattern for separation of concerns:
- **Model**: Handles data and business logic.
- **ViewModel**: Mediates between the Model and the View, ensuring that the UI layer only focuses on presenting data.
- **View**: SwiftUI views combined with UIKit components where necessary, focusing on rendering UI.

Additionally, the app is structured according to **Clean Architecture** principles, which ensures:
- Independence of frameworks and libraries.
- Easily testable and maintainable code.
- Separation of concerns between layers.

## Core Technologies

- **UIKit & SwiftUI**: A hybrid approach to build a responsive, beautiful UI.
- **CoreData**: For efficient task storage and retrieval.
- **Swift Concurrency**: For handling async operations seamlessly.
- **UNUserNotifications**: To schedule and manage user notifications.
- **XCTest**: Unit testing for business logic and UI components.

## Prerequisites

- **Xcode 13** or later
- **iOS 16** or later

## Localization

- Tasky supports multiple languages using Localizable.strings for internationalization.

## Screenshots

<img src="https://github.com/user-attachments/assets/94e48f24-9128-4bcf-a35e-d98ecacd4439" alt="Tag View" width=200 />
<img src="https://github.com/user-attachments/assets/82b2d0d5-9744-40c8-8c22-7b7343506b8b" alt="Add Tag" width=200 />
<img src="https://github.com/user-attachments/assets/b672e39e-26a5-4cd9-b8a8-4fd73b7000ee" alt="New Todo" width=200 />
<img src="https://github.com/user-attachments/assets/9c0205a3-7ef8-4816-8626-419878363dcc" alt="Todo Details" width=200 />
<img src="https://github.com/user-attachments/assets/35f29244-da1f-4aa1-8f87-03ba087766c2" alt="Main Screen" width=200 />
<img src="https://github.com/user-attachments/assets/070bca6c-63f1-4ac3-9204-572cd5806e59" alt="App Intro" width=200 />
