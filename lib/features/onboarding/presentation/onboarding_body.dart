import 'package:flutter/material.dart';
import '../../authentication/presentation/login/login_screen.dart';
import 'package:e_commerce/core/utils/responsive.dart';
import 'package:e_commerce/features/onboarding/widgets/back_button.dart';
import 'package:e_commerce/features/onboarding/widgets/next_button.dart';
import 'package:e_commerce/features/onboarding/widgets/onboarding_page.dart';
import 'package:e_commerce/features/onboarding/widgets/page_indicator.dart';
import 'package:e_commerce/features/onboarding/widgets/skip_button.dart';

class OnBoardingBody extends StatefulWidget {
  const OnBoardingBody({super.key});

  @override
  State<OnBoardingBody> createState() => _OnBoardingBodyState();
}

class _OnBoardingBodyState extends State<OnBoardingBody> {
  late final PageController _controller;

  int currentPage = 0;

  final List<Map<String, dynamic>> pages = [
    {
      "title": "Discover",
      "description":
          "Explore thousands of premium products from your favorite brands.",
      "icon": Icons.shopping_bag_rounded,
    },
    {
      "title": "Fast Delivery",
      "description": "Track your orders in real time and receive them quickly.",
      "icon": Icons.local_shipping_rounded,
    },
    {
      "title": "Secure Payment",
      "description": "Pay securely using multiple payment methods.",
      "icon": Icons.credit_card_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.wp(.07)),
      child: Column(
        children: [
          SizedBox(height: context.hp(.015)),

          Row(
            children: [
              BackButtonWidget(
                visible: currentPage != 0,
                onPressed: _previousPage,
              ),

              const Spacer(),

              SkipButton(onPressed: _skip),
            ],
          ),

          const SizedBox(height: 8),

          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,

              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },

              itemBuilder: (context, index) {
                final page = pages[index];

                return OnBoardingPage(
                  title: page["title"],
                  description: page["description"],
                  icon: page["icon"],
                );
              },
            ),
          ),

          SizedBox(height: context.hp(.02)),

          PageIndicator(currentIndex: currentPage, length: pages.length),

          SizedBox(height: context.hp(.04)),

          NextButton(
            isLastPage: currentPage == pages.length - 1,
            onPressed: _nextPage,
          ),

          SizedBox(height: context.hp(.04)),
        ],
      ),
    );
  }
}
