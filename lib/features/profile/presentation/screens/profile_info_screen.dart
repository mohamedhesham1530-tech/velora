import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileInfoScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const ProfileInfoScreen({super.key, required this.title, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(title: Text(title), centerTitle: true, backgroundColor: Colors.transparent),
    body: Center(child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(radius: 42, backgroundColor: AppColors.primary.withOpacity(.12), child: Icon(icon, size: 42, color: AppColors.primary)),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.grey700, height: 1.5)),
      ]),
    )),
  );
}
