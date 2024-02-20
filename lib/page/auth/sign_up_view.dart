import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depremplusim/page/auth/users_service.dart';
import 'package:depremplusim/page/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'sign_in_page.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  Future<void> _signUp() async {
    try {
      // final username = _usernameController.text;
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;
      if (password != confirmPassword) {
        print('Hata: Şifreler eşleşmiyor');
        return;
      }

      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final userId = userCredential.user?.uid ?? '';
             //          addUser(name: userCredential.user!.displayName ?? "kullanici", email: userCredential.user!.email, photo: userCredential.user!.photoURL);

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': _emailController.text.trim(),
        'userId': userId,
        'username': _usernameController.text.trim(),
        'password': _passwordController.text,
        'photoUrl': '',
      });
      // Kullanıcı kaydı başarılı, bilgilendirme mesajı göster
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Başarılı'),
            content: Text('Üyelik işlemi başarıyla tamamlandı.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Tamam'),
              ),
            ],
          );
        },
      );
      // Kullanıcı kaydı başarılı, istediğiniz işlemleri yapabilirsiniz.
    } catch (e) {
      // Kayıt oluşturulurken bir hata oluştu, hata mesajını görüntüleyebilirsiniz.
      if (mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            print(e.toString());
            return AlertDialog(
              title: Text('Hata'),
              content: e.toString().contains('email-already-in-use')
                  ? Text(
                      'Kaydolmaya çalıştığınız e-posta adresi zaten başka bir kullanıcı tarafından kullanılıyor.')
                  : Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Tamam'),
                ),
              ],
            );
          },
        );
      }
      print('Hata: $e');
    }
  }

  final String _uyeOl = "Üye Ol";

  final String _mail = "Mail adresinizi giriniz";

  final String _username = "Kullanıcı";

  final String _password = "Şifrenizi girin";

  final String _passwordAgain = "Şifrenizi tekrar girin";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          centerTitle: false,
          title: Text(
            "Kayıt Ol",
            style: context.general.textTheme.titleLarge?.copyWith(
              color: context.general.colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Image.asset(
              "assets/image/yenilogo.png",
              height: 250,
            ),
            const SizedBox(
              height: 100,
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
                child: SingleChildScrollView(
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
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                    errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    contentPadding: const EdgeInsets.all(12),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: _mail),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email boş olamaz';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: context.padding.onlyTopLow,
                              child: SizedBox(
                                height: 48,
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      focusedErrorBorder:
                                          const OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      contentPadding: const EdgeInsets.all(12),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: _password),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Şifre boş olamaz';
                                    } else if (value.length < 6) {
                                      return 'Şifre 6 haneden küçük olamaz';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: context.padding.onlyTopLow,
                              child: SizedBox(
                                height: 48,
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      focusedErrorBorder:
                                          const OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                      errorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      contentPadding: const EdgeInsets.all(12),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: _passwordAgain),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Şifre boş olamaz';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Şifreler eşleşmiyor';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            // Padding(
                            //   padding: PaddingApp.paddingSmallTop,
                            //   child: CustomTextField(
                            //       text: _passwordAgain, isPassword: true),
                            // ),
                            SizedBox(
                              height: context.general.mediaSize.height * 0.02,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                //   color: Colors.redAccent,
                                child: Text(
                                  _uyeOl,
                                  style: context.general.textTheme.titleMedium
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _signUp();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (route) => false,
                                    );
                                  }
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Bir Hesabın Mı Var ?",
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
                                                const SignInPage()));
                                  },
                                  child: Text(
                                    "Giriş Yap",
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
              ),
            ),
          ],
        ));
  }
}
