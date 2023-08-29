import 'package:evoucher/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_intro_screen/onboarding_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    // device width
    final double dWidth = MediaQuery.of(context).size.width;

    return OnBoardingScreen(
      onSkip: () {
        debugPrint("On Skip Called....");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      showPrevNextButton: true,
      showIndicator: true,
      backgourndColor: Colors.white,
      activeDotColor: Colors.blue,
      deactiveDotColor: Colors.grey,
      iconColor: Colors.black,
      leftIcon: Icons.arrow_circle_left_rounded,
      rightIcon: Icons.arrow_circle_right_rounded,
      iconSize: 30,
      pages: [
        OnBoardingModel(
          image: Image.asset("assets/images/event.png", width: dWidth * 0.85),
          title: "Event Management",
          body:
              "Manage your virtual events and vouchers on the go with our eVoucher.",
        ),
        OnBoardingModel(
          image: Image.asset("assets/images/food.png", width: dWidth * 0.85),
          title: "Dine With No Money",
          body:
              "Dine at your favourite restaurants with no money. Just redeem the eVoucher or scan the QR code and enjoy your meal.",
        ),
        OnBoardingModel(
          image: Image.asset("assets/images/payment.png"),
          title: "Boost Your Sales",
          body:
              "Sign up as a partner restaurant to boost your sales with our eVoucher system.",
        ),
      ],
    );
  }
}
