import 'package:flutter/material.dart';
import 'package:flutter_adyen_terminal/data/enums.dart';

class PaymentOptionsCard extends StatelessWidget {
  final CaptureType captureType;
  final Set<ForceEntryModeType> forcedEntryModes;
  final Function(CaptureType) onCaptureTypeChanged;
  final Function(ForceEntryModeType) onForcedEntryModeToggled;
  final VoidCallback onClearForcedEntryModes;

  const PaymentOptionsCard({
    super.key,
    required this.captureType,
    required this.forcedEntryModes,
    required this.onCaptureTypeChanged,
    required this.onForcedEntryModeToggled,
    required this.onClearForcedEntryModes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Capture Type Section
            Row(
              children: [
                Icon(Icons.payment, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Capture Type',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<CaptureType>(
              segments: const [
                ButtonSegment(
                  value: CaptureType.delayed,
                  label: Text('Delayed'),
                  icon: Icon(Icons.schedule),
                ),
                ButtonSegment(
                  value: CaptureType.immediate,
                  label: Text('Immediate'),
                  icon: Icon(Icons.flash_on),
                ),
              ],
              selected: {captureType},
              onSelectionChanged: (Set<CaptureType> newSelection) {
                onCaptureTypeChanged(newSelection.first);
              },
            ),
            const SizedBox(height: 24),
            
            // Forced Entry Modes Section
            Row(
              children: [
                Icon(Icons.credit_card, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Forced Entry Modes',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (forcedEntryModes.isNotEmpty)
                  TextButton(
                    onPressed: onClearForcedEntryModes,
                    child: const Text('Clear All'),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Select specific card entry methods to force (optional)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ForceEntryModeType.values.map((mode) {
                final isSelected = forcedEntryModes.contains(mode);
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForMode(mode),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(mode.value),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => onForcedEntryModeToggled(mode),
                  backgroundColor: Colors.grey[100],
                  selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                  checkmarkColor: theme.colorScheme.primary,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getIconForMode(ForceEntryModeType mode) {
    switch (mode) {
      case ForceEntryModeType.keyed:
        return Icons.keyboard;
      case ForceEntryModeType.contactless:
        return Icons.contactless;
      case ForceEntryModeType.magStripe:
        return Icons.credit_card;
      case ForceEntryModeType.icc:
        return Icons.memory;
      default:
        return Icons.credit_card;
    }
  }
}
