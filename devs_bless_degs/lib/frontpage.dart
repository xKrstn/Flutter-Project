import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'homepage.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.network(
            'assets/asd.jpg', // Your background image path
            fit: BoxFit.cover, // Cover the entire screen
          ),
          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlipCard(
                  key: _cardKey,
                  direction: FlipDirection.HORIZONTAL,
                  front: Image.network(
                    'assets/artwork3.png', // Your front image path
                    width: 300, // Adjust the width as needed
                    height: 300, // Adjust the height as needed
                  ),
                  back: Image.network(
                    'assets/logo-back.png', // Your back image path
                    width: 300, // Adjust the width as needed
                    height: 300, // Adjust the height as needed
                  ),
                  onFlip: () {
                    print('Card flipped'); // Optional: handle the flip event
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Flip Your Way to Sharper Memory!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.8),
                        offset: Offset(2, 2),
                        blurRadius: 2,
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(-2, -2),
                        blurRadius: 2,
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(2, -2),
                        blurRadius: 2,
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(-2, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: Text(
                    'Start Game',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue, // Text color
                      fontFamily: 'Knewave', // Custom font family
                      fontWeight: FontWeight.bold, // Optional: change font weight
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.yellow, // Background color
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue, width: 2), // Border color and width
                      borderRadius: BorderRadius.circular(12), // Border radius
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}