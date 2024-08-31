import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers package
import 'data.dart';
import 'dart:async';

class FlipCardGame extends StatefulWidget {
  final Level level;
  FlipCardGame(this.level);

  @override
  _FlipCardGameState createState() => _FlipCardGameState(level);
}

class _FlipCardGameState extends State<FlipCardGame> {
  _FlipCardGameState(this.level);

  final Level level;
  int _previousIndex = -1;
  bool _flip = false;
  bool _start = false;
  bool _wait = false;
  Timer? _timer;
  int _time = 5;
  int? _left;
  int _remainingAttempts = 3; // Default attempts
  bool _isFinished = false;
  String _resultMessage = ''; // Added for result message
  late List<String> _data;
  late List<bool> _cardFlips;
  late List<GlobalKey<FlipCardState>> _cardStateKeys;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize audio player
  bool _isPlaying = false; // Track if the sound is playing

  @override
  void initState() {
    super.initState();
    restart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 3,
            spreadRadius: 0.8,
            offset: Offset(2.0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.all(4.0),
      child: Image.asset(_data[index]),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (_time > 0) {
          _time--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void restart() {
    startTimer();

    // Duplicate each image to create pairs
    _data = getSourceArray(level).cast<String>();
    _data = List.from(_data)..addAll(_data); // Duplicate images

    _data.shuffle(); // Shuffle to randomize the positions

    _cardFlips = List<bool>.filled(_data.length, true);
    _cardStateKeys = List.generate(_data.length, (index) => GlobalKey<FlipCardState>());
    _time = 5;
    _left = (_data.length ~/ 2);

    // Set attempts based on level
    _remainingAttempts = level == Level.Easy ? 5 : 3; // Default attempts for other levels

    _isFinished = false;
    _resultMessage = ''; // Reset result message

    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        _start = true;
        _timer?.cancel();
      });
    });
  }

  void _handleCardFlip(int index) {
    if (_wait || _remainingAttempts <= 0) return;

    setState(() {
      if (!_flip) {
        _flip = true;
        _previousIndex = index;
      } else {
        _flip = false;
        if (_previousIndex != index) {
          if (_data[_previousIndex] != _data[index]) {
            _wait = true;
            _remainingAttempts--; // Decrement attempts here
            Future.delayed(const Duration(milliseconds: 1500), () {
              _cardStateKeys[_previousIndex].currentState?.toggleCard();
              _cardStateKeys[index].currentState?.toggleCard();
              _previousIndex = index;
              setState(() {
                _wait = false;
                if (_remainingAttempts <= 0) {
                  _isFinished = true; // End the game if no attempts are left
                  _start = false;
                  _audioPlayer.stop(); // Stop the sound when game ends
                  if (_cardFlips.every((t) => !t)) {
                    _resultMessage = 'Congrats! You matched all cards!';
                    _playApplause(); // Play applause sound on win
                  } else {
                    _resultMessage = 'Game Over!';
                    _playLossSound(); // Play loss sound on game over
                  }
                }
              });
            });
          } else {
            _cardFlips[_previousIndex] = false;
            _cardFlips[index] = false;
            setState(() {
              _left = (_left ?? 0) - 1;
              if (_cardFlips.every((t) => !t)) {
                Future.delayed(const Duration(milliseconds: 160), () {
                  setState(() {
                    _isFinished = true;
                    _start = false;
                    _audioPlayer.stop(); // Stop the sound when game ends
                    _resultMessage = 'Congrats! You matched all cards!';
                    _playApplause(); // Play applause sound on win
                  });
                });
              }
            });
          }
        }
      }
    });
  }

  void _toggleSound() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause(); // Pause if playing
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play('assets/audio/kid.mp3', isLocal: true); // Play if paused
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      print('Error toggling sound: $e');
    }
  }

  void _playApplause() async {
    try {
      await _audioPlayer.play('assets/audio/applause.mp3', isLocal: true); // Play applause sound
    } catch (e) {
      print('Error playing applause sound: $e');
    }
  }

  void _playLossSound() async {
    try {
      await _audioPlayer.play('assets/audio/sad.mp3', isLocal: true); // Play loss sound
    } catch (e) {
      print('Error playing loss sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'assets/asd1.jpg', // Ensure this path is correct and the file exists
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
            _isFinished
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _resultMessage,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _resultMessage.contains('Congrats')
                          ? Colors.green // Color for "Congrats" message
                          : Colors.red, // Color for "Game Over" message
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        restart();
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "Play Again",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to the previous screen
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        "Back to Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
                : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _time > 0
                          ? Text(
                        '$_time',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.white), // Ensure text is visible on background
                      )
                          : Text(
                        'Attempts left: $_remainingAttempts',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: Colors.white), // Ensure text is visible on background
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.volume_up : Icons.volume_off,
                          size: 48.0,
                          color: Colors.blue,
                        ),
                        onPressed: _toggleSound, // Toggle sound when pressed
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: level == Level.Easy ? 3 : level == Level.Medium ? 4 : 4,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemBuilder: (context, index) => _start
                            ? FlipCard(
                          key: _cardStateKeys[index],
                          onFlip: () => _handleCardFlip(index),
                          flipOnTouch: !_wait && _cardFlips[index],
                          direction: FlipDirection.HORIZONTAL,
                          front: Container(
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 3,
                                  spreadRadius: 0.8,
                                  offset: Offset(2.0, 1),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.all(4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                'assets/artwork3.png',
                              ),
                            ),
                          ),
                          back: getItem(index),
                        )
                            : getItem(index),
                        itemCount: _data.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
