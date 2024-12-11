import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gyan_traffic_flutter_app/api_controller.dart';
import 'package:gyan_traffic_flutter_app/user.dart';

WebViewEnvironment? webViewEnvironment;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    assert(availableVersion != null,
        'Failed to find an installed WebView2 Runtime or non-stable Microsoft Edge installation.');

    webViewEnvironment = await WebViewEnvironment.create(
        settings:
            WebViewEnvironmentSettings(userDataFolder: 'YOUR_CUSTOM_PATH'));
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  User? user = await ApiController().auhenticate();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(
        user: user,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    final String token = user?.token ?? '';
    final String initialUrl =
        "https://traffic.gyancommunity.com/api/initiate?token=$token";

    print(initialUrl);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gyan Traffic Demo"),
      ),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
          onWebViewCreated: (controller) {
            // Additional controller setup can go here
          },
          onProgressChanged: (controller, progress) {
            // Handle progress if necessary
          },
        ),
      ),
    );
  }
}
