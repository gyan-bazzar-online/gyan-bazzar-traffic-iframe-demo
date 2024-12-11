import 'dart:io';
import 'package:gyan_traffic_flutter_app/api_provider.dart';
import 'package:gyan_traffic_flutter_app/user.dart';
import 'package:get/get.dart';

class ApiController {
  Future<User?> authenticate() async {
    try {
      Response userResponse = await ApiProvider().authenticate();

      if (userResponse.hasError) {
        print({
          "error_type": userResponse.status.isServerError
              ? "Server Error"
              : "Client Error",
          "status_code": userResponse.statusCode,
          "status_text": userResponse.statusText,
          "response_body": userResponse.body,
        });
        return null;
      }

      Map<String, dynamic> userData = userResponse.body;

      print({
        "data": userData['data'],
      });

      return User.fromJson(userData['data']);
    } on SocketException catch (e) {
      print({
        "error_type": "Network Error",
        "exception": e.toString(),
        "suggestion": "Please check your internet connection or DNS settings.",
      });
      return null;
    } catch (e) {
      print({
        "error_type": "Unexpected Error",
        "exception": e.toString(),
      });
      return null;
    }
  }
}
