import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/terminal_provider.dart';
import '../models/transaction_log.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TransactionType? _filterType;
  TransactionStatus? _filterStatus;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        actions: [
          Consumer<TerminalProvider>(
            builder: (context, provider, _) {
              if (provider.transactionLogs.isEmpty) return const SizedBox.shrink();
              
              return IconButton(
                onPressed: () => _showClearConfirmation(context, provider),
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Clear History',
              );
            },
          ),
        ],
      ),
      body: Consumer<TerminalProvider>(
        builder: (context, provider, _) {
          final logs = _getFilteredLogs(provider.transactionLogs);
          
          if (provider.transactionLogs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transaction history',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transactions will appear here',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }
          
          return Column(
            children: [
              // Filters
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Type Filter
                            _FilterChipGroup<TransactionType>(
                              label: 'Type',
                              value: _filterType,
                              options: TransactionType.values,
                              optionLabels: {
                                TransactionType.payment: 'Payment',
                                TransactionType.tokenization: 'Tokenization',
                                TransactionType.cancellation: 'Cancellation',
                                TransactionType.utility: 'Utility',
                                TransactionType.system: 'System',
                              },
                              onChanged: (value) {
                                setState(() => _filterType = value);
                              },
                            ),
                            const SizedBox(width: 16),
                            // Status Filter
                            _FilterChipGroup<TransactionStatus>(
                              label: 'Status',
                              value: _filterStatus,
                              options: TransactionStatus.values,
                              optionLabels: {
                                TransactionStatus.success: 'Success',
                                TransactionStatus.failed: 'Failed',
                                TransactionStatus.pending: 'Pending',
                              },
                              onChanged: (value) {
                                setState(() => _filterStatus = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_filterType != null || _filterStatus != null) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filterType = null;
                            _filterStatus = null;
                          });
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Results count
              if (logs.length != provider.transactionLogs.length)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: theme.colorScheme.primary.withOpacity(0.05),
                  child: Row(
                    children: [
                      Text(
                        'Showing ${logs.length} of ${provider.transactionLogs.length} transactions',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              
              // Transaction List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return _TransactionCard(
                      log: log,
                      onTap: () => _showTransactionDetails(context, log),
                    ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  List<TransactionLog> _getFilteredLogs(List<TransactionLog> logs) {
    return logs.where((log) {
      if (_filterType != null && log.type != _filterType) return false;
      if (_filterStatus != null && log.status != _filterStatus) return false;
      return true;
    }).toList();
  }
  
  Future<void> _showClearConfirmation(BuildContext context, TerminalProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all transaction history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      provider.clearLogs();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('History cleared')),
        );
      }
    }
  }
  
  void _showTransactionDetails(BuildContext context, TransactionLog log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _TransactionDetailsSheet(log: log),
    );
  }
}

class _FilterChipGroup<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> options;
  final Map<T, String> optionLabels;
  final ValueChanged<T?> onChanged;

  const _FilterChipGroup({
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        ...options.map((option) {
          final isSelected = value == option;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                optionLabels[option] ?? option.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              onSelected: (selected) {
                onChanged(selected ? option : null);
              },
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          );
        }),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionLog log;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.log,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, HH:mm:ss');
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: log.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  log.typeIcon,
                  color: log.statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          log.typeLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: log.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            log.statusLabel,
                            style: TextStyle(
                              color: log.statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      log.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (log.amount != null) ...[
                          Text(
                            '${log.currency ?? 'USD'} ${log.amount!.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('•', style: TextStyle(color: Colors.grey[400])),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          dateFormat.format(log.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionDetailsSheet extends StatelessWidget {
  final TransactionLog log;

  const _TransactionDetailsSheet({required this.log});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMMM dd, yyyy • HH:mm:ss');
    
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            controller: scrollController,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: log.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      log.typeIcon,
                      color: log.statusColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.typeLabel,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: log.statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            log.statusLabel,
                            style: TextStyle(
                              color: log.statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Details
              _DetailSection(
                title: 'Transaction Details',
                items: [
                  _DetailItem('ID', log.id),
                  _DetailItem('Time', dateFormat.format(log.timestamp)),
                  if (log.amount != null)
                    _DetailItem('Amount', '${log.currency ?? 'USD'} ${log.amount!.toStringAsFixed(2)}'),
                  _DetailItem('Message', log.message),
                  if (log.errorCode != null)
                    _DetailItem('Error Code', log.errorCode!),
                ],
              ),
              
              if (log.response != null) ...[
                const SizedBox(height: 16),
                _DetailSection(
                  title: 'Response Data',
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'JSON Response',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: log.response!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copied to clipboard')),
                                );
                              },
                              tooltip: 'Copy',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            _formatJson(log.response!),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
  
  String _formatJson(String json) {
    try {
      final object = jsonDecode(json);
      return const JsonEncoder.withIndent('  ').convert(object);
    } catch (e) {
      return json;
    }
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<_DetailItem>? items;
  final Widget? child;

  const _DetailSection({
    required this.title,
    this.items,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (items != null)
          ...items!.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item.value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
        if (child != null) child!,
      ],
    );
  }
}

class _DetailItem {
  final String label;
  final String value;

  _DetailItem(this.label, this.value);
}
