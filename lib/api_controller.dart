import 'package:gyan_traffic_flutter_app/api_provider.dart';
import 'package:gyan_traffic_flutter_app/user.dart';
import 'package:get/get.dart';

class ApiController {
  Future<User?> auhenticate() async {
    Response userResponse = await ApiProvider().auhenticate();

    if (userResponse.hasError) {
      print({
        "error": userResponse.bodyString ?? 'ASD',
      });
      return null;
    }

    Map<String,dynamic> userData = userResponse.body;


    return User.fromJson(userData['data']);
  }
}
