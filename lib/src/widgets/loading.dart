import 'package:flutter/material.dart';

class FincraLoader extends StatelessWidget {
  const FincraLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
