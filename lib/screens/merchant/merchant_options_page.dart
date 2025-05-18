import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/screens/merchant/merchant_edit_business_detail_page.dart';
import 'package:go_perak/widgets/dialog/logout_dialog.dart';
import 'package:go_perak/widgets/tile/profile_menu_tile.dart';

class MerchantOptionsPage extends HookWidget {
  final String businessID;
  final String businessType;

  const MerchantOptionsPage({
    super.key,
    required this.businessID,
    required this.businessType,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileMenuWidget(
              title: 'Edit Business Details',
              icon: Icons.person_2_outlined,
              endIcon: false,
              onPress: () {
                Navigator.pushNamed(context, CustomRouter.merchantEditDetails,
                    arguments: MerchantEditBusinessDetailPage(
                        businessType: businessType, businessID: businessID));
              },
            ),
            gapHeight16,
            ProfileMenuWidget(
              title: 'Log out',
              icon: Icons.logout_outlined,
              onPress: () async {
                await showLogoutDialog(context);
              },
              textColor: AppColor.errorColor,
              endIcon: false,
            ),
          ],
        ),
      ),
    ));
  }
}
