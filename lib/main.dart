import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';


// main is asynchronous - when run we make sure it is initialzied then 
// await before we can run the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await pauses just this function while these are running, so that the
  // app cannot be run without these two tasks, as that would cause an error
  await Hive.initFlutter();
  await Hive.openBox("tasks");

  runApp(const VisualSchedulerApp());
}

class VisualSchedulerApp extends StatelessWidget {
  const VisualSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visual Scheduler',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: IncrementButton()
    );
  }
  
}

class IncrementButton extends StatelessWidget {
  const IncrementButton({super.key});
  @override
  Widget build(BuildContext context) {
    Box tasksBox = Hive.box("tasks");
    return Scaffold(
      body: Column (children: [
      TextButton(onPressed: () => tasksBox.add("test at ${DateTime.now()}"), child: Text("Press here!")),
      Expanded(child: 
      ValueListenableBuilder(
          valueListenable: tasksBox.listenable(), 
          builder: (context, Box box, widget) {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var stamp = box.getAt(index);
                return ListTile(title: Text(stamp.toString()));
              }
            );
          }
        ))
      
      ])
    );
  }
}