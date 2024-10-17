import 'package:flutter/material.dart';

import 'controllers/platform_controller.dart';
import 'native_view.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _timerValue = 0;
  bool _isTimerRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Timer:'),
            Text(
              '$_timerValue',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            (!_isTimerRunning)
                ? ElevatedButton(
                    onPressed: _startTimer,
                    child: const Text('Start Timer'),
                  )
                : ElevatedButton(
                    onPressed: _stopTimer,
                    child: const Text('Stop Timer'),
                  ),
            const SizedBox(height: 200),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return NativeView();
                    },
                  ),
                );
              },
              child: const Text('Open Native View'),
            ),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
    });

    PlatformController.startTimer(
      onEvent: (int value) {
        setState(() {
          _timerValue = value;
        });
      },
    );
  }

  void _stopTimer() {
    setState(() {
      _isTimerRunning = false;
    });

    PlatformController.stopTimer();
  }
}
