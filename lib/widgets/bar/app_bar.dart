import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_text_style.dart';

class ProjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLeading;
  final Widget? leading;
  final Color? backgroundColor;
  final String? title;
  final Color? titleColor;
  final Widget? titleWidget;
  final Widget Function(Widget child)? titleBuilder;
  final List<Widget> actions;
  final VoidCallback? onTap;

  const ProjectAppBar(
      {super.key,
      this.title,
      this.titleColor,
      this.leading,
      this.titleWidget,
      this.titleBuilder,
      this.backgroundColor,
      this.showLeading = true,
      this.actions = const [],
      this.onTap});

  @override
  Widget build(BuildContext context) {
    final titleChild = Text(title ?? '',
        style: AppTextStyle.header3
            .copyWith(color: titleColor ?? AppColor.mainBlack));

    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: kToolbarHeight,
      leading: showLeading
          ? leading ??
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back))
          : const SizedBox.shrink(),
      title: titleWidget ?? titleBuilder?.call(titleChild) ?? titleChild,
      actions: [Row(children: actions)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
