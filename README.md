#  Guess The Word – Flutter Hangman Game

**Live Demo:** (https://ekjotkaursault.github.io/Hangman_Game/)  
**Author** ": Ekjot Kaur
**Github**: (https://github.com/ekjotkaursault)

---

##  Overview
**Guess The Word** is a fun and responsive **Hangman-style** word guessing game created using **Flutter Web**.  
Players try to uncover a hidden word letter by letter, with a limited number of wrong guesses allowed.  

This project was developed as part of my **Flutter learning and lab work**, where I combined:
-  creative UI/UX design  
-  logical game mechanics  
-  audio integration  
-  web deployment using GitHub Pages  

---

##  What I Did ? (My Original Work)

| Area | Description |
|------|--------------|
|  **Core Game Logic** | I wrote the full guessing logic in Dart. This includes handling user input, tracking guessed letters, updating wrong attempts, and detecting win/loss conditions. |
|  **State Management** | I designed the game using a **StatefulWidget**, manually updating game state variables for interactivity (`_guessedLetters`, `_wrongGuesses`, `_wins`, `_losses`). |
|  **User Interface Design** | I created a modern, colorful UI with gradients, rounded cards, and glowing elements. The layout adapts responsively using `MediaQuery` and `LayoutBuilder`. |
|  **Animations** | I implemented smooth fade-in animations using `AnimationController` and `FadeTransition` to make result messages appear nicely. |
|  **Sound System** | I integrated **audioplayers** to add win/lose sounds. I fixed path issues so that sounds play correctly on **GitHub Pages**, not just in local runs. |
|  **Web Deployment** | I configured Flutter’s web build system with a custom base path and used `git subtree` to deploy the project on the **gh-pages branch**. |
|  **Documentation (README)** | I wrote this documentation to describe my process, acknowledge sources, and explain what I learned. |

---

##  External Resources Used (for Learning & Reference)

While all **design, logic, and code integration** were created by me,  
I consulted a few **official and educational resources** to learn new concepts and solve problems.

| Resource | How I Used It |
|-----------|----------------|
| [Flutter Documentation](https://flutter.dev/docs) | Learned widget structure, stateful widget usage, and responsive UI building. |
| [Dart Language Tour](https://dart.dev/language) | Reviewed syntax for loops, conditions, lists, and random selection. |
| [Audioplayers GitHub Repo](https://github.com/bluefireteam/audioplayers) | Used official docs to understand web audio limitations and implement correct `UrlSource()` for GitHub Pages. |
| [Flutter.dev – Animations Guide](https://docs.flutter.dev/development/ui/animations) | Learned how to use `AnimationController` and `FadeTransition`. |
| [Medium Tutorial – Deploy Flutter Web to GitHub Pages](https://medium.com/flutter-community/how-to-deploy-flutter-web-app-to-github-pages-2a8bdc5c6e3e) | Followed steps to build and deploy the Flutter web version correctly. |

>  *I did not copy any game code directly from online sources.*  
> These materials were only used for **understanding**, then I implemented the logic and styling independently.

---

##  Technologies Used

| Technology | Purpose |
|-------------|----------|
| **Flutter (3.x)** | Framework used to build UI and logic for web |
| **Dart** | Programming language used throughout the app |
| **audioplayers** | Added sound effects for success and failure |
| **Material Design 3** | Provided consistent visual design |
| **GitHub Pages** | Used to host the live playable web version |
| **VS Code** | IDE used for coding, testing, and deployment |

---

##  Features Implemented by Me

1. Word guessing logic  
2. Wrong guess counter and loss condition  
3. Animated motivational messages  
4. Gradient + glassmorphic card design  
5. Success & failure sound playback  
6. Score tracking (wins and losses)  
7. Dynamic word generation  
8. Fully responsive layout (mobile + desktop)  
9. GitHub Pages live hosting  

---

##  How to Run This Project
In the Terminal:
### Clone Repository
```bash
git clone https://github.com/ekjotkaursault/Hangman_Game.git
cd Hangman_Game

## Install Dependencies
flutter pub get

## Run in Chrome
flutter run -d chrome

## Build for Web (with correct base path)
flutter build web --base-href="/Hangman_Game/"

## Deploy to GitHub Pages
git add build/web -f
git commit -m "Deploy updated web build"
git subtree push --prefix build/web origin gh-pages



