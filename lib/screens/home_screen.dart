import 'package:flutter/material.dart';
import 'package:l2_devtools/widgets/import_skills.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ImportSkills()));
                },
                child: Text('Import skills')),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child:
                ElevatedButton(onPressed: () {}, child: Text('Export skills')),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child:
                ElevatedButton(onPressed: () {}, child: Text('Import icons')),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
