import 'package:flutter/material.dart';

import 'package:lordicon/lordicon.dart';

class IconTrash extends StatelessWidget {
  const IconTrash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller =
        IconController.assets('assets/trash.json', state: 'in-trash-empty');

    controller.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        controller.playFromBeginning();
      }
    });

    void onClick() {
      var state = controller.state;

      if (state == 'in-trash-empty') {
        controller.state = 'hover-trash-empty';
      } else if (state == 'hover-trash-empty') {
        controller.state = 'morph-trash-full';
      } else if (state == 'morph-trash-full') {
        controller.state = 'hover-trash-full-solid';
      } else if (state == 'hover-trash-full-solid') {
        controller.state = 'morph-trash-full-to-empty';
      } else if (state == 'morph-trash-full-to-empty') {
        controller.state = 'hover-trash-empty';
      }

      controller.playFromBeginning();
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
