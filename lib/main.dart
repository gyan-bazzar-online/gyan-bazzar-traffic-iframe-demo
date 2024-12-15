import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gyan_traffic_flutter_app/user.dart';
import 'package:permission_handler/permission_handler.dart';

WebViewEnvironment? webViewEnvironment;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();
  await Permission.microphone.request();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    if (availableVersion == null) {
      throw Exception(
        'Failed to find an installed WebView2 Runtime or non-stable Microsoft Edge installation.',
      );
    }

    webViewEnvironment = await WebViewEnvironment.create(
      settings: WebViewEnvironmentSettings(userDataFolder: 'YOUR_CUSTOM_PATH'),
    );
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  try {
    User user = User.fromJson({
      "name": "John Doe",
      "mobile_number": "9876543222",
    });

    print(user.toJson());

    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(user: user),
      ),
    );
  } catch (e) {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ErrorScreen(error: e.toString()),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final String initialUrl =
        "https://traffic.gyancommunity.com/api/nagarik-class-initiate?mobile_number=${user.mobile_number}&name=${user.name}";

    print(initialUrl);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gyan Traffic Demo"),
      ),
      body: SafeArea(
        child: _buildWebView(initialUrl),
      ),
    );
  }

  Widget _buildWebView(String initialUrl) {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
        onWebViewCreated: (controller) {
          // Additional controller setup can go here
        },
        onProgressChanged: (controller, progress) {
          // Handle progress if necessary
        },
        onPermissionRequest: (InAppWebViewController controller,
            PermissionRequest permissionRequest) async {
          return PermissionResponse(
            resources: permissionRequest.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
      );
    } else {
      return Center(
        child: Text("WebView is not supported on this platform."),
      );
    }
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: Center(
        child: Text("Error: $error"),
      ),
    );
  }
}
