import 'package:flutter/material.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({super.key, required this.menuList, this.icon});

  final List<PopupMenuEntry> menuList;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (_){},
      color: const Color(0xfffff5ea),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      itemBuilder: ((context) => menuList),
    icon: icon,
    )
    ;
  }
}
