import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/terminal_provider.dart';

class UtilitiesScreen extends StatelessWidget {
  const UtilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terminal Utilities'),
      ),
      body: Consumer<TerminalProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Terminal Operations
                Text(
                  'Terminal Operations',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                _UtilityCard(
                  icon: Icons.info_outline,
                  title: 'Terminal Information',
                  description: 'Get detailed information about the connected terminal',
                  color: Colors.blue,
                  onTap: provider.initialized && !provider.isLoading
                      ? () => _getTerminalInfo(context, provider)
                      : null,
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: 12),
                
                _UtilityCard(
                  icon: Icons.qr_code_scanner,
                  title: 'Scan Barcode',
                  description: 'Use the terminal\'s built-in barcode scanner',
                  color: Colors.orange,
                  onTap: provider.initialized && !provider.isLoading
                      ? () => _scanBarcode(context, provider)
                      : null,
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: 12),
                
                _UtilityCard(
                  icon: Icons.draw,
                  title: 'Capture Signature',
                  description: 'Get customer signature from the terminal',
                  color: Colors.purple,
                  onTap: provider.initialized && !provider.isLoading
                      ? () => _getSignature(context, provider)
                      : null,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: 12),
                
                _UtilityCard(
                  icon: Icons.print,
                  title: 'Print Receipt',
                  description: 'Print a sample receipt on the terminal',
                  color: Colors.green,
                  onTap: provider.initialized && !provider.isLoading
                      ? () => _printReceipt(context, provider)
                      : null,
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: 24),
                
                // Status Section
                if (!provider.initialized) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Terminal Not Initialized',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Please configure and initialize the terminal first',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Error Display
                if (provider.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: theme.colorScheme.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            provider.errorMessage!,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().shake(),
                ],
                
                // Loading Indicator
                if (provider.isLoading) ...[
                  const SizedBox(height: 24),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
  
  Future<void> _getTerminalInfo(BuildContext context, TerminalProvider provider) async {
    await provider.getTerminalInfo();
    if (context.mounted && provider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terminal info retrieved - check history for details'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  Future<void> _scanBarcode(BuildContext context, TerminalProvider provider) async {
    await provider.scanBarcode();
    if (context.mounted && provider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barcode scan initiated on terminal'),
        ),
      );
    }
  }
  
  Future<void> _getSignature(BuildContext context, TerminalProvider provider) async {
    await provider.getSignature();
    if (context.mounted && provider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signature captured - check history for details'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  Future<void> _printReceipt(BuildContext context, TerminalProvider provider) async {
    final receiptJson = _generateSampleReceipt();
    await provider.printReceipt(receiptJson);
    if (context.mounted && provider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Receipt sent to printer'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  String _generateSampleReceipt() {
    return jsonEncode({
      "brandName": "Demo Store",
      "orderType": "In-Store",
      "orderSubtitle": "POS-Order",
      "totalItems": "3",
      "orderNo": "ORD-001",
      "tableNo": "N/A",
      "deviceType": "handheld",
      "receiptType": "pos",
      "timeOfOrder": "Placed at: ${DateTime.now().toString()}",
      "items": [
        {
          "itemName": "Product A",
          "description": "High quality product",
          "quantity": "2",
          "price": "\$25.00",
          "strikethrough": false
        },
        {
          "itemName": "Product B",
          "description": "Standard product",
          "quantity": "1",
          "price": "\$15.00",
          "strikethrough": false
        },
        {
          "itemName": "Discount",
          "description": "Promotional discount",
          "quantity": "1",
          "price": "-\$5.00",
          "strikethrough": false
        }
      ],
      "breakdown": [
        {"key": "Payment Type", "value": "Card"},
        {"key": "Card Type", "value": "Visa"},
        {"key": "Card #:", "value": "**** **** **** 1234"},
        {"key": "Card Entry", "value": "CHIP"},
        {"key": "Sub Total", "value": "\$60.00"},
        {"key": "Discount", "value": "-\$5.00"},
        {"key": "Tax (10%)", "value": "\$5.50"},
        {"key": "GRAND TOTAL", "value": "\$60.50", "important": true}
      ]
    });
  }
}

class _UtilityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback? onTap;

  const _UtilityCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: isEnabled ? 1.0 : 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isEnabled ? Colors.grey : Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
