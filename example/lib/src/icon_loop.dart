import 'package:flutter/material.dart';

import 'package:lordicon/lordicon.dart';

class IconLoop extends StatelessWidget {
  const IconLoop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = IconController.assets('assets/lock.json');

    controller.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        controller.playFromBeginning();
      } else if (status == ControllerStatus.completed) {
        controller.playFromBeginning();
      }
    });

    return Container(
      decoration: BoxDecoration(color: Colors.red),
      child: IconViewer(
        width: 196,
        height: 96,
        controller: controller,
      ),
    );
  }
}
