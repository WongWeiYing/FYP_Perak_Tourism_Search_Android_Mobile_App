import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/main.dart';
import 'package:go_perak/widgets/background.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBackground(
      backgroundType: BackgroundType.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Login'),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.r)),
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2)),
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Username'),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
