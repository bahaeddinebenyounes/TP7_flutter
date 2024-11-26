

import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  String navTitle ;
  NavBar(this.navTitle, {super.key});
  @override



  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple[800],
      title : Text(navTitle),
      actions: [
        IconButton(icon:const Icon(Icons.logout),onPressed: (){
          Navigator.of(context).popAndPushNamed('/login');
        },)
      ],
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(60);
}