import 'package:flutter/material.dart';
import 'package:nknu_connect/shared/widgets/page_wrapper.dart';
import 'package:nknu_connect/shared/widgets/spaced_column.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageWrapper(
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to NKNU!",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            TextField(
              decoration: InputDecoration(labelText: "需要什麼？", filled: true),
            ),
          ],
        ),
      ),
    );
  }
}
