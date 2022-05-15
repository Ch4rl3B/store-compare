import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          LinearProgressIndicator(
            color: Theme.of(context).toggleableActiveColor,
          ),
          Expanded(
              child: Center(
                child: Text(
                  'Getting items...',
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).toggleableActiveColor),
                ),
              ))
        ],
      ),
    );
  }
}
