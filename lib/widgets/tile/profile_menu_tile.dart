import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_color.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPress,
      this.textColor = AppColor.black,
      this.endIcon = true});

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: AppColor.primaryColor.withOpacity(0.2),
          ),
          child: Icon(
            icon,
            color: AppColor.black,
          )),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      trailing: endIcon
          ? Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColor.timeGreyColor.withOpacity(0.05),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColor.timeGreyColor,
              ))
          : null,
    );
  }
}
