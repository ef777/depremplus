// ignore_for_file: use_build_context_synchronously

import 'package:depremplusim/page/auth/auth_helper.dart';
import 'package:depremplusim/page/auth/sign_up_view.dart';
import 'package:depremplusim/page/auth/users_service.dart';
import 'package:depremplusim/page/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final String _login = "Giriş Yap";
  final String _eposta = "E-posta";

  Future<void> _signIn() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCredential.user!.uid;
      if (userCredential.user != null) {
        // Giriş başarılı, ana sayfaya yönlendir
   AuthHelper.writestatus(userId);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>  HomePage(),
          ),
          (route) => false,
        );
      } else {
        // Giriş başarısız, hata mesajı göster
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Hata'),
              content: const Text(
                  'Giriş yaparken bir hata oluştu. Lütfen tekrar deneyin.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Giriş yapılırken bir hata oluştu, hata mesajını görüntüleyebilirsiniz.
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Hata'),
            content:
                const Text('E-posta ya da şifre hatalı.Lütfen tekrar deneyin'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );

      print('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: null,
          centerTitle: false,
          title: Text(
            "Giriş Yap",
            style: context.general.textTheme.titleLarge?.copyWith(
              color: context.general.colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/image/yenilogo.png",
              height: 250,
            ),
            Flexible(
              child: Container(
                padding: context.padding.normal,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: context.general.colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deprem Anlık Uyarı Uygulamasına\nHoşgeldin",
                      style: context.general.textTheme.titleLarge?.copyWith(
                        color: context.general.colorScheme.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: context.general.mediaSize.height * 0.02,
                    ),
                    Text(
                      "Son olan depremlerden her an haberdar ol ve bildirim telefonuna bildirim al.",
                      style: context.general.textTheme.titleSmall?.copyWith(
                        color: context.general.colorScheme.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: context.general.mediaSize.height * 0.02,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 48,
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.all(12),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: _eposta,
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'E-posta boş olamaz';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: PaddingUtility().paddingTop,
                            child: SizedBox(
                              height: 48,
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: 'Şifre',
                                    fillColor: Colors.white,
                                    filled: true),
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Şifre boş olamaz';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              // color: Colors.redAccent,
                              child: Text(
                                _login,
                                style: context.general.textTheme.titleMedium
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  _signIn();
                                }
                               
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Henüz Bir Hesabın Yok Mu ?",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpPage()));
                                },
                                child: Text(
                                  "Üye Ol",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class PngImage extends StatelessWidget {
  const PngImage({
    super.key,
    required this.name,
    this.height = 300,
  });
  final String name;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Image.asset(_nameWithPath, height: height, fit: BoxFit.cover);
  }

  String get _nameWithPath => "assets/images/$name.png";
}

class PaddingUtility {
  final EdgeInsets smallPadding = const EdgeInsets.all(8);
  final EdgeInsets normalPadding = const EdgeInsets.all(12);
  final paddingTop = const EdgeInsets.only(top: 10);
  final paddingBotttom = const EdgeInsets.only(bottom: 20);
  final paddingGeneral = const EdgeInsets.all(22);
  final paddingHorizontal = const EdgeInsets.symmetric(horizontal: 20);
}

class ImageItems {
  final String welcome_image = "login_image";
  final String logo_image = "logo";
}
