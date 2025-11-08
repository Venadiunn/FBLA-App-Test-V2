import 'package:flutter/material.dart';

class SimpleErrorWidget extends StatelessWidget {
  final Object error;
  const SimpleErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) => Center(child: Text('Error: $error'));
}
