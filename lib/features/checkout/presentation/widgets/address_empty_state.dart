import 'package:flutter/material.dart';

class AddressEmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const AddressEmptyState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_off_rounded,
              size: 84,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'No addresses yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add an address to continue. You can save multiple addresses and select one when checking out.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(.7),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text('Add Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
