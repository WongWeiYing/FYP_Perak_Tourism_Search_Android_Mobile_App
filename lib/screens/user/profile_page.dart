import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_color.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/generated/assets.gen.dart';
import 'package:go_perak/repositories/auth.dart';
import 'package:go_perak/utils/state_provider.dart/app_bottom_nav_state.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/bar/app_bottom_nav_bar.dart';
import 'package:go_perak/widgets/dialog/logout_dialog.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:go_perak/widgets/tile/profile_menu_tile.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends StatefulHookConsumerWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final userDetailsAsyncValue = ref.watch(userDetailsProvider);

    return userDetailsAsyncValue.when(
        loading: () => Center(child: showLoading()),
        error: (err, stack) {
          return Center(child: Text(stack.toString()));
        },
        data: (data) {
          return SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                bottomNavigationBar: ProjectAppBottomNav(),
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                        color: AppColor.black, fontWeight: FontWeight.bold),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: data.profilePic.isEmpty
                                        ? Image.asset(
                                            Assets.images.userDefault.path,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            data.profilePic,
                                            fit: BoxFit.cover,
                                          ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                data.username,
                              ),
                              gapHeight32,
                              Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColor.lineGray,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                              gapHeight32,
                              ProfileMenuWidget(
                                title: 'Edit Profile',
                                icon: Icons.person_2_outlined,
                                onPress: () {
                                  Navigator.pushNamed(
                                      context, CustomRouter.editUserInfo);
                                },
                              ),
                              gapHeight16,
                              ProfileMenuWidget(
                                title: 'Log out',
                                icon: Icons.logout_outlined,
                                onPress: () async {
                                  await showLogoutDialog(context);
                                  ref
                                      .read(bottomNavigationProvider.notifier)
                                      .setSelectedIndex(0);
                                },
                                textColor: AppColor.errorColor,
                                endIcon: false,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}
