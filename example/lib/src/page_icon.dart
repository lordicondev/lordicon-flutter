import 'package:flutter/material.dart';

import 'package:lordicon/lordicon.dart';

class PageIcon extends StatefulWidget {
  const PageIcon({super.key});

  @override
  State<PageIcon> createState() => _PageIconState();
}

class _PageIconState extends State<PageIcon> {
  late IconController _controller;

  @override
  void initState() {
    super.initState();

    _controller = IconController.assets('assets/lock.json');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconViewer(
                  width: 96,
                  height: 96,
                  controller: _controller,
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.pause();
                },
                child: const Text('pause'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _controller.play();
                },
                child: const Text('play'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _controller.playFromBeginning();
                },
                child: const Text('playFromBeginning'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.direction = _controller.direction > 0 ? -1 : 1;
                },
                child: const Text('direction'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _controller.goToFirstFrame();
                },
                child: const Text('first frame'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _controller.goToLastFrame();
                },
                child: const Text('last frame'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.state = 'in-reveal';
                },
                child: const Text('state: in-reveal'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _controller.state = 'morph-unlocked';
                },
                child: const Text('state: morph-unlocked'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
