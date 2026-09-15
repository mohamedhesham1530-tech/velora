import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/address_cubit.dart';
import '../cubit/address_state.dart';
import '../widgets/address_form.dart';
import '../widgets/address_empty_state.dart';
import '../../domain/entities/address_entity.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  Future<void> _openForm(
    BuildContext context, {
    AddressEntity? address,
  }) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(address == null ? 'Add Address' : 'Edit Address'),
            centerTitle: true,
          ),
          body: AddressForm(address: address),
        ),
      ),
    );

    if (changed == true && context.mounted) {
      await context.read<AddressCubit>().loadAddress();
      if (!context.mounted) return;
      _showFeedback(context, 'Address saved successfully.');
    }
  }

  Future<void> _deleteAddress(
    BuildContext context,
    AddressEntity address,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete address?'),
        content: const Text(
          'This address will be removed from your saved delivery addresses.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) return;

    try {
      await context.read<AddressCubit>().deleteAddressById(address.id);
      if (!context.mounted) return;
      _showFeedback(context, 'Address deleted successfully.');
    } catch (_) {
      if (!context.mounted) return;
      _showFeedback(context, 'We could not delete this address. Please try again.', isError: true);
    }
  }

  Future<void> _selectAddress(
    BuildContext context,
    String id,
  ) async {
    try {
      await context.read<AddressCubit>().selectAddress(id);
    } catch (_) {
      if (!context.mounted) return;
      _showFeedback(context, 'We could not select this address. Please try again.', isError: true);
    }
  }

  Future<void> _makeDefault(
    BuildContext context,
    AddressEntity address,
  ) async {
    if (address.isDefault) return;

    try {
      await context.read<AddressCubit>().saveAddress(
        AddressEntity(
          id: address.id,
          fullName: address.fullName,
          phone: address.phone,
          alternatePhone: address.alternatePhone,
          country: address.country,
          governorate: address.governorate,
          city: address.city,
          area: address.area,
          street: address.street,
          building: address.building,
          floor: address.floor,
          apartment: address.apartment,
          landmark: address.landmark,
          notes: address.notes,
          latitude: address.latitude,
          longitude: address.longitude,
          isDefault: true,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      _showFeedback(context, 'We could not update the default address. Please try again.', isError: true);
    }
  }

  void _showFeedback(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final colorScheme = Theme.of(context).colorScheme;
    final color = isError ? colorScheme.error : colorScheme.primary;

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        backgroundColor: color,
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: colorScheme.onPrimary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Addresses'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Add address',
            onPressed: () => _openForm(context),
            icon: const Icon(Icons.add_location_alt_outlined),
          ),
        ],
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state.isLoading && state.addresses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.addresses.isEmpty) {
            return AddressEmptyState(
              onAdd: () => _openForm(context),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<AddressCubit>().loadAddress(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: state.addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                final isSelected = state.address?.id == address.id;

                return Card(
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _selectAddress(context, address.id),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Radio<String>(
                                value: address.id,
                                groupValue: state.address?.id,
                                onChanged: (value) {
                                  if (value != null) {
                                    _selectAddress(context, value);
                                  }
                                },
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            address.fullName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        if (address.isDefault)
                                          Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'Default',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(address.phone),
                                    const SizedBox(height: 5),
                                    Text(
                                      _formatAddress(address),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            height: 1.4,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: isSelected
                                    ? null
                                    : () => _makeDefault(context, address),
                                icon: Icon(
                                  address.isDefault
                                      ? Icons.star
                                      : Icons.star_border,
                                ),
                                label: Text(
                                  address.isDefault
                                      ? 'Default'
                                      : 'Make default',
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                tooltip: 'Edit address',
                                onPressed: () =>
                                    _openForm(context, address: address),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                tooltip: 'Delete address',
                                onPressed: () =>
                                    _deleteAddress(context, address),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _formatAddress(AddressEntity address) {
    final parts = <String>[
      address.street,
      address.area,
      address.city,
      address.governorate,
      address.country,
    ].where((value) => value.trim().isNotEmpty).toList();

    return parts.join(', ');
  }
}
