// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Task'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _taskController = TextEditingController();
  final FocusNode _taskFocusNode = FocusNode();

  List<String> _tasks = [];
  int _index = -1;
  bool _isDeleting = false;

  void _addTaskToList({int index = -1}) {
    setState(() {
      if (_taskController.text.isNotEmpty && index == -1)
        _tasks.add(_taskController.text);
      else if (_taskController.text.isNotEmpty && index != -1)
        _tasks[index] = _taskController.text;
      _taskController.clear();
      _taskFocusNode.requestFocus();
      _index = -1;
    });
  }

  void _removeTaskFromList({int index = 0, bool all = false}) {
    setState(() {
      if (all) {
        _tasks.clear();
      } else {
        _tasks.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isDeleting = !_isDeleting;
                });
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _taskFocusNode,
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Write something here...',
                    ),
                    onSubmitted: (value) {
                      _addTaskToList(index: _index);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addTaskToList(index: _index);
                  },
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]),
                    trailing: _isDeleting
                        ? IconButton(
                            onPressed: () {
                              _removeTaskFromList(index: index);
                            },
                            icon: Icon(Icons.delete),
                          )
                        : null,
                    onLongPress: () {
                      _taskController.value = TextEditingValue(
                        text: _tasks[index],
                        selection: TextSelection.collapsed(
                          offset: _tasks[index].length,
                        ),
                      );
                      _index = index;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
