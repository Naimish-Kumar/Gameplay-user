import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({Key? key, this.message = 'Something error'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}
