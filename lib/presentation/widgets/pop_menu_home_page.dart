import 'package:cnn_detect_objects/presentation/pages/about_page/about_page.dart';
import 'package:cnn_detect_objects/presentation/pages/objects_page/objects_page.dart';
import 'package:flutter/material.dart';

class PopMenuHomePage extends StatelessWidget {
  const PopMenuHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'Objetos',
            child: Row(
              children: [
                Icon(
                  Icons.list_alt_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                const Text('Objetos'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'About',
            child: Row(
              children: [
                Icon(
                  Icons.person_pin_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                const Text('Acerca de'),
              ],
            ),
          ),
        ];
      },
      padding: const EdgeInsets.all(15.0),
      elevation: 3.0,
      offset: const Offset(1.0, 0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).iconTheme.color,
      ),
      onSelected: (selectedItem) async {
        switch (selectedItem) {
          case 'About':
            final route =
                MaterialPageRoute(builder: (context) => const AboutPage());
            Navigator.push(context, route);
            break;
          case 'Objetos':
            final route =
                MaterialPageRoute(builder: (context) => ObjectsPage());
            Navigator.push(context, route);
            break;
        }
      },
    );
  }
}
