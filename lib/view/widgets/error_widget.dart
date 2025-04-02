import 'package:flutter/material.dart';

/// A widget to display errors with a retry button
class ApiErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final bool isConnectionError;

  const ApiErrorWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
    this.isConnectionError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isConnectionError ? Icons.wifi_off : Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              isConnectionError ? 'Connection Error' : 'Error Occurred',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that handles API loading states, errors, and content display
class ApiStateHandler<T> extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final T? data;
  final VoidCallback onRetry;
  final Widget Function(T data) builder;
  final Widget? loadingWidget;

  const ApiStateHandler({
    Key? key,
    required this.isLoading,
    required this.errorMessage,
    required this.data,
    required this.onRetry,
    required this.builder,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Show loading indicator when loading
    if (isLoading) {
      return loadingWidget ??
          const Center(
            child: CircularProgressIndicator(),
          );
    }

    // Show error widget when there's an error
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      // Check if it's a connection error
      final isConnectionError = errorMessage!.contains('Internet') ||
          errorMessage!.contains('Connection');

      return ApiErrorWidget(
        errorMessage: errorMessage!,
        onRetry: onRetry,
        isConnectionError: isConnectionError,
      );
    }

    // Show content when data is available
    if (data != null) {
      return builder(data as T);
    }

    // Fallback for no data, no error, not loading
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outline,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
