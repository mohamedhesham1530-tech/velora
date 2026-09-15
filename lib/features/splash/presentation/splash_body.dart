import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final screenWidth = size.width;
    final screenHeight = size.height;

    return Stack(
        children: [
          //----------------------------------------------------
          // Background Gradient
          //----------------------------------------------------
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffFAFBFF),
                    Color(0xffF4F6FF),
                    Color(0xffEEF2FF),
                  ],
                ),
              ),
            ),
          ),

          //----------------------------------------------------
          // Top Right Blur
          //----------------------------------------------------
          Positioned(
            top: -140,
            right: -120,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.10),
              ),
            ),
          ),

          //----------------------------------------------------
          // Bottom Left Blur
          //----------------------------------------------------
          Positioned(
            bottom: -160,
            left: -140,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.08),
              ),
            ),
          ),

          //----------------------------------------------------
          // Floating Circle
          //----------------------------------------------------
          Positioned(
            top: screenHeight * .17,
            left: 35,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.20),
              ),
            ),
          ),

          Positioned(
            top: screenHeight * .28,
            right: 40,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.15),
              ),
            ),
          ),

          Positioned(
            bottom: screenHeight * .18,
            left: 55,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.18),
              ),
            ),
          ),

          //----------------------------------------------------
          // Main Content
          //----------------------------------------------------
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .08),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //------------------------------------------------
                      // Logo Animation
                      //------------------------------------------------
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutBack,
                        tween: Tween(begin: .75, end: 1),
                        builder: (_, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },

                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(.08),
                              ),
                            ),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(36),

                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 20,
                                  sigmaY: 20,
                                ),

                                child: Container(
                                  width: 118,
                                  height: 118,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(36),

                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xff7D75FF),
                                        Color(0xff5B52FF),
                                      ],
                                    ),

                                    border: Border.all(
                                      color: Colors.white70,
                                      width: 1.3,
                                    ),

                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          .35,
                                        ),
                                        blurRadius: 45,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 18),
                                      ),
                                    ],
                                  ),

                                  child: Center(
                                    child: Text(
                                      "V",
                                      style: AppTextStyles.displayLarge
                                          .copyWith(
                                            color: Colors.white,
                                            fontSize: 50,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 3,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Gap(45),
                      Text(
                            "Velora",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.displayLarge.copyWith(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: AppColors.black,
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 250.ms, duration: 700.ms)
                          .slideY(begin: .25, end: 0, curve: Curves.easeOut),

                      const Gap(18),

                      SizedBox(
                        width: screenWidth * .72,
                        child:
                            Text(
                                  "Shop Smarter.\nLive Better.",
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontSize: 18,
                                    height: 1.7,
                                    color: AppColors.grey700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                                .animate()
                                .fadeIn(delay: 550.ms, duration: 700.ms)
                                .slideY(begin: .30, end: 0),
                      ),

                      SizedBox(height: screenHeight * .10),

                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 2200),
                        curve: Curves.easeInOut,
                        tween: Tween(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              Container(
                                width: screenWidth * .60,
                                height: 7,

                                decoration: BoxDecoration(
                                  color: AppColors.grey300,
                                  borderRadius: BorderRadius.circular(100),
                                ),

                                child: Stack(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 350,
                                      ),

                                      width: (screenWidth * .60) * value,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),

                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff8C84FF),
                                            Color(0xff5B52FF),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Gap(24),

                              Text(
                                    "Loading...",
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 15,
                                      letterSpacing: 1,
                                      color: AppColors.grey700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                  .animate(
                                    onPlay: (controller) =>
                                        controller.repeat(reverse: true),
                                  )
                                  .fade(begin: .35, end: 1, duration: 900.ms),

                              const Gap(18),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white.withOpacity(.55),

                                  border: Border.all(color: Colors.white70),
                                ),

                                child: Text(
                                  "Version 1.0.0",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.grey500,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Gap(40),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Glow
          IgnorePointer(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: screenHeight * .22,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primary.withOpacity(.08),
                      AppColors.primary.withOpacity(.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Top Glow
          IgnorePointer(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: screenHeight * .16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white.withOpacity(.55), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
  }
}
