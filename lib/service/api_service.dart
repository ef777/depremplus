import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:depremplusim/page/auth/login_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
//yeni servis 	
import 'dart:convert';

import 'package:http/http.dart' as http;
class TraceResponse {
  String? fl;
  String? h; 
  String? ip;
  int? ts;
  String? visitScheme;
  String? uag; 
  String? colo;
  String? sliver;
  String? http;
  String? loc;
  String? tls; 
  String? sni;
  String? warp;
  String? gateway;
  String? rbi;
  String? kex;

  TraceResponse.fromPlainText(String text) {

    var lines = text.split('\n');
   
 
    for (var line in lines) {
      
      var parts = line.split('=');
      if (line.isEmpty || parts.length != 2) {
        continue;
      }
      var key = parts[0];
      var value = parts[1];
      if (key == 'loc') {
        loc = value;
      }
      
     else if (key == 'fl') {
        fl = value;
      }
      else if (key == 'h') {
        h = value;    
      }
      else if (key == 'ip') {
        ip = value;
      }
      else if (key == 'ts') {
        ts = int.tryParse(value);
      }
      else if (key == 'visit_scheme') {
        visitScheme = value;
      }  
      else if (key == 'uag') {
        uag = value;
      }
      else if (key == 'colo') {
        colo = value;
      }
      else if (key == 'sliver') {
        sliver = value;
      }
      else if (key == 'http') {
        http = value;
      }
    
      else if (key == 'tls') {
        tls = value;
      }
      else if (key == 'sni') {
        sni = value;  
      }
      else if (key == 'warp') {
        warp = value;
      }
      else if (key == 'gateway') {
        gateway = value;
      }
      else if (key == 'rbi') {
        rbi = value;
      }
      else if (key == 'kex') {
        kex = value;
      }

    }

  } 

  String getCountry(loc) {

    if (loc != null) {
      print("boş değil");
      return loc.toString();
    }
    return 'Unknown';
  }
}

// Kullanım:


Future<String> whoisistek() async {


  var url = Uri.https('cloudflare.com', '/cdn-cgi/trace');

  var response = await http.get(url);
  
     print("işte res" + response.body);
  var responseText = response.body;

   print("işte json data"+responseText);
var trace = TraceResponse.fromPlainText(responseText);
var gelentrace= trace.loc;

  print("işte trace"+gelentrace.toString());
  var sonuc= trace.getCountry(gelentrace);
  print("seçili trace" + sonuc.toString());

  return  await sonuc.toString();

}





class ApiService {
  // APİ LİNKİNİ ALIR
  static String apiBaseLink = '';

  static initializeApiBaseLink() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('api').limit(1).get();

      if (querySnapshot.size > 0) {
        QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        apiBaseLink = documentSnapshot.get('api_base_link');
      return apiBaseLink;
      } 
      
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }
  /*
static Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print("İnternet bağlantısı var");
     return true;
    }
  } on SocketException catch (_) {
    print("İnternet bağlantısı yok");
    Config.login = "0"; // Internet bağlantısı olmadığında 0 olarak ayarla
    return false;
  }
  return false;
} */
/*
static dynamic fetchGirisSekli2() async {
  // internet kontrolu

bool isConnected = await checkInternetConnection();
if (isConnected) {

  Get.snackbar("İnternet success!", "Internet bağlantısı başarılı");
} else {
  Get.snackbar("İnternet error!", "Internet bağlantısı bulunamadı");
print("internet yok");
  return false;
}

  // cihaz dili kontrolu

final locale = Get.locale;

print("cihaz dili");
print(locale.toString());

if( locale.toString() != "tr_TR"){
print("evet cihaz tr");
}

if(locale.toString() != "tr_TR"){
print("tr değil");
return false;
}

  // cihaz dili kontrolu


  try {
  var a= await whoisistek();
  print("a değeri" + a.toString());
  if (a.toString() != "TR") {
    print("nt");
    Config.login = "0";
    return false;
  } 
  }
  catch (e) {
    print('Hata oluştu: $e');
        return false;

  }

  // cihiz dili kontrolu
try {
String burl = await initializeApiBaseLink();
print("burl değeri" + burl.toString());
Config.baseurl = burl.toString();

}
catch (e) {
    print(' base url Hata oluştu: $e');
        return false;

}
    try {
      final response =
          await http.get(Uri.parse('${Config.baseurl}/st.php'));

      if (response.statusCode == 200) {
        
        final data = json.decode(response.body);
        print("gelen status data $data");
     bool dogru =  data == 1; 
      // true olarak değerlendirilir
       print("dogru $dogru");
        if (dogru) {
          print("doğru döndü");
          return dogru;

        } else {
              Config.login = "0";

          return false;

        }
        // Veri işlemlerini burada gerçekleştirin
      } else {

        print('API isteği başarısız oldu. Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
            print('Hata oluştu: $e');
    Config.login = "0";

      return false;
    }
        Config.login = "0";

    return false;
  }
 
 */
}
