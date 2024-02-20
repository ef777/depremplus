import 'package:depremplusim/page/auth/login_view.dart';
import 'package:depremplusim/page/home/home_page.dart';
import 'package:depremplusim/service/api_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';
const KEY_IS_FIRST_TIME = 'isFirstTime';

 tokenal()async{

  String? token = await FirebaseMessaging.instance.getToken();
print("FCM Token: $token");

  final url = "http://ile.com.tr/tokenekle.php?token=$token&uid=0";
  
  final response = await http.get(
    Uri.parse(url),
  
  );

  if(response.statusCode == 200) {
    print("Token başarıyla gönderildi");
  } else {
    print("Hata oluştu: ${response.statusCode}"); 
  }




 }

 void onFirstTime() {
  GetStorage().write(KEY_IS_FIRST_TIME, false);
    tokenal();

  // burada firebase token işlemleri
}
Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );   await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
     
    await GetStorage.init();

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
var girisdeger = false;
var hizligiris;
 Future<bool> klaslogin()async{
  print("kals login baişladı");
 //bool a=  await ApiService.fetchGirisSekli2();
 
 //false dönerse direkt açılacak demek. true açılırsa status kontrol edecek
    await Future.delayed(Duration(seconds: 1));
    //print(" login bitti $a");
     
      return false;
     } 

 onStart() {

print("onstart çalıştı");
  bool? isFirstTime = GetStorage().read(KEY_IS_FIRST_TIME);
    bool? isload = GetStorage().read("login");
    print("isload değeri"+ isload.toString() );
  if(isFirstTime == null) {
    // ilk giriş
    onFirstTime();
    print("ilk kez açılıyor");
    return false;

  } else {
   // normal giriş 
   print("önceden açılmış");
 
  if(isload != true){
    print("giriş yapılmamış");
    return false;
    
  }
  else{
        print("userid : " + GetStorage().read("userid").toString());
     Config.id = GetStorage().read("userid").toString();
    print("giriş yapılmış");
    return true;
  }

}

}
var whois="";
@override
void initState() {

 girisdeger =   onStart();

  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home:
      FutureBuilder(
        future: klaslogin(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
          bool a = snapshot.data!;
            return a ?  girisdeger == true  ?  HomePage() : LoginPage()  : HomePage(); 
          }
          else{
            return Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }
        }),
      
      theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          appBarTheme:
               AppBarTheme(elevation: 0, color:  Color.fromARGB(255, 74, 1, 1),),
          colorScheme:  ColorScheme(
            
              background: Color.fromARGB(255, 171, 5, 5),
              brightness: Brightness.dark,
              error: Colors.amber,
              onBackground: Colors.red,
              onError: Colors.redAccent,
              onPrimary: Colors.white,
              onSecondary: Color.fromARGB(255, 142, 31, 11),
              onSurface: Colors.redAccent,
              primary: Colors.redAccent,
              secondary: Colors.redAccent,
              surface: Color.fromARGB(255, 222, 24, 2))),
    );
  }
}
