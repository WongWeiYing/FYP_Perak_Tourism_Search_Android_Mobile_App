import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/food_activity_data.dart';
import 'package:go_perak/screens/chat_list_page.dart';
import 'package:go_perak/screens/merchant/merchant_business_reviews_page.dart';
import 'package:go_perak/screens/merchant/merchant_options_page.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/greeting_row_widget.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MerchantHomePage extends HookConsumerWidget {
  const MerchantHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchantDetailsAsync = ref.watch(merchantDetailsProvider);
    final currentPageIndex = useState(0);
    final pageController = usePageController();

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: merchantDetailsAsync.when(
            data: (merchantData) {
              final AsyncValue<FoodActivityDataBase>
                  merchantBusinessDetailsAsync;
              if (merchantData.categoryType == 'Food') {
                merchantBusinessDetailsAsync =
                    ref.watch(foodProvider(merchantData.businessID));
              } else {
                merchantBusinessDetailsAsync =
                    ref.watch(activityProvider(merchantData.businessID));
              }

              return merchantBusinessDetailsAsync.when(
                data: (FoodActivityDataBase data) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        buildGreetingRow(
                            context,
                            data.businessName,
                            data.businessLogo,
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, CustomRouter.merchantOptions,
                                    arguments: MerchantOptionsPage(
                                        businessID: merchantData.businessID,
                                        businessType:
                                            merchantData.categoryType));
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(Icons.settings_outlined),
                              ),
                            )),
                        gapHeight32,
                        Row(
                          children: [
                            Expanded(
                                child: tab('Reviews', 0, currentPageIndex,
                                    pageController)),
                            Expanded(
                                child: tab('Chats', 1, currentPageIndex,
                                    pageController))
                          ],
                        ),
                        gapHeight16,
                        Expanded(
                          child: PageView(
                            controller: pageController,
                            onPageChanged: (index) {
                              currentPageIndex.value = index;
                            },
                            children: [
                              MerchantBusinessReviewsPage(
                                businessID: merchantData.businessID,
                                businessType: merchantData.categoryType,
                              ),
                              const ChatListPage()
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                error: (error, stack) => Center(child: Text('Error: $error')),
                loading: () => SizedBox.expand(
                  child: Center(child: showLoading()),
                ),
              );
            },
            error: (error, stack) {
              return Center(child: Text('Error: $error'));
            },
            loading: () => SizedBox.expand(
              child: Center(child: showLoading()),
            ),
          )),
    );
  }

  Widget tab(String title, int index, ValueNotifier<int> currentPageIndex,
      PageController pageController) {
    final isSelected = currentPageIndex.value == index;

    return InkWell(
        onTap: () {
          currentPageIndex.value = index;
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 7.5.h),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 0, 187, 156)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(32.r),
          ),
          child: Center(
            child: Text(
              title,
              style: isSelected
                  ? AppTextStyle.action.copyWith(color: Colors.white)
                  : AppTextStyle.description,
            ),
          ),
        ));
  }
}
