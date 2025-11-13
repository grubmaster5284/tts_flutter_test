import 'package:flutter/material.dart';

/// Widget for displaying loading indicator
class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Synthesizing speech...'),
        ],
      ),
    );
  }
}

