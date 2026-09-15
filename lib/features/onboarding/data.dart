import 'package:flutter/material.dart';

class OnBoardingModel {
  final String title;
  final String description;
  final IconData icon;

  const OnBoardingModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}

const List<OnBoardingModel> onboardingPages = [
  OnBoardingModel(
    title: "Discover",
    description:
        "Explore thousands of premium products from your favorite brands.",
    icon: Icons.shopping_bag_rounded,
  ),

  OnBoardingModel(
    title: "Fast Delivery",
    description:
        "Track your order in real time and receive it as quickly as possible.",
    icon: Icons.local_shipping_rounded,
  ),

  OnBoardingModel(
    title: "Secure Payment",
    description:
        "Enjoy a safe shopping experience with secure payment methods.",
    icon: Icons.credit_card_rounded,
  ),
];