import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(PongGame());
}

class PongGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuScreen(), // Zmieniamy na MenuScreen
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pong',
              style: TextStyle(color: Colors.white, fontSize: 36),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settingsscreen()),
                );
              },
              child: Text('Start Game'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Wyjście z aplikacji
                exit(0);
              },
              child: Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}

class Settingsscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose level',
              style: TextStyle(color: Colors.white, fontSize: 36),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(1)),
                );
              },
              child: Text('Easy'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(2)),
                );
              },
              child: Text('Medium'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(3)),
                );
              },
              child: Text('Hard'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final double poziom;
  GameScreen(this.poziom);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Pilka pilka;
  late Paletka paletkaGracza;
  late Paletka paletkaKomputera;
  Timer? timer;
  bool ruchPilki = true;
  double poziom = 2;

  int wynikGracza = 0; // Wynik gracza
  int wynikKomputera = 0; // Wynik komputera

  static const double screenWidth = 400; // Szerokość w pikselach
  static const double screenHeight = 600; // Wysokość w pikselach

  double scaleX = 1.0;
  double scaleY = 1.0;

  @override
  void initState() {
    super.initState();
    pilka = Pilka(screenWidth / 2, screenHeight / 2);
    paletkaGracza = Paletka(screenWidth / 2, screenHeight - 50, isPlayer: true); // Gracz na dole
    paletkaKomputera = Paletka(screenWidth / 2, 50, isPlayer: false); // Komputer na górze
    startGame(widget.poziom);
  }

  void startGame(double poziom) {
    Future.delayed(Duration(seconds: 1), () {
    timer = Timer.periodic(Duration(milliseconds: 16), (Timer timer) {
      setState(() {
        if (ruchPilki) {
          // Aktualizacja pozycji piłki
          pilka.ruch();

          // Odbicie od lewej i prawej krawędzi
          if (pilka.x - pilka.promien <= 0 || pilka.x + pilka.promien >= screenWidth) {
            pilka.predkosc_x = -pilka.predkosc_x;
          }

          // Odbicie od paletki gracza
          if (pilka.y + pilka.promien >= paletkaGracza.y &&
              pilka.y - pilka.promien <= paletkaGracza.y + paletkaGracza.szerokosc &&
              pilka.x + pilka.promien >= paletkaGracza.x &&
              pilka.x - pilka.promien <= paletkaGracza.x + paletkaGracza.dlugosc) {

            // Kolizja z górą paletki
            if (pilka.y <= paletkaGracza.y) {
              pilka.predkosc_y = -pilka.predkosc_y; // Odbicie w górę
              pilka.y = paletkaGracza.y - pilka.promien; // Ustaw piłkę nad paletką
            }
            // Kolizja z dołem paletki
            else if (pilka.y >= paletkaGracza.y + paletkaGracza.szerokosc) {
              pilka.predkosc_y = -pilka.predkosc_y; // Odbicie w dół
              pilka.y = paletkaGracza.y + paletkaGracza.szerokosc + pilka.promien; // Ustaw piłkę pod paletką
            }

            // Odbicie w poziomie
            if (pilka.x <= paletkaGracza.x) {
              pilka.predkosc_x = -pilka.predkosc_x; // Odbicie w lewo
              pilka.x = paletkaGracza.x - pilka.promien; // Ustaw piłkę na lewo od paletki
            } else if (pilka.x >= paletkaGracza.x + paletkaGracza.dlugosc) {
              pilka.predkosc_x = -pilka.predkosc_x; // Odbicie w prawo
              pilka.x = paletkaGracza.x + paletkaGracza.dlugosc + pilka.promien; // Ustaw piłkę na prawo od paletki
            }
          }

          // Odbicie od paletki komputera
          if (pilka.y - pilka.promien <= paletkaKomputera.y + paletkaKomputera.szerokosc &&
              pilka.y + pilka.promien >= paletkaKomputera.y &&
              pilka.x + pilka.promien >= paletkaKomputera.x &&
              pilka.x - pilka.promien <= paletkaKomputera.x + paletkaKomputera.dlugosc) {

            // Kolizja z górą paletki
            if (pilka.y <= paletkaKomputera.y) {
              pilka.predkosc_y = -pilka.predkosc_y; // Odbicie w górę
              pilka.y = paletkaKomputera.y - pilka.promien; // Ustaw piłkę nad paletką
            }
            // Kolizja z dołem paletki
            else if (pilka.y >= paletkaKomputera.y + paletkaKomputera.szerokosc) {
              pilka.predkosc_y = -pilka.predkosc_y; // Odbicie w dół
              pilka.y = paletkaKomputera.y + paletkaKomputera.szerokosc + pilka.promien; // Ustaw piłkę pod paletką
            }

          // Odbicie w poziomie
          if (pilka.x <= paletkaKomputera.x) {
            pilka.predkosc_x = -pilka.predkosc_x; // Odbicie w lewo
            pilka.x = paletkaKomputera.x - pilka.promien; // Ustaw piłkę na lewo od paletki
          } else if (pilka.x >= paletkaKomputera.x + paletkaKomputera.dlugosc) {
            pilka.predkosc_x = -pilka.predkosc_x; // Odbicie w prawo
            pilka.x = paletkaKomputera.x + paletkaKomputera.dlugosc + pilka.promien; // Ustaw piłkę na prawo od paletki
          }
        }

          // Sprawdzanie, czy ktoś zdobył punkt
          punktacja();
        }

        // Ruch paletki komputera
        paletkaKomputera.aiMove(pilka, screenHeight, screenWidth, poziom);
      });
    });
  });
  }

  void punktacja() {
    // Gracz zdobywa punkt
    if (pilka.y - pilka.promien <= 0) {
      wynikGracza++;
      pilka.reset(screenWidth / 2, 150); // Reset piłki w kierunku gracza
      ruchPilki = false; // Zatrzymanie ruchu piłki
      Future.delayed(Duration(seconds: 1), () => ruchPilki = true); // Wznowienie ruchu po sekundzie
    }

    // Komputer zdobywa punkt
    if (pilka.y + pilka.promien >= screenHeight) {
      wynikKomputera++;
      pilka.reset(screenWidth / 2, screenHeight - 150); // Reset piłki w kierunku komputera
      ruchPilki = false; // Zatrzymanie ruchu piłki
      Future.delayed(Duration(seconds: 1), () => ruchPilki = true); // Wznowienie ruchu po sekundzie
    }
  }

  void movePaddle(double dx) {
    setState(() {
      paletkaGracza.move(dx); // Ruch w poziomie
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget wyswietlWynik() {
    return Positioned(
      top: 15,
      left: screenWidth *scaleX / 2 - 25,
      child: Text(
        '$wynikGracza : $wynikKomputera',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        // Pobieranie wymiarów okna
    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;

    // Obliczanie współczynników skalowania
    scaleX = windowWidth / screenWidth;
    scaleY = windowHeight / screenHeight;

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          movePaddle(details.delta.dx); // Ruch w poziomie
        },
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child: CustomPaint(
                painter: PongPainter(pilka, paletkaGracza, paletkaKomputera, scaleX, scaleY, screenWidth, screenHeight),
                child: Container(), // Dodanie pustego kontenera
              ),
            ),
            wyswietlWynik(), // Wyświetlenie wyniku
                      Positioned(
            top: 0,
            left: 0,
            child: TextButton(
              onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent, // Kolor tła przycisku
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              child: Text("X"),
            ),
          ),
          ],
        ),
      ),
    );
  }
}

