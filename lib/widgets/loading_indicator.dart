import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isLoading;

  LoadingIndicator({@required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.transparent,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : const SizedBox();
  }
}
