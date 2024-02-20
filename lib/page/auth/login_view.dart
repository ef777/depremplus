import 'dart:convert';
import 'package:depremplusim/model/google_code_model.dart';
import 'package:depremplusim/page/auth/auth_helper.dart';
import 'package:depremplusim/page/auth/google_auth_webview.dart';
import 'package:depremplusim/page/auth/sign_up_view.dart';
import 'package:depremplusim/page/auth/users_service.dart';
import 'package:depremplusim/page/home/home_page.dart';
import 'package:depremplusim/service/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'package:kartal/kartal.dart';
import 'sign_in_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class AssetsManager{
  static String imagePath = "assets/image";
  static String userImage = "$imagePath/person.png";
  static String botImage = "$imagePath/chat_logo.png";
  static String openaiLogo = "$imagePath/openai_logo.jpg";
  static String profileIcon = "$imagePath/ic_profile.png";
  static String instaIcon = "$imagePath/instagram.png";
  static String instaAccountIcon = "$imagePath/insta-account.png";
  static String universeImage = "$imagePath/universe.png";
  static String magicImageDark = "$imagePath/magic-wand.png";
  static String magicImageLight = "$imagePath/magic-wand2.png";
  static String imageGallery = "$imagePath/image-gallery.png";
  static String threeDots = "$imagePath/ic_three_dots.png";
  static String mailIcon = "$imagePath/email.png";
  static String telIcon = "$imagePath/phone-call.png";
  static String worldImage = "$imagePath/world.png";
  static String ileLogo = "$imagePath/ileLogo.jpg";
  static String postImage = "$imagePath/post_image.png";
  static String logoImage = "$imagePath/logo.png";
  static String googleImage = "$imagePath/google.png";
  
}
class Config {
  static String id = "*";
  static String login = "0";
  static String baseurl = "";
}

class PaddingApp {
  static EdgeInsets paddingBody = const EdgeInsets.symmetric(horizontal: 8,vertical: 15);
  static EdgeInsets paddingLoginPage = const EdgeInsets.symmetric(horizontal: 20,vertical: 15);
  static EdgeInsets paddingTop = const EdgeInsets.only(top: 5);
  static EdgeInsets paddingSmallTop = const EdgeInsets.only(top: 10);
  static EdgeInsets paddingLargeTop = const EdgeInsets.only(top: 30);
  static EdgeInsets paddingBottom = const EdgeInsets.only(bottom: 10);
  static EdgeInsets paddingMediumBottom = const EdgeInsets.only(bottom: 20);
  static EdgeInsets paddingZero = EdgeInsets.zero;
  static  final EdgeInsets normalPadding = EdgeInsets.all(12);


}
// String userId="";
class LoginPage extends StatefulWidget {
  LoginPage({super.key, });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static GoogleCodeModel? _item;

  // final _url = 'https://youtube.com/activate';
  void _launchUrl() async {
    const url =
        'https://youtube.com/activate'; // Açmak istediğiniz web sitesinin URL'sini buraya yazın
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Web sitesi açılamadı: $url';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGoogleCode();
  }

  //PHPSESSİON ID YI ALMA FONKSİYOUNU
  String extractPhpSessionId(String? cookie) {
    if (cookie!.isNotEmpty) {
      final parts = cookie.split(';');
      for (final part in parts) {
        final keyValue = part.trim().split('=');
        if (keyValue.length == 2 && keyValue[0] == 'PHPSESSID') {
          return keyValue[1];
        }
      }
    } 
    return '';
  }

