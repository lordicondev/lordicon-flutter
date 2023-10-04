import 'package:flutter/material.dart';

import 'package:lordicon/lordicon.dart';

class IconClick extends StatelessWidget {
  const IconClick({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller =
        IconController.assets('assets/lock-alt.json', state: 'morph-unlocked');

    void onClick() {
      controller.play();

      controller.direction = controller.direction * -1;
    }

    return Listener(
      onPointerUp: (event) => onClick(),
      child: IconViewer(
        width: 96,
        height: 96,
        controller: controller,
      ),
    );
  }
}
