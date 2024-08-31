import 'package:flutter/material.dart';
import 'flipcardgame.dart';
import 'data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              'assets/asd1.jpg', // Path to your background image
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEVEL text at the top
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Text(
                    'LEVELS',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                // ListView to display items
                Expanded(
                  child: ListView.builder(
                    itemCount: detailsList.length,
                    itemBuilder: (context, index) {
                      final detail = detailsList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => detail.goto!,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0), // Top margin for each item
                          child: Center(
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: detail.secondaryColor,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black45,
                                    spreadRadius: 0.5,
                                    offset: Offset(3, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 90,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: detail.primaryColor,
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Colors.black12,
                                          spreadRadius: 0.3,
                                          offset: Offset(3, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            detail.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black26,
                                                  blurRadius: 2,
                                                  offset: Offset(1, 2),
                                                ),
                                                Shadow(
                                                  color: Colors.green,
                                                  blurRadius: 2,
                                                  offset: Offset(0.5, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: generateStars(detail.noOfStars),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> generateStars(int? noOfStars) {
    return List.generate(
      noOfStars ?? 0,
          (index) => const Icon(Icons.star, color: Colors.yellow, size: 40),
    );
  }
}

class Details {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Widget? goto;
  final int? noOfStars;

  Details({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    this.goto,
    this.noOfStars,
  });
}

List<Details> detailsList = [
  Details(
    name: "EASY",
    primaryColor: Colors.green,
    secondaryColor: Colors.green[300]!,
    noOfStars: 1,
    goto: FlipCardGame(Level.Easy),
  ),
  Details(
    name: "MEDIUM",
    primaryColor: Colors.orange,
    secondaryColor: Colors.orange[300]!,
    noOfStars: 2,
    goto: FlipCardGame(Level.Medium),
  ),
  Details(
    name: "HARD",
    primaryColor: Colors.red,
    secondaryColor: Colors.red[300]!,
    noOfStars: 3,
    goto: FlipCardGame(Level.Hard),
  ),
];