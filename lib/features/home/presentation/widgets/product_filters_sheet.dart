import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class ProductFiltersSheet extends StatelessWidget {
  const ProductFiltersSheet({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.grey300,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Text(
                        'Filter Products',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed:
                            context.read<HomeCubit>().clearProductControls,
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),

                  _title('Categories'),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'All',
                      ...state.categories.map((category) => category.name),
                    ]
                        .map(
                          (category) => ChoiceChip(
                            label: Text(
                              category == 'All'
                                  ? 'All'
                                  : _label(category),
                            ),
                            selected: category == 'All'
                                ? state.selectedCategory == null
                                : state.selectedCategory?.toLowerCase() ==
                                    category.toLowerCase(),
                            selectedColor:
                                AppColors.primary.withValues(alpha: .16),
                            onSelected: (_) => context
                                .read<HomeCubit>()
                                .selectCategory(category),
                          ),
                        )
                        .toList(),
                  ),

                  _title('Sort by Price'),

                  _choices<ProductSort>(
                    context,
                    state.sort,
                    {
                      'Default': ProductSort.none,
                      'Low to High': ProductSort.priceLowToHigh,
                      'High to Low': ProductSort.priceHighToLow,
                    },
                    (value) => context
                        .read<HomeCubit>()
                        .updateFilters(sort: value),
                  ),

                  _title('Minimum Rating'),

                  _choices<double?>(
                    context,
                    state.minimumRating,
                    {
                      'Any Rating': null,
                      '4 Stars & Up': 4,
                      '3 Stars & Up': 3,
                    },
                    (value) => context.read<HomeCubit>().updateFilters(
                          minimumRating: value,
                          clearMinimumRating: value == null,
                        ),
                  ),

                  _title('Discount'),

                  _choices<double?>(
                    context,
                    state.minimumDiscount,
                    {
                      'Any Discount': null,
                      '10% & Up': 10,
                      '20% & Up': 20,
                    },
                    (value) => context.read<HomeCubit>().updateFilters(
                          minimumDiscount: value,
                          clearMinimumDiscount: value == null,
                        ),
                  ),

                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'In Stock Only',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    value: state.inStockOnly,
                    activeColor: AppColors.primary,
                    onChanged: (value) => context
                        .read<HomeCubit>()
                        .updateFilters(inStockOnly: value),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Show Products'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _title(String value) => Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 6),
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      );

  static String _label(String category) => category
      .split(RegExp(r'[- ]'))
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');

  Widget _choices<T>(
    BuildContext context,
    T selected,
    Map<String, T> options,
    ValueChanged<T> onChanged,
  ) =>
      Column(
        children: options.entries
            .map(
              (entry) => RadioListTile<T>(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: entry.value,
                groupValue: selected,
                activeColor: AppColors.primary,
                title: Text(entry.key),
                onChanged: (value) {
                  if (value != null || entry.value == null) {
                    onChanged(entry.value);
                  }
                },
              ),
            )
            .toList(),
      );
}