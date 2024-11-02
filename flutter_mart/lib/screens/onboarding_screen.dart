import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'signup_login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GFIntroScreen(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      showIntroScreenBottomNavigationBar: true,
      pageController: _pageController,
      currentIndex: _currentIndex,
      pageCount: 3,
      introScreenBottomNavigationBar: GFIntroScreenBottomNavigationBar(
        pageController: _pageController,
        currentIndex: _currentIndex,
        pageCount: 3,
        backButtonText: 'Back',
        skipButtonText: 'Skip',
        doneButtonText: 'Get Started',
        onSkipTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpLoginScreen()),
          );
        },
        onDoneTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpLoginScreen()),
          );
        },
      ),
      slides: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  Icons.shopping_bag,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome to FlutterMart',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  decoration: TextDecoration.none, // Ensure no underline
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Your ultimate shopping companion',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.none, // Ensure no underline
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_shipping, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 40),
              const Text(
                'Fast Shipping',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Get your products delivered quickly',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.support_agent, size: 100, color: Colors.blueAccent),
              const SizedBox(height: 40),
              const Text(
                '24/7 Support',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'We are here to assist you anytime',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}