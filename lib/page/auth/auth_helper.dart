import 'package:depremplusim/page/auth/login_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static String isLoggedInKey = 'isLoggedIn';

 
  
  static Future<String?> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = await prefs.getBool(isLoggedInKey) ?? false;
   print(isLoggedIn ? "Kullanıcı giriş yapmış" : "Kullanıcı giriş yapmamış");
  
  if (isLoggedIn) {
    // Kullanıcı giriş yapmış, userId'yi al
    String? userId = await prefs.getString('userId');
    print("veri tabanından alınan user id: $userId");

  await Future.delayed( 
      Duration(seconds: 2),
      () {
        print("2 saniye sonra");
      },
   );

    return await userId;
  }

  
  

  return "bos";
}

  static Future<String?> writestatus(userid) async {
       Config.login = "1";
        GetStorage().write("login", true);
        GetStorage().write("userid", userid);
    print("kayıt yapıldı");
   print("login olundu mu ? " + GetStorage().read("login").toString());
    print("userid : " + GetStorage().read("userid").toString());
  return null;
} static Future<String?> deletestatus() async {
       Config.login = "0";
        GetStorage().write("login", false);
        GetStorage().write("userid", "");
    print("kayıt yapıldı");
   print("login silindi mi mu ? " + GetStorage().read("login").toString());
    print("userid : " + GetStorage().read("userid").toString());
  return null;
}

}
