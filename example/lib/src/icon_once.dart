import 'package:flutter/material.dart';

import 'package:lordicon/lordicon.dart';

class IconOnce extends StatelessWidget {
  const IconOnce({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = IconController.assets('assets/camera.json');

    controller.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        controller.playFromBeginning();
      }
    });

    return IconViewer(
      width: 96,
      height: 96,
      controller: controller,
      colorize: const Color(0x0008c18a),
    );
  }
}
