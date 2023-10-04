import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as p;

import 'provider_io.dart' if (dart.library.html) 'provider_web.dart' as network;

final sharedLottieCache = LottieCache();

String handleJsonData(String text) {
  final jsonResult = jsonDecode(text);

  var markers = jsonResult['markers'] as List<dynamic>;
  if (markers.isNotEmpty) {
    var s = markers.length;
    var f = markers[0] as Map<String, dynamic>;
    var l = markers[s - 1] as Map<String, dynamic>;

    jsonResult['ip'] = f['tm'];
    jsonResult['op'] = l['tm'] + l['dr'] + 1;
  }

  return jsonEncode(jsonResult);
}

@immutable
class AssetProvider extends LottieProvider {
  AssetProvider(
    this.assetName, {
    this.bundle,
    this.package,
    super.imageProviderFactory,
  });

  final String assetName;
  String get keyName =>
      package == null ? assetName : 'packages/$package/$assetName';

  final AssetBundle? bundle;

  final String? package;

  @override
  Future<LottieComposition> load() {
    return sharedLottieCache.putIfAbsent(this, () async {
      final chosenBundle = bundle ?? rootBundle;

      var data = handleJsonData(await chosenBundle.loadString(keyName));
      final iconData = Uint8List.fromList(utf8.encode(data));

      var composition = await LottieComposition.fromBytes(iconData,
          name: p.url.basenameWithoutExtension(keyName),
          imageProviderFactory: imageProviderFactory);

      return composition;
    });
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AssetProvider &&
        other.keyName == keyName &&
        other.bundle == bundle;
  }

  @override
  int get hashCode => Object.hash(keyName, bundle);

  @override
  String toString() => '$runtimeType(bundle: $bundle, name: "$keyName")';
}

@immutable
class NetworkProvider extends LottieProvider {
  NetworkProvider(this.url, {this.headers, super.imageProviderFactory});

  final String url;
  final Map<String, String>? headers;

  @override
  Future<LottieComposition> load() {
    return sharedLottieCache.putIfAbsent(this, () async {
      var resolved = Uri.base.resolve(url);
      var bytes = await network.loadHttp(resolved, headers: headers);
      var data = handleJsonData(utf8.decode(bytes));

      final iconData = Uint8List.fromList(utf8.encode(data));

      var composition = await LottieComposition.fromBytes(iconData,
          name: p.url.basenameWithoutExtension(url),
          imageProviderFactory: imageProviderFactory);

      return composition;
    });
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    return other is NetworkProvider && other.url == url;
  }

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => '$runtimeType(url: $url)';
}
