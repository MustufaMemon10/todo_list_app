import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TodoList App',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.sort))
        ],
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context,index)=> const SizedBox(
            height: 40,
          )),
      ),
    );
  }
}
