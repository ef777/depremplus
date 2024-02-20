import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class NotifiPage extends StatelessWidget {
  const NotifiPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        centerTitle: false,
        actions: [
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
          'Bildirimler',
          style: context.general.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: context.padding.low,
        child: const Column(
          children: [
            SettingsWidget(
              color: Colors.black,
              icon: Icons.notifications_active,
              title: 'Bildirim Deprem Oldu',
            ),
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
                    ?.copyWith(fontWeight: FontWeight.w500),
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