  Future<void> fetchGoogleCode() async {
    try {
      final response =
          await http.get(Uri.parse('${Config.baseurl}/api.php'));

      if (response.statusCode == 200) {
        print("istek başarılı");
        final _data = jsonDecode(response.body);
        print("body:${response.body}");
        final cookie = response.headers['set-cookie'];
        // PHPSESSID'yi almak için:
      //  setState(() {
          _item = GoogleCodeModel.fromJson(_data);

          _item?.code = extractPhpSessionId(cookie);
          _item?.link = _item?.link;
       // });
        // final _datas = json.decode(response.body);
        // print(_datas);
        // if(_datas is List){

        // }

        // Veri işlemlerini burada gerçekleştirin
      } else {
        print('API isteği başarısız oldu. Hata kodu: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }


  Future<void> signInWithGoogle() async {
    //firebase kimlik doğrulamasının bir örneği ve google oturumu oluşturma
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    //triger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    //taking Username and email

    //obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    //Create a new credentials
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    //Sign in the user with the credentials
    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    final userId = userCredential.user!.uid ?? "";
    final String userName = userCredential.user!.displayName ?? "";
    final String email = userCredential.user!.email ?? "";
    final String photoUrl = userCredential.user!.photoURL ?? "";
    print("id:$userId kullanıcı adı:$userName email:$email photo:$photoUrl");
    checkIfUserExists(email.toString()).then(
      (value) {
        if (value) {
          print("kullanıcı zaten var loginview");
        } else {
          addUser(name: userName, email: email, photo: photoUrl);
          print("kullanıcı eklendi loginview");
        }
      },
    );
    if (userCredential.user != null) {
      // Giriş başarılı, ana sayfaya yönlendir
      Config.login = "1";

      AuthHelper.writestatus(userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage()
        ),
      );
    }
  }

  final String _loginWithGoogle = "Login With Google";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
        body:
      
         SingleChildScrollView(
      child:         Container(
        height: 700,
 child: Padding(
        padding: PaddingApp.paddingLoginPage,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               

              Padding(
                  padding: PaddingApp.paddingLargeTop,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Gölge rengi
                          spreadRadius: 2, // Gölge yayılma yarıçapı
                          blurRadius: 5, // Gölge bulanıklık yarıçapı
                          offset: Offset(0, 3), // Gölgenin konumu
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(10), // Kenarları yuvarlak yapar
                      child:   Image.asset(
                  "assets/image/yenilogo.png",
                  height: 250,
                ),
                    ),
                  )),
SizedBox(height: 50,),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                          "Deprem Anlık Uyarı Uygulamasına\nHoşgeldin",
                          style: context.general.textTheme.titleLarge?.copyWith(
                            color: context.general.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
              ),
                SizedBox(
                          height: context.general.mediaSize.height * 0.02,
                        ),
                        Text(
                          "Son olan depremlerden her an haberdar ol ve bildirim telefonuna bildirim al.",
                          style: context.general.textTheme.titleSmall?.copyWith(
                            color: context.general.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
           /*   SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<dynamic>(
                  future: ApiService.fetchGirisSekli2(),
                  
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Veri çekme işlemi hala devam ediyorsa, yükleniyor gösterebilirsiniz
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      // Veri çekme işleminde hata oluştuysa, hata mesajını gösterebilirsiniz
                      return Text('Veri çekme hatası: ${snapshot.error}');
                    } else {

                     var gelen= snapshot.data;
                     print("logine gelen url");
                      print(gelen);
                     
                      // Veri çekme işlemi tamamlandıysa, sonucu kullanarak widget oluşturabilirsiniz
                      return buildLoginButton(snapshot.data ?? false, context);
                    }
                  },
                ),
              ) */
            ],
          ),
        ),
      ),
      ) ) );
  }

  Widget buildLoginButton(dynamic fetchDataResult, BuildContext context) {
    if ( fetchDataResult !=false ) {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                ),
                onPressed: () async {
                  // showCodePopup(context, _item?.code??"deneme");
                 Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoogleAuthWebView(
                          _item?.link ?? "", _item?.code, ),
                    ),
                    (route) => false,
                  ); 

               
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                    SizedBox(width: 15),
                    Text(
                      _loginWithGoogle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                            
                            )));
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 25, 187, 251),
              )),
              child: Text(
                'Misafir Girişi',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpPage(
                            
                            )));
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                Color.fromARGB(255, 25, 187, 251),
              )),
              child: Text(
                'Üye Ol',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignInPage(
                        
                            )));
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                Colors.pinkAccent,
              )),
              child: Text(
                'Giriş Yap',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.5,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
