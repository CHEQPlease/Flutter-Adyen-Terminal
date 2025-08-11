import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/terminal_provider.dart';
import '../models/app_config.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        actions: [
          Consumer<TerminalProvider>(
            builder: (context, provider, _) {
              return IconButton(
                onPressed: provider.isLoading ? null : provider.loadAndInitConfig,
                icon: provider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                tooltip: 'Reload Configuration',
              );
            },
          ),
        ],
      ),
      body: Consumer<TerminalProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Environment Selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Environment',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SegmentedButton<AppEnvironment>(
                          segments: AppEnvironment.values.map((env) {
                            return ButtonSegment(
                              value: env,
                              label: Text(env.displayName),
                              icon: Icon(
                                env == AppEnvironment.production
                                    ? Icons.business
                                    : Icons.bug_report,
                              ),
                            );
                          }).toList(),
                          selected: {provider.environment},
                          onSelectionChanged: (Set<AppEnvironment> newSelection) {
                            provider.setEnvironment(newSelection.first);
                          },
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: provider.environment == AppEnvironment.production
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: provider.environment == AppEnvironment.production
                                    ? Colors.orange
                                    : Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  provider.environment == AppEnvironment.production
                                      ? 'Production environment - Real transactions will be processed'
                                      : 'Test environment - Safe for testing',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: provider.environment == AppEnvironment.production
                                        ? Colors.orange[700]
                                        : Colors.blue[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: 16),
                
                // Terminal Configuration Details
                if (provider.config != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.terminal, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Terminal Details',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Terminal ID', provider.config!.terminalId),
                          _buildDetailRow('Model', provider.config!.terminalModelNo),
                          _buildDetailRow('Serial Number', provider.config!.terminalSerialNo),
                          _buildDetailRow('Communication Mode', provider.config!.communicationMode.name),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.store, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Merchant Information',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Merchant Name', provider.config!.merchantName),
                          _buildDetailRow('Merchant ID', provider.config!.merchantId),
                          _buildDetailRow('Key ID', provider.config!.keyId),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  
                  const SizedBox(height: 16),
                  
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.link, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Connection',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Endpoint', provider.config!.endpoint, isUrl: true),
                          _buildDetailRow('Environment', provider.config!.environment),
                          _buildDetailRow('Backend API Key', _maskApiKey(provider.config!.backendApiKey ?? '')),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.cloud_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No configuration loaded',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Select an environment and reload',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: provider.isLoading ? null : provider.loadAndInitConfig,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Load Configuration'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.1, end: 0),
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
          );
        },
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isUrl = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: isUrl ? 'monospace' : null,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: isUrl ? 2 : 1,
            ),
          ),
        ],
      ),
    );
  }
  
  String _maskApiKey(String apiKey) {
    if (apiKey.isEmpty) return '-';
    if (apiKey.length <= 8) return '****';
    return '${apiKey.substring(0, 4)}...${apiKey.substring(apiKey.length - 4)}';
  }
}
