import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import 'providers/providers.dart';

/// The status of an animation controller.
enum ControllerStatus {
  /// The controller is ready.
  ready,

  /// The animation is stopped at the end.
  completed,
}

typedef ControllerStatusListener = void Function(ControllerStatus status);

class IconController extends ChangeNotifier {
  final ObserverList<ControllerStatusListener> _statusListeners =
      ObserverList<ControllerStatusListener>();

  TickerProvider? _tickerProvider;
  AnimationController? _controller;
  LottieComposition? _composition;
  String? _state;
  Marker? _marker;
  late int _direction;

  /// Creates a IconController instance that loads a Lottie composition from an asset.
  IconController.assets(String assetName, {String? state, int? direction}) {
    _controller = null;
    _composition = null;
    _marker = null;
    _state = state;
    _direction = direction ?? 1;

    AssetProvider(assetName).load().then((value) => {
          _composition = value,
          notifyListeners(),
        });
  }

  /// Creates a IconController instance that loads a Lottie composition from network.
  IconController.network(String url, {String? state, int? direction}) {
    _controller = null;
    _composition = null;
    _marker = null;
    _state = state;
    _direction = direction ?? 1;

    NetworkProvider(url)
        .load()
        .then((value) => {
              _composition = value,
              notifyListeners(),
            })
        .onError((error, stackTrace) => {});
  }

  void _initialize(TickerProvider tickerProvider) {
    _tickerProvider = tickerProvider;
    _assignState(_state);
    _notifyStatusListeners(ControllerStatus.ready);
  }

  void _assignState(String? state) {
    _state = state;
    _marker = null;

    var playing = isPlaying;

    for (var i = 0; i < _composition!.markers.length; i++) {
      var marker = _composition!.markers[i];
      var splitted = marker.name.split(":");
      var name = splitted.length == 2 ? splitted[1] : splitted[0];
      var isDefault = splitted.length == 2 && splitted[0] == "default";

      if (name == state) {
        _marker = marker;
      } else if (isDefault && state == null) {
        _marker = marker;
      }
    }

    _rebuild();

    if (playing) {
      play();
    }
  }

  void _notifyStatusListeners(ControllerStatus status) {
    final List<ControllerStatusListener> localListeners =
        _statusListeners.toList(growable: false);

    for (final ControllerStatusListener listener in localListeners) {
      listener(status);
    }
  }

  void _rebuild() {
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }

    if (_marker != null) {
      _controller = AnimationController(
        vsync: _tickerProvider!,
        lowerBound: _marker!.start,
        upperBound: _marker!.end,
      );

      _controller!.duration =
          _composition!.duration * (_marker!.end - _marker!.start);
    } else {
      _controller = AnimationController(vsync: _tickerProvider!);

      _controller!.duration = _composition!.duration;
    }

    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _notifyStatusListeners(ControllerStatus.completed);
      }
    });

    notifyListeners();
  }

  /// Starts playing the animation.
  void play() {
    if (_controller == null) {
      return;
    }

    if (direction > 0) {
      _controller!.forward();
    } else if (direction < 0) {
      _controller!.reverse();
    }
  }

  /// Pauses the animation.
  void pause() {
    if (_controller == null) {
      return;
    }

    _controller!.stop();
  }

  /// Starts playing the animation from the beginning.
  void playFromBeginning() {
    if (_controller == null) {
      return;
    }

    _controller!.forward(from: 0);
  }

  /// Goes to the first frame of the animation.
  void goToFirstFrame() {
    if (_controller == null) {
      return;
    }

    _controller!.value = 0;
  }

  /// Goes to the last frame of the animation.
  void goToLastFrame() {
    if (_controller == null) {
      return;
    }

    _controller!.value = 1;
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller!.dispose();
      _controller = null;
    }

    super.dispose();
  }

  /// Adds a listener to the controller's status changes.
  void addStatusListener(ControllerStatusListener listener) {
    _statusListeners.add(listener);
  }

  /// Removes a listener from the controller's status changes.
  void removeStatusListener(ControllerStatusListener listener) {
    _statusListeners.remove(listener);
  }

  /// Clears all listeners from the controller's status changes.
  void clearStatusListeners() {
    _statusListeners.clear();
  }

  /// Sets the state of the animation to the specified value.
  set state(String? state) {
    if (_state == state) {
      return;
    }

    _assignState(state);
  }

  /// Gets the current state of the animation.
  String? get state => _state;

  /// Sets the direction of the animation to the specified value.
  set direction(int direction) {
    if (_direction == direction) {
      return;
    }

    if (direction == 1 || direction == -1) {
      _direction = direction;
    }
  }

  /// Gets the current direction of the animation.
  int get direction => _direction;

  /// Gets whether the controller is ready to play the animation.
  get isReady => _tickerProvider != null;

  /// Gets whether the animation is currently playing.
  bool get isPlaying {
    if (_controller == null) {
      return false;
    }

    return _controller!.isAnimating;
  }
}

/// A widget to display a loaded Lordicon animation.
class IconViewer extends StatefulWidget {
  const IconViewer({
    super.key,
    required this.controller,
    this.width = 32,
    this.height = 32,
    this.colorize,
  });

  final IconController controller;
  final double width;
  final double height;
  final Color? colorize;

  @override
  State<IconViewer> createState() => IconViewerState();
}

class IconViewerState extends State<IconViewer> with TickerProviderStateMixin {
  late IconController _controller;
  late double _width;
  late double _height;
  late Color? _colorize;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _width = widget.width;
    _height = widget.height;
    _colorize = widget.colorize;
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var delegates = _colorize != null
        ? LottieDelegates(
            values: [
              ValueDelegate.color(
                const ['**'],
                value: _colorize,
              ),
              ValueDelegate.strokeColor(
                const ['**'],
                value: _colorize,
              ),
            ],
          )
        : null;

    return ListenableBuilder(
        listenable: _controller,
        builder: (BuildContext context, Widget? child) {
          if (_controller._composition == null) {
            return SizedBox(
              width: _width,
              height: _height,
            );
          }

          if (!_controller.isReady) {
            _controller._initialize(this);
          }

          return Lottie(
            composition: _controller._composition,
            controller: _controller._controller,
            width: _width,
            height: _height,
            delegates: delegates,
          );
        });
  }
}
