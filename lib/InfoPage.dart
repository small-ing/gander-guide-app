// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  final List<Person> persons = [
    Person(name: 'Jacob Huser', url: 'https://www.linkedin.com/in/jacobhuser'),
    Person(
        name: 'Alan Joseph',
        url: 'https://www.linkedin.com/in/alan-joseph-853047284/'),
    Person(
        name: 'Alex Montello',
        url: 'https://www.youtube.com/watch?v=BBJa32lCaaY'),
    Person(
        name: 'Richard Vick',
        url: 'https://www.linkedin.com/in/richard-vick-9901a3284/'),
    Person(name: 'Stephanie Wan', url: 'https://swan07.vercel.app/'),
    Person(
        name: 'Kyle Wisnieski',
        url: 'https://www.linkedin.com/in/kyle-wisnieski-37b2b7283/'),
    Person(
        name: 'Travis Smalling',
        url: 'https://www.linkedin.com/in/jack-smalling-1b1093201/'),
  ];

  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: 100), // Add padding at the top to shift content down
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 56,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 56 *
                          0.15 // Adjust the fraction as needed for the thickness
                      ..color = Color(0xFF3E235D),
                  ),
                ),
                Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 56,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This app was developed by the Gleeful Geese at AI Camp:',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: persons.length,
                itemBuilder: (context, index) {
                  return HyperlinkedPanel(
                    name: persons[index].name,
                    url: persons[index].url,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Person {
  final String name;
  final String url;

  Person({required this.name, required this.url});
}

class HyperlinkedPanel extends StatelessWidget {
  final String name;
  final String url;

  const HyperlinkedPanel({super.key, required this.name, required this.url});

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchURL,
      child: Card(
        color: Color(0xFF3E235D), // Set the desired background color here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              name,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
