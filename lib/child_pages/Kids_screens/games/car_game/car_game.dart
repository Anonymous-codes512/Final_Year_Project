import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: KidCarGame(),
  ));
}

class KidCarGame extends StatefulWidget {
  const KidCarGame({super.key});

  @override
  _KidCarGameState createState() => _KidCarGameState();
}

class _KidCarGameState extends State<KidCarGame> {
  // Number of lanes (roads): now set to 3.
  final int roadsCount = 3;
  // Car parameters.
  double carWidth = 50;
  double carHeight = 50;
  late double carX = 0; // Horizontal center position (within padded area).
  late double carY =
      0; // Vertical position (fixed above the bottom control area).
  // Game state.
  double score = 0;
  List<Ball> balls = [];
  Timer? gameTimer;
  Timer? ballSpawnTimer;
  final Random random = Random();
  bool isGameOver = false;

  @override
  void initState() {
    super.initState();
    // Start a timer to update ball positions.
    gameTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!isGameOver) updateBalls();
    });
    // Spawn new balls periodically.
    ballSpawnTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isGameOver) spawnBall();
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    ballSpawnTimer?.cancel();
    super.dispose();
  }

  /// Update each ball's vertical position and check for collisions.
  void updateBalls() {
    setState(() {
      List<Ball> toRemove = [];
      // Calculate padded width (screen width minus 100, for 50 padding each side).
      double paddedWidth = MediaQuery.of(context).size.width - 100;
      double screenHeight = MediaQuery.of(context).size.height;
      double laneWidth = paddedWidth / roadsCount;

      for (var ball in balls) {
        ball.y += ball.speed;
        // If the ball has reached the car's vertical position...
        if (ball.y + ball.size >= carY) {
          double ballXCenter = ball.lane * laneWidth + laneWidth / 2;
          if ((ballXCenter - carX).abs() < (carWidth / 2 + ball.size / 2)) {
            // Collision detected.
            if (ball.isBomb) {
              gameOver();
              return;
            } else {
              score += ball.number;
              toRemove.add(ball);
            }
          }
        }
        // Remove ball if it goes off the bottom.
        if (ball.y > screenHeight) {
          toRemove.add(ball);
        }
      }
      balls.removeWhere((ball) => toRemove.contains(ball));
    });
  }

  /// Spawn a new falling object with a random lane.
  void spawnBall() {
    // double paddedWidth = MediaQuery.of(context).size.width - 100;
    // double laneWidth = paddedWidth / roadsCount;
    int lane = random.nextInt(roadsCount);
    // 20% chance to spawn a bomb.
    bool spawnBomb = random.nextDouble() < 0.2;
    double speed =
        random.nextDouble() * 1 + 1; // Speed between 1 and 2 (slower)
    Ball ball;
    if (spawnBomb) {
      ball = Ball(
        lane: lane,
        number: 0,
        y: 0,
        size: 30,
        speed: speed,
        isBomb: true,
      );
    } else {
      int number = random.nextInt(9) + 1; // Number between 1 and 9.
      ball = Ball(
        lane: lane,
        number: number,
        y: 0,
        size: 30,
        speed: speed,
        isBomb: false,
      );
    }
    setState(() {
      balls.add(ball);
    });
  }

  /// Ends the game by canceling timers and showing a Game Over dialog.
  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    gameTimer?.cancel();
    ballSpawnTimer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Your score: ${score.toInt()}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Returns a color based on the ball's number.
  Color getBallColor(int number) {
    switch (number) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return const Color.fromARGB(255, 72, 59, 255);
      case 4:
        return Colors.green;
      case 5:
        return Colors.blue;
      case 6:
        return Colors.indigo;
      case 7:
        return Colors.purple;
      case 8:
        return Colors.pink;
      case 9:
        return Colors.teal;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use padded width: screen width minus 100 (50 each side).
    double paddedWidth = MediaQuery.of(context).size.width - 100;
    double laneWidth = paddedWidth / roadsCount;

    return Scaffold(
      // Background image fills the full phone.
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: const AssetImage('assets/gamebg.jpg'),
              repeat: ImageRepeat.repeat),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Position the car above the 100-height bottom control area.
              carY = constraints.maxHeight - carHeight - 100;
              // Initialize carX at the center of the padded area if not set.
              carX = carX == 0 ? paddedWidth / 2 : carX;

              return Stack(
                children: [
                  // Draw road lanes using a custom painter.
                  for (int i = 0; i < roadsCount; i++)
                    Positioned(
                      left: i * laneWidth,
                      top: 0,
                      width: laneWidth,
                      height: constraints.maxHeight,
                      child: CustomPaint(
                        painter: LanePainter(),
                      ),
                    ),
                  // Draw falling balls or bombs.
                  for (var ball in balls)
                    Positioned(
                      left:
                          ball.lane * laneWidth + laneWidth / 2 - ball.size / 2,
                      top: ball.y,
                      child: Container(
                        width: ball.size,
                        height: ball.size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ball.isBomb
                              ? Colors.black
                              : getBallColor(ball.number),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: ball.isBomb
                            ? const Text(
                                "💣",
                                style: TextStyle(fontSize: 18),
                              )
                            : Text(
                                '${ball.number}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  // Draw the car using an image.
                  Positioned(
                    left: carX - carWidth / 2,
                    top: carY,
                    bottom: 0,
                    child: Transform.rotate(
                      angle:
                          3.15, // Rotate in radians (e.g., pi/2 for 90 degrees)
                      child: Image.asset(
                        'assets/games/red car.png',
                        fit: BoxFit.contain,
                        width: carWidth,
                        height: carHeight,
                      ),
                    ),
                  ),
                  // Display score at the top.
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      color: const Color.fromARGB(203, 0, 0, 0),
                      alignment: Alignment.center,
                      child: Text(
                        'Score: ${score.toInt()}',
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      // Bottom control area: a green progress bar with a draggable ball.
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          // Use the same padded width as in the game body.
          double paddedWidth = MediaQuery.of(context).size.width - 100;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            width: paddedWidth,
            height: 100,
            color: Colors.green,
            child: Stack(
              children: [
                // The full-width horizontal white line.
                Positioned(
                  left: 0,
                  right: 0,
                  top: 50 - 2, // Centered vertically.
                  child: Container(
                    height: 6,
                    color: Colors.white,
                  ),
                ),
                // Draggable ball control.
                // Note: subtracting 25 centers the ball (its width is 50).
                Positioned(
                  left: carX - 25,
                  top: 50 - 25,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        carX += details.delta.dx;
                        // Clamp within the full width of the white line.
                        carX = carX.clamp(
                            carWidth / 2, paddedWidth - carWidth / 2);
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      child: const Center(
                        child: Text(
                          "⚽",
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter to draw a lane that looks like a real road.
class LanePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint roadPaint = Paint()..color = Colors.grey[800]!;
    canvas.drawRect(Offset.zero & size, roadPaint);

    final Paint borderPaint = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = 3;
    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), borderPaint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, size.height), borderPaint);

    final Paint dashPaint = Paint()
      ..color = const Color(0xFFE6C616)
      ..strokeWidth = 2;
    double dashWidth = 10;
    double dashSpace = 15;
    double startY = 0;
    double centerX = size.width / 2;
    while (startY < size.height) {
      canvas.drawLine(Offset(centerX, startY),
          Offset(centerX, startY + dashWidth), dashPaint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Class representing a falling ball or bomb.
class Ball {
  int lane;
  int number;
  double y;
  double size;
  double speed;
  bool isBomb;
  Ball({
    required this.lane,
    required this.number,
    required this.y,
    required this.size,
    required this.speed,
    this.isBomb = false,
  });
}
