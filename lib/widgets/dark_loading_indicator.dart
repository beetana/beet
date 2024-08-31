import 'package:flutter/material.dart';

class DarkLoadingIndicator extends StatelessWidget {
  final bool isLoading;

  DarkLoadingIndicator({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : const SizedBox();
  }
}
