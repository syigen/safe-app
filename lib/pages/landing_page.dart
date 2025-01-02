import 'package:flutter/material.dart';

// Landing Page
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          BackgroundImage(),
          LogoSection(),
          TextContent(),
          BottomButton(),
        ],
      ),
    );
  }
}

// Background Image
class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Center Logo
class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 215),
        Center(
          child: SizedBox(
            width: 220,
            height: 220,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

// Text Content
class TextContent extends StatelessWidget {
  const TextContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        SizedBox(height: 700),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Safe App',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Your ultimate guide to\nhuman-wildlife coexistence',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}

// Button to navigate to the next screen
class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 40.0,
          left: 10.0,
          right: 10.0,
          top: 0.0,
        ),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the login page screen
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00DF81),
            minimumSize: const Size(380, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: const Text(
            'Get Started Now',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