// Reszta kodu pozostaje taka sama
class PongPainter extends CustomPainter {
  final Pilka pilka;
  final Paletka paletkaGracza;
  final Paletka paletkaKomputera;
  final double screenWidth;
  final double screenHeight;
  final double scaleX;
  final double scaleY;

  PongPainter(this.pilka, this.paletkaGracza, this.paletkaKomputera, this.scaleX, this.scaleY, this.screenWidth, this.screenHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    // Rysowanie piłki
    canvas.drawCircle(
      Offset(pilka.x * scaleX, pilka.y *scaleY),
      pilka.promien * scaleX,
      paint,
    );

    // Rysowanie paletki gracza
    canvas.drawRect(
      Rect.fromLTWH(paletkaGracza.x * scaleX, paletkaGracza.y * scaleY, paletkaGracza.dlugosc * scaleX, paletkaGracza.szerokosc * scaleY),
      paint,
    );

    // Rysowanie paletki komputera
    canvas.drawRect(
      Rect.fromLTWH(paletkaKomputera.x * scaleX, paletkaKomputera.y * scaleY, paletkaKomputera.dlugosc * scaleX, paletkaKomputera.szerokosc * scaleY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Paletka {
  double x;
  double y;
  double dlugosc = 100; // Długość w pikselach
  double szerokosc = 10; // Szerokość w pikselach
  double predkosc = 2;

  Paletka(this.x, this.y, {required bool isPlayer}) {
    if (isPlayer) {
      y = 500; // Gracz na dole
    } else {
      y = 50; // Komputer na górze
    }
  }

  void move(double dx) {
    x += dx;
    // Ograniczenia ruchu paletki gracza
    if (x < 0) {
      x = 0; // Lewa krawędź ekranu
    }
    if (x > 400 - dlugosc) {
      x = 400 - dlugosc; // Prawa krawędź ekranu
    }
  }

void aiMove(Pilka pilka, double height, double width, double poziom) {
  if (pilka.y > height / 2) {
    x += predkosc; // Stały ruch w jednym kierunku, gdy piłka jest na połowie gracza

    if (x + dlugosc >= width) {
      x = width - dlugosc; // Zatrzymanie na prawej krawędzi
      predkosc = -predkosc; // Zmiana kierunku na lewo
    } else if (x <= 0) {
      x = 0; // Zatrzymanie na lewej krawędzi
      predkosc = -predkosc; // Zmiana kierunku na prawo
    }
  } else if (pilka.y < height / 2) {
    // Paletka porusza się w kierunku piłki, gdy jest ona na górnej połowie
    double odlegloscDoPilki = pilka.x - (x + dlugosc / 2);

    if (odlegloscDoPilki.abs() > 50) { // Jeśli piłka jest dalej niż 50 pikseli
      if (odlegloscDoPilki < 0) {
        x -= poziom; // Szybszy ruch w lewo
      } else {
        x += poziom; // Szybszy ruch w prawo
      }
    } else { // Wolniejszy ruch, gdy piłka jest blisko
      if (odlegloscDoPilki < 0) {
        x -= poziom; // Wolniejszy ruch w lewo
      } else {
        x += poziom; // Wolniejszy ruch w prawo
      }
    }

    // Ograniczenia ruchu AI
    if (x < 0) {
      x = 0; // Lewa krawędź ekranu
    }
    if (x > width - dlugosc) {
      x = width - dlugosc; // Prawa krawędź ekranu
      }
    }
  }
}

class Pilka {
  double x;
  double y;
  double promien = 10; // Promień w pikselach
  double predkosc_x = 3;
  double predkosc_y = 4;

  Pilka(this.x, this.y);

  void ruch() {
    x += predkosc_x;
    y += predkosc_y;
  }

  void reset(double startX, double startY) {
    x = startX;
    y = startY;
  }
}