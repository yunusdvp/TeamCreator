# TeamCreator

**Welcome !**, TeamCreator is a mobile application that allows you to manage sports teams and players in a simple and effective way. With its user-friendly interface and powerful features, it offers a perfect solution for sports organizations, coaches and players.
 
## Table of Contents

1. [Features](#features)
   - [Screenshots](#screenshots)
   - [Tech Stack](#tech-stack)
   - [Architecture](#architecture)
2. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
3. [Usage](#usage)
   - [Players]
   - [Create Match]
   - [My Match]
5. [Known Issues](#known-issues)
6. [Improvements](#improvements)

## Features
- **Sport Selection**: User can choose one of three sports such as football, volleyball or basketball.
- **Player Management**: You can view players of the selected sport and add new players.
- **Match Creation**: You can create matches, specify location and date information and select players.
- **Match Overview**: You can view the details of the created matches.

## Screenshots

| ![Entry](https://github.com/user-attachments/assets/d23813b6-bf5f-4785-96f3-f0611548b76d) <br> **Spor Type List** | ![list](https://github.com/user-attachments/assets/1694fb90-b180-41bb-8b00-7dd96f872447) <br> **Process Selection Screen** | ![players](https://github.com/user-attachments/assets/4ac8a27c-b71d-48af-bc16-c9c63588d865) <br> **Player List** | ![add player](https://github.com/user-attachments/assets/393c5cfa-3c5f-40ad-bf29-03c48b0a027a) <br> **Add Player** |
|:---:|:---:|:---:|:---:|
| ![create](https://github.com/user-attachments/assets/052adffd-1ce6-4949-a49e-cc0b6217ff3d) <br> **Match Creation**  | ![mac](https://github.com/user-attachments/assets/6a6084ce-e1c2-4267-9849-453ed02e538e) <br> **Match Details** | ![mymac](https://github.com/user-attachments/assets/b3ba9f0c-b8f3-4157-a970-41ae21334ac7) <br> **My Matchs**  | |


## Screen Record

| ![WhatsApp GIF 2024-08-13 at 22 40 09](https://github.com/user-attachments/assets/f6b22c60-88a7-464f-8c18-1d28a6fa326a) <br> **Add Player** | ![WhatsApp GIF 2024-08-13 at 22 40 09 (1)](https://github.com/user-attachments/assets/13ddf30c-633d-4995-b0ad-c14530e884b8) <br> **Create Match** |
|:---:|:---:|

## Tech Stack
- **Xcode**: Version 15.3
- **Language**: Swift 5.10
- **Architecture**: MVVM (Model-View-ViewModel)
- **Database**: Firebase Firestore
- **UI Framework**: UIKit

## Architecture

![mvvm](https://github.com/user-attachments/assets/99a0c415-8646-466f-ada8-13f8bf763096)

**MVVM (Model-View-ViewModel) is an architectural design pattern that aims to separate data management and user interface in application development. This pattern makes the user interface dynamic and up-to-date by presenting the data and business logic provided by the Model to the View through the ViewModel. While the ViewModel directly interacts with the Model to process and update data, the View only presents data to the user and passes user interactions to the ViewModel, making the code cleaner, testable, and maintainable. MVVM separates the user interface components and business logic, making the development process more organized and modular.**

## Getting Started

### Prerequisites

Before you begin, ensure you have the following:

- **Xcode** installed

Additionally, make sure that these dependencies are added to your project's target:

- **Kingfisher**: A lightweight and pure Swift library for downloading and caching images from the web.
- **Firebase**: A comprehensive app development platform by Google, used for backend services such as authentication, database, and storage.


### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/cerenuludogan/TeamCreator.git

2. Open the project in Xcode:

   ```bash
   cd TeamCreator
   open TeamCreator.xcodeproj
   
3. Add required dependencies using Swift Package Manager:

   ```bash
   -- Kingfisher
   -- Firebase
   
4. Build and run the project.

### Usage

## Application Flow

1. **Start Screen**
   - **Sport Selection**: On the first screen, the user selects one of three sports (football, volleyball, basketball). This selection determines the content of the following screens.

2. **Main Screen**
   - **Player List**: Displays the list of players belonging to the selected sport. Users can see the current players from here.
   - **Match Creation**: Allows users to navigate to the match creation screen.
   - **Matches Created**: Provides access to screens where users can see details of previous matches.

3. **Player Screen**
   - **Player View**: Users can view the added players on this screen.
   - **Add Player**: By clicking the "Add Player" button, users can add new players, which directs them to the Player Add Screen.
   - **Points Sorting**: Added players can be sorted according to their points.

4. **Player Add Screen**
   - **Add New Player**: Users add a new player by entering information such as player name, age, and skill score.
   - **Return to Player List**: The newly added player is included in the player list.

5. **Match Creation Screen**
   - **Entering Match Information**: Users create a match by selecting the location, date, and players of the match.
   - **Team Strength**: Teams are created based on the strength of the players.

6. **My Matches Screen**
   - **Viewing Match Information**: Users can view information about the created matches, including date, location, and player information.


## Known Issues

- **Insufficient Control Structure**
- **UI Delays**

 ## Improvements

- **Enhanced Animations**: Implement smoother and more pleasing animations to improve user experience.
- **Localization**: Add support for additional languages ​​to reach a wider audience.


