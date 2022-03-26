import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColorDark,
      child: const Center(
        child: Text('Home Screen', style: TextStyle(fontSize: 24),),
      ),
    );
  }
}
