
import 'package:flutter/material.dart';

class CustomWidgets {
  List<PopupMenuEntry<dynamic>> popMenuList = List.empty(growable: true);



  PopupMenuItem _buildPopupMenuItem(
      String title, ImageIcon iconData, bool isLastParameter) {
    return PopupMenuItem(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                iconData,
                const SizedBox(
                  width: 20,
                ),
                Text(title),
              ],
            ),
          ),
          Visibility(
            visible: isLastParameter,
            child: const Divider(
              indent: 0,
              thickness: 2,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  roundIconWidget(String imagePath,
      {double iconWidth = 70,
        double iconHeight = 70}) {
    return Image.asset(imagePath, width: iconWidth, height: iconHeight, fit: BoxFit.fill,);
  }

  headerTitle(String titleText, TextStyle style) {
    return Flexible(
      child: Text(
        titleText,
        style: style,
      ),
    );
  }
}
