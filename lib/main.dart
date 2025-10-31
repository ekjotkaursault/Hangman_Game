import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const GuessWordApp());
}

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

class GuessWordGame extends StatefulWidget {
  const GuessWordGame({super.key});

  @override
  State<GuessWordGame> createState() => _GuessWordGameState();
}

class _GuessWordGameState extends State<GuessWordGame>
    with SingleTickerProviderStateMixin {
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

  final List<String> _motivations = [
    'Keep going! You’ll get it next time 💪',
    'Don’t give up, champion 🌟',
    'You’re improving every try 🔥',
    'That was close! Try again 😄',
    'Winners never quit 💫',
    'Great effort! 👏'
  ];

  late String _selectedWord;
  final List<String> _guessedLetters = [];
  int _wrongGuesses = 0;
  final int _maxWrongGuesses = 6;
  int _wins = 0;
  int _losses = 0;
  String _motivation = '';
  bool _gameOver = false;

  final AudioPlayer _player = AudioPlayer();
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack);
    _resetGame();
  }

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

  void _guessLetter(String letter) {
    if (_guessedLetters.contains(letter) || _gameOver) return;

    setState(() {
      _guessedLetters.add(letter);
      if (!_selectedWord.contains(letter)) {
        _wrongGuesses++;
      }

      if (_isWinner || _isLoser) {
        _motivation = _motivations[Random().nextInt(_motivations.length)];
        _controller.forward();
        _gameOver = true;

        if (_isWinner) {
          _wins++;
          _playSound('success.wav');
        } else if (_isLoser) {
          _losses++;
          _playSound('fail.wav');
        }
      }
    });
  }

  Future<void> _playSound(String fileName) async {
    await _player.play(AssetSource(fileName));
  }

  bool get _isWinner =>
      _selectedWord.split('').every((letter) => _guessedLetters.contains(letter));

  bool get _isLoser => _wrongGuesses >= _maxWrongGuesses;

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayWord = _selectedWord.split('').map((letter) {
      return _guessedLetters.contains(letter) ? letter : '_';
    }).join(' ');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D83F2), Color(0xFFB77DE0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width < 500
                  ? MediaQuery.of(context).size.width * 0.9
                  : 420,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.lightbulb, color: Colors.amber, size: 40),
                  const SizedBox(height: 10),
                  const Text(
                    'Guess The Word',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 10, color: Colors.black45),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildScoreRow(),
                  const Divider(color: Colors.white24, thickness: 1, height: 25),
                  _buildWordDisplay(displayWord),
                  const SizedBox(height: 12),
                  Text(
                    'Wrong guesses: $_wrongGuesses / $_maxWrongGuesses',
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Guessed: ${_guessedLetters.join(', ')}',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  const SizedBox(height: 25),

                  if (_gameOver)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          if (_isWinner)
                            const Text(
                              '🎉 YOU WON!',
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.white)
                                ],
                              ),
                            )
                          else
                            Column(
                              children: [
                                const Text(
                                  '💀 GAME OVER!',
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(blurRadius: 10, color: Colors.white)
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'The word was: ${_selectedWord.toUpperCase()}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          Text(
                            _motivation,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: _resetGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: const Text(
                              '🔁 Play Again',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          runSpacing: 6,
                          children:
                              'QWERTYUIOPASDFGHJKLZXCVBNM'.split('').map((letter) {
                            bool guessed = _guessedLetters.contains(letter);
                            return ElevatedButton(
                              onPressed: guessed ? null : () => _guessLetter(letter),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: guessed
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(45, 45),
                                maximumSize: const Size(50, 50),
                                padding: EdgeInsets.zero,
                                elevation: 3,
                              ),
                              child: Text(
                                letter,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  const SizedBox(height: 25),
                  const Divider(color: Colors.white24, thickness: 1, height: 20),
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

  Widget _buildScoreRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        'Wins: $_wins   |   Losses: $_losses',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }

  Widget _buildWordDisplay(String displayWord) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
        style: const TextStyle(
          letterSpacing: 6,
          fontSize: 30,
          color: Colors.amberAccent,
          fontWeight: FontWeight.w700,
          shadows: [
            Shadow(blurRadius: 8, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
