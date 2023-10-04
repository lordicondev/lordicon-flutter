# Example

## Simple usage

```dart
import 'package:flutter/material.dart';
import 'package:lordicon/lordicon.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = IconController.assets('assets/lock.json');

    controller.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        controller.playFromBeginning();
      }
    });

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: IconViewer(
            controller: controller,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
```
