import 'package:depremplusim/page/auth/auth_helper.dart';
import 'package:depremplusim/page/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        centerTitle: false,
        actions: [
          //ddrtyqwe 
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ))
        ],
        title: Text(
          'AYARLAR',
          style: context.general.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: context.padding.low,
        child: Column(
          children: [
            const SettingsWidget(
              color: Colors.black,
              icon: Icons.person,
              title: 'Hesap Bilgileri',
            ),
            const SettingsWidget(
              color: Color.fromRGBO(0, 0, 0, 1),
              icon: Icons.notifications_none_sharp,
              title: 'Bildirim Ayarları',
            ),
            SettingsWidget(
              onTap: () {
                AuthHelper.deletestatus();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  LoginPage(),
                    ),
                    (route) => false);
              },
              color: Colors.black,
              icon: Icons.exit_to_app,
              title: 'Çıkış Yap',
            ),
            SettingsWidget(
              onTap: () {
                                AuthHelper.deletestatus();

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  LoginPage(),
                    ),
                    (route) => false);
              },
              color: Colors.black,
              icon: Icons.delete_outlined,
              title: 'Hesabı Sil',
            )
          ],
        ),
      ),
    );
  }
}

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final Color color;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(6),
          height: 80,
          decoration: BoxDecoration(
              borderRadius: context.normalBorderRadius,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.blueGrey.withOpacity(.1),
                    blurRadius: 20,
                    spreadRadius: 7)
              ]),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: color),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                title,
                style: context.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w500,color: Colors.black),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(52, 225, 225, 225)),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
