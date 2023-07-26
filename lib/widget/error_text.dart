import 'package:flutter/material.dart';

class ErrorTextWidget extends StatelessWidget {
  final String? error;
  const ErrorTextWidget({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(error ?? ''));
  }
}
