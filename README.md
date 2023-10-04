# Lordicon Flutter

This library allows you to easily integrate the playback of [Lordicon](https://lordicon.com/) icons into a Flutter application.

## Usage

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

## More examples

For more code samples demonstrating various possibilities, please refer to the 'example' folder.

## Useful links

- [Lordicon](https://lordicon.com/) - Lordicon is a powerful library of
  thousands of carefully crafted animated icons.
- [Lottie](https://airbnb.io/lottie) - Render After Effects animations natively
  on Web, Android and iOS, and React Native.