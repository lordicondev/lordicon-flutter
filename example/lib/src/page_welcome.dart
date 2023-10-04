import 'package:flutter/material.dart';

import 'icon_click.dart';
import 'icon_loop.dart';
import 'icon_once.dart';
import 'icon_trash.dart';

class PageWelcome extends StatelessWidget {
  const PageWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconOnce(),
              SizedBox(width: 20),
              IconLoop(),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconClick(),
              SizedBox(width: 20),
              IconTrash(),
            ],
          ),
        ],
      ),
    );
  }
}
