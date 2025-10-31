// 🎮 Guess The Word Game (Responsive Version)
// Author: Ekjot Kaur
// Description: A Flutter-based hangman-style game with sounds, animations,
// motivational messages, and fully responsive UI for web and mobile.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const GuessWordApp());
}

// Root widget of the app
class GuessWordApp extends StatelessWidget {
  const GuessWordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess The Word Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', useMaterial3: true),
      home: const GuessWordGame(),
    );
  }
}

// Main StatefulWidget managing the game logic and UI
class GuessWordGame extends StatefulWidget {
  const GuessWordGame({super.key});

  @override
  State<GuessWordGame> createState() => _GuessWordGameState();
}

// Game logic and UI implementation
class _GuessWordGameState extends State<GuessWordGame>
    with SingleTickerProviderStateMixin {
  // --- WORD BANK ---
  final List<String> _words = [
    'FLUTTER',
    'APPLE',
    'BANANA',
    'ORANGE',
    'MOBILE',
    'DART',
    'WIDGET',
    'BUTTON',
    'SCREEN',
    'GOOGLE',
    'CHROME'
  ];

  // --- MOTIVATIONAL MESSAGES ---
  final List<String> _motivations = [
    'Keep going! You’ll get it next time 💪',
    'Don’t give up, champion 🌟',
    'You’re improving every try 🔥',
    'That was close! Try again 😄',
    'Winners never quit 💫',
    'Great effort! 👏'
  ];

  // --- GAME STATE VARIABLES ---
  late String _selectedWord; // The random word to guess
  final List<String> _guessedLetters = []; // Player’s guessed letters
  int _wrongGuesses = 0; // Number of incorrect guesses
  final int _maxWrongGuesses = 6; // Allowed wrong attempts
  int _wins = 0; // Total wins
  int _losses = 0; // Total losses
  String _motivation = ''; // Message after win/loss
  bool _gameOver = false; // Whether current round ended

  // --- AUDIO AND ANIMATION ---
  final AudioPlayer _player = AudioPlayer(); // For success/fail sound effects
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation; // Fade-in for result message

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Smooth fade animation curve
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack);

    // Start the first round
    _resetGame();
  }

  // Resets the game for a new round
  void _resetGame() {
    setState(() {
      _selectedWord = _words[Random().nextInt(_words.length)];
      _guessedLetters.clear();
      _wrongGuesses = 0;
      _motivation = '';
      _gameOver = false;
      if (_controller.isAnimating) _controller.stop();
      _controller.reset();
    });
  }

  // Handles user letter guesses
  void _guessLetter(String letter) {
    if (_guessedLetters.contains(letter) || _gameOver) return;

    setState(() {
      _guessedLetters.add(letter);

      // If wrong letter → increase wrong count
      if (!_selectedWord.contains(letter)) {
        _wrongGuesses++;
      }

      // Check win/loss conditions
      if (_isWinner || _isLoser) {
        _motivation = _motivations[Random().nextInt(_motivations.length)];
        _controller.forward();
        _gameOver = true;

        if (_isWinner) {
          _wins++;
          _playSound('success.wav');
        } else {
          _losses++;
          _playSound('fail.wav');
        }
      }
    });
  }

  // Plays sound from assets (success/fail)
  Future<void> _playSound(String fileName) async {
    await _player.play(AssetSource(fileName));
  }

  // Check if user has guessed all letters
  bool get _isWinner =>
      _selectedWord.split('').every((letter) => _guessedLetters.contains(letter));

  // Check if user has exceeded max wrong guesses
  bool get _isLoser => _wrongGuesses >= _maxWrongGuesses;

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- RESPONSIVE SETTINGS ---
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 500;

    // Build word display (e.g., "_ _ A _ _ E")
    final displayWord = _selectedWord.split('').map((letter) {
      return _guessedLetters.contains(letter) ? letter : '_';
    }).join(' ');

    return Scaffold(
      body: Container(
        // Background gradient for better visual
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D83F2), Color(0xFFB77DE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            // Add padding dynamically for different screens
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 24,
              vertical: isSmallScreen ? 10 : 20,
            ),
            child: Container(
              // Card container (adjusts based on device width)
              width: isSmallScreen ? size.width * 0.95 : 450,
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 20 : 35,
                horizontal: isSmallScreen ? 16 : 30,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 20,
                    spreadRadius: 1,
                  )
                ],
              ),

              // --- MAIN COLUMN CONTENT ---
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lightbulb, color: Colors.amber, size: 40),
                  const SizedBox(height: 10),

                  // Game title
                  Text(
                    'Guess The Word',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 26 : 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(blurRadius: 10, color: Colors.black45),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  _buildScoreRow(isSmallScreen), // Scoreboard widget
                  const Divider(color: Colors.white24, thickness: 1, height: 25),

                  // Display hidden or revealed word
                  _buildWordDisplay(displayWord, isSmallScreen),
                  const SizedBox(height: 12),

                  // Wrong guess tracker
                  Text(
                    'Wrong guesses: $_wrongGuesses / $_maxWrongGuesses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 15 : 17,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Show letters already guessed
                  Text(
                    'Guessed: ${_guessedLetters.join(', ')}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: isSmallScreen ? 14 : 15,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // --- GAME RESULT AREA ---
                  if (_gameOver)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Win screen
                          if (_isWinner)
                            Text(
                              '🎉 YOU WON!',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 26 : 32,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                shadows: const [
                                  Shadow(blurRadius: 10, color: Colors.white)
                                ],
                              ),
                            )
                          // Lose screen
                          else
                            Column(
                              children: [
                                Text(
                                  '💀 GAME OVER!',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 26 : 32,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    shadows: const [
                                      Shadow(blurRadius: 10, color: Colors.white)
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'The word was: ${_selectedWord.toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 17 : 20,
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 15),

                          // Motivational text
                          Text(
                            _motivation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 18,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Play Again Button
                          ElevatedButton(
                            onPressed: _resetGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 30 : 40,
                                vertical: isSmallScreen ? 12 : 16,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text(
                              '🔁 Play Again',
                              style: TextStyle(
                                  fontSize: isSmallScreen ? 18 : 20,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  // --- ACTIVE GAME KEYBOARD ---
                  else
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double btnSize = isSmallScreen ? 40 : 48;
                            return Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 6,
                              runSpacing: 6,
                              children: 'QWERTYUIOPASDFGHJKLZXCVBNM'
                                  .split('')
                                  .map((letter) {
                                bool guessed =
                                    _guessedLetters.contains(letter);
                                return ElevatedButton(
                                  onPressed: guessed
                                      ? null
                                      : () => _guessLetter(letter),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: guessed
                                        ? Colors.white.withValues(alpha: 0.25)
                                        : Colors.amber,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: Size(btnSize, btnSize),
                                    maximumSize: Size(btnSize, btnSize),
                                    padding: EdgeInsets.zero,
                                    elevation: 3,
                                  ),
                                  child: Text(
                                    letter,
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 16 : 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),

                  const SizedBox(height: 25),
                  const Divider(color: Colors.white24, thickness: 1, height: 20),

                  // Footer credits
                  const Text(
                    "Made with 💙 in Flutter by Ekjot Kaur",
                    style: TextStyle(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- SCOREBOARD WIDGET ---
  Widget _buildScoreRow(bool isSmall) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        'Wins: $_wins   |   Losses: $_losses',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: isSmall ? 14 : 16,
        ),
      ),
    );
  }

  // --- DISPLAY WORD SECTION ---
  Widget _buildWordDisplay(String displayWord, bool isSmall) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 25 : 40,
        vertical: isSmall ? 15 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amberAccent, width: 2),
        boxShadow: const [
          BoxShadow(blurRadius: 15, spreadRadius: 1, color: Colors.white24),
        ],
      ),
      child: Text(
        displayWord,
        style: TextStyle(
          letterSpacing: isSmall ? 4 : 6,
          fontSize: isSmall ? 26 : 30,
          color: Colors.amberAccent,
          fontWeight: FontWeight.w700,
          shadows: const [
            Shadow(blurRadius: 8, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}