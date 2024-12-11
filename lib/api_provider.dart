import 'package:get/get.dart';

class ApiProvider extends GetConnect {
  ApiProvider() {
    timeout = const Duration(seconds: 30);
    // allowAutoSignedCert = true; // the solution

    
  }

  // Get request
  Future<Response> getUser(String token) {
    return get('https://traffic.gyancommunity.com/api/users?token=$token');
  }

  Future<Response> authenticate() {
    return get('https://traffic.gyancommunity.com/api/nagarik-login');
  }
}
