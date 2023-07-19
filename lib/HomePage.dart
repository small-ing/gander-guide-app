import 'package:flutter/material.dart';
import 'CameraPage.dart';
import 'InfoPage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          HomePageContent(),
          CameraPage(),
          InfoPage(),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color(0xFF14141C),
        color: Color(0xFF3E235D),
        index: _selectedIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white,),
          Icon(Icons.camera_alt, size: 30, color: Colors.white,),
          Icon(Icons.info, size: 30, color: Colors.white,),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            OutlinedText(
              text: 'Gander Guide',
              fontSize: 56,
              outlineColor: Color(0xFF3E235D),
              textColor: Colors.white,
              strokeWidth: 6, // Adjust the strokeWidth as needed for the thickness
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(top: 80),
              child: Image(image: AssetImage('images/GooseStar.png')),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

class OutlinedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color outlineColor;
  final Color textColor;
  final double strokeWidth;

  OutlinedText({
    required this.text,
    required this.fontSize,
    required this.outlineColor,
    required this.textColor,
    required this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = outlineColor,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ],
    );
  }
}