import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads Roboto and the Material icons from the Flutter SDK so goldens show
/// real glyphs instead of the test font's boxes.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // FLUTTER_ROOT is not always passed down; flutter_tester itself lives in
  // <root>/bin/cache/artifacts/engine/<platform>/.
  final exe = Platform.resolvedExecutable;
  final cache = exe.contains('/bin/cache/') ? exe.substring(0, exe.indexOf('/bin/cache/') + '/bin/cache'.length) : null;
  final root = Platform.environment['FLUTTER_ROOT'];
  final dir = root != null ? '$root/bin/cache/artifacts/material_fonts' : '$cache/artifacts/material_fonts';
  if (Directory(dir).existsSync()) {
    Future<void> load(String family, List<String> files) async {
      final loader = FontLoader(family);
      var any = false;
      for (final f in files) {
        final file = File('$dir/$f');
        if (file.existsSync()) {
          loader.addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
          any = true;
        }
      }
      if (any) {
        await loader.load();
      }
    }

    await load('Roboto', ['Roboto-Regular.ttf', 'Roboto-Medium.ttf', 'Roboto-Bold.ttf', 'Roboto-Black.ttf']);
    await load('MaterialIcons', ['MaterialIcons-Regular.otf']);
  }
  await testMain();
}
