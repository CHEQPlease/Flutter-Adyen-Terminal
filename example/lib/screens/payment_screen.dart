import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_adyen_terminal/data/enums.dart';
import '../providers/terminal_provider.dart';
import '../widgets/amount_input_card.dart';
import '../widgets/payment_options_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Payment controllers
  final _amountController = TextEditingController(text: '9.99');
  final _currencyController = TextEditingController(text: 'USD');
  final _additionalDataController = TextEditingController(text: '{"shopperStatement": "Demo Payment"}');
  
  // Tokenization controllers
  final _tokenAmountController = TextEditingController(text: '0.00');
  final _tokenCurrencyController = TextEditingController(text: 'USD');
  final _shopperReferenceController = TextEditingController();
  final _shopperEmailController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  final _tokenFormKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _currencyController.dispose();
    _additionalDataController.dispose();
    _tokenAmountController.dispose();
    _tokenCurrencyController.dispose();
    _shopperReferenceController.dispose();
    _shopperEmailController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Terminal'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Payment', icon: Icon(Icons.payment)),
            Tab(text: 'Tokenization', icon: Icon(Icons.credit_card)),
          ],
        ),
      ),
      body: Consumer<TerminalProvider>(
        builder: (context, provider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildPaymentTab(context, provider),
              _buildTokenizationTab(context, provider),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildPaymentTab(BuildContext context, TerminalProvider provider) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Input
            AmountInputCard(
              amountController: _amountController,
              currencyController: _currencyController,
            ).animate().fadeIn().slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 16),
            
            // Payment Options
            PaymentOptionsCard(
              captureType: provider.captureType,
              forcedEntryModes: provider.forcedEntryModes,
              onCaptureTypeChanged: provider.setCaptureType,
              onForcedEntryModeToggled: provider.toggleForcedEntryMode,
              onClearForcedEntryModes: provider.clearForcedEntryModes,
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 16),
            
            // Additional Data
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.data_object, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Additional Data (Optional)',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _additionalDataController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Enter JSON data...',
                        helperText: 'Must be valid JSON format',
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          try {
                            jsonDecode(value);
                          } catch (e) {
                            return 'Invalid JSON format';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: provider.isLoading || !provider.initialized
                        ? null
                        : () => _processPayment(context, provider),
                    icon: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.payment),
                    label: Text(provider.isLoading ? 'Processing...' : 'Process Payment'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: provider.lastTransactionId == null || provider.isLoading
                      ? null
                      : () => _cancelTransaction(context, provider),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Last'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
            
            // Current Transaction Status
            if (provider.currentTransaction != null) ...[
              const SizedBox(height: 16),
              _buildTransactionStatus(provider.currentTransaction!),
            ],
            
            // Error Message
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildTokenizationTab(BuildContext context, TerminalProvider provider) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _tokenFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Input
            AmountInputCard(
              amountController: _tokenAmountController,
              currencyController: _tokenCurrencyController,
              title: 'Verification Amount',
              subtitle: 'Small amount for card verification (usually 0.00)',
            ).animate().fadeIn().slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 16),
            
            // Shopper Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Shopper Information',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _shopperReferenceController,
                      decoration: const InputDecoration(
                        labelText: 'Shopper Reference',
                        hintText: 'e.g., customer_12345',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Shopper reference is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _shopperEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Shopper Email (Optional)',
                        hintText: 'customer@example.com',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 16),
            
            // Entry Modes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.credit_card, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Entry Modes',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ForceEntryModeType.values.map((mode) {
                        final isSelected = provider.forcedEntryModes.contains(mode);
                        return FilterChip(
                          label: Text(mode.value),
                          selected: isSelected,
                          onSelected: (_) => provider.toggleForcedEntryMode(mode),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            
            const SizedBox(height: 24),
            
            // Tokenize Button
            FilledButton.icon(
              onPressed: provider.isLoading || !provider.initialized
                  ? null
                  : () => _tokenizeCard(context, provider),
              icon: provider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.credit_card),
              label: Text(provider.isLoading ? 'Processing...' : 'Tokenize Card'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
            
            // Error Message
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransactionStatus(dynamic transaction) {
    final theme = Theme.of(context);
    
    return Card(
      color: theme.colorScheme.primary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(
              transaction.message ?? 'Processing...',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn()
      .shimmer(duration: 2.seconds, delay: 1.seconds);
  }
  
  Future<void> _processPayment(BuildContext context, TerminalProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final currency = _currencyController.text.trim();
    
    Map<String, dynamic>? additionalData;
    if (_additionalDataController.text.isNotEmpty) {
      try {
        additionalData = jsonDecode(_additionalDataController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid JSON in additional data')),
        );
        return;
      }
    }
    
    await provider.authorizeTransaction(
      amount: amount,
      currency: currency,
      additionalData: additionalData,
    );
    
    if (provider.errorMessage == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment processed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  Future<void> _tokenizeCard(BuildContext context, TerminalProvider provider) async {
    if (!_tokenFormKey.currentState!.validate()) return;
    
    final amount = double.tryParse(_tokenAmountController.text) ?? 0.0;
    final currency = _tokenCurrencyController.text.trim();
    final shopperReference = _shopperReferenceController.text.trim();
    final shopperEmail = _shopperEmailController.text.trim();
    
    await provider.tokenizeCard(
      amount: amount,
      currency: currency,
      shopperReference: shopperReference,
      shopperEmail: shopperEmail.isEmpty ? null : shopperEmail,
    );
    
    if (provider.errorMessage == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Card tokenized successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  
  Future<void> _cancelTransaction(BuildContext context, TerminalProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Transaction'),
        content: const Text('Are you sure you want to cancel the last transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await provider.cancelTransaction(provider.lastTransactionId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cancel request sent')),
        );
      }
    }
  }
}
