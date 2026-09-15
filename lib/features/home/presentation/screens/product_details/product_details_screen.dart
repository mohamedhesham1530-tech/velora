import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/theme_extensions.dart';
import '../../../domain/entities/product_entity.dart';
import 'product_details_body.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: context.background,
      body: ProductDetailsBody(product: product),
    );
  }
}
