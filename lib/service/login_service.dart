import 'dart:convert';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:depremplusim/page/auth/login_view.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio/dio.dart';
import 'package:depremplusim/service/users_service.dart';

class LoginService {
  static Future<User?> fetchGoogleUser(String? phpSessId) async {
    final String status;
    final String userName;
    final String email;
    final String photoUrl;
    // CookieJar oluşturma
    var cookieJar = CookieJar();

    // CookieJar'a PHPSESSID değerini ekleme
    cookieJar.saveFromResponse(Uri.parse('${Config.baseurl}'),
        [Cookie('PHPSESSID', phpSessId ?? "")]);

    // Dio istemcisini oluşturma ve CookieManager interceptor'ünü ekleyerek yapılandırma
    var dio = Dio();
    dio.interceptors.add(CookieManager(cookieJar));

    // GET isteği gönderme
    try {
      var response =
          await dio.get('${Config.baseurl}/api.php?action=code');

      // Yanıtı işleme
      if (response.statusCode == 200) {
        // İstek başarılı ise yanıtı al
        print("cevap:${response.data}");
        var responseData = jsonDecode(response.data);
        status = responseData["status"];

        if (status == "success") {
          userName = responseData["isim"];
          email = responseData["mail"];
          photoUrl = responseData["photo"];
          User _user = User(
              name: userName, email: email, photo: photoUrl, status: status);
          return _user;
        } else {
          return null;
        }
      } else {
        // İstek başarısız ise hata mesajını al
        print('İstek başarısız: ${response.statusCode}');
      }
    } catch (error) {
      // Hata durumunda hata mesajını al
      print('Hata: $error');
    }
    return null;
  }
}
