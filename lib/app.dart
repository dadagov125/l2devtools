import 'package:flutter/material.dart';
import 'package:l2_devtools/screens/home_screen.dart';

import 'widgets/import_skills.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue ,
      ),
      home:  ImportSkills(),
    );
  }
}
