import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import 'offer_card.dart';

class OffersCarousel extends StatefulWidget {
  const OffersCarousel({super.key});

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  late final PageController _pageController;

  int currentPage = 0;

  final List<Map<String, dynamic>> offers = [
    {
      "title": "Summer Collection",
      "subtitle": "Up to 50% off on selected products",
      "discount": "-50%",
      "color": const Color(0xff5B52FF),
      "icon": Icons.shopping_bag_rounded,
    },
    {
      "title": "Electronics",
      "subtitle": "Latest gadgets with amazing prices",
      "discount": "-30%",
      "color": const Color(0xff0EA5E9),
      "icon": Icons.headphones_rounded,
    },
    {
      "title": "Fashion Week",
      "subtitle": "Trending outfits just for you",
      "discount": "-40%",
      "color": const Color(0xffF97316),
      "icon": Icons.checkroom_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: .92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.responsive(mobile: 190, tablet: 215, desktop: 235),

          child: PageView.builder(
            controller: _pageController,

            itemCount: offers.length,

            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },

            itemBuilder: (context, index) {
              final offer = offers[index];

              return Padding(
                padding: const EdgeInsets.only(right: 12),

                child: OfferCard(
                  title: offer["title"],

                  subtitle: offer["subtitle"],

                  discount: offer["discount"],

                  backgroundColor: offer["color"],

                  icon: offer["icon"],

                ),
              );
            },
          ),
        ),

        SizedBox(height: context.hp(.02)),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: List.generate(offers.length, (index) {
            final isActive = index == currentPage;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),

              margin: const EdgeInsets.symmetric(horizontal: 4),

              width: isActive ? 24 : 8,

              height: 8,

              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.grey300,

                borderRadius: BorderRadius.circular(100),
              ),
            );
          }),
        ),
      ],
    );
  }
}
