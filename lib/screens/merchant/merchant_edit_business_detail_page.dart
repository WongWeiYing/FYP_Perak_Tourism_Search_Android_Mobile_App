import 'package:flutter/material.dart';
import 'package:go_perak/constants/app_spacing.dart';
import 'package:go_perak/constants/app_text_style.dart';
import 'package:go_perak/custom_router.dart';
import 'package:go_perak/data/food_activity_data.dart';
import 'package:go_perak/screens/user/edit_info_form_page.dart';
import 'package:go_perak/utils/state_provider.dart/activity_state.dart';
import 'package:go_perak/utils/state_provider.dart/food_state.dart';
import 'package:go_perak/utils/state_provider.dart/user_state.dart';
import 'package:go_perak/widgets/bottom_sheets/merchant_image_picker_bottom_sheet.dart';
import 'package:go_perak/widgets/grid_view/photos_grid_view.dart';
import 'package:go_perak/widgets/loading_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MerchantEditBusinessDetailPage extends StatefulHookConsumerWidget {
  final String businessType;
  final String businessID;
  const MerchantEditBusinessDetailPage(
      {super.key, required this.businessType, required this.businessID});

  @override
  MerchantEditBusinessDetailPageState createState() =>
      MerchantEditBusinessDetailPageState();
}

class MerchantEditBusinessDetailPageState
    extends ConsumerState<MerchantEditBusinessDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(uploadingProvider);

    final AsyncValue<FoodActivityDataBase> businessDetail =
        widget.businessType == 'Food'
            ? ref.watch(foodProvider(widget.businessID))
            : ref.watch(activityProvider(widget.businessID));

    return businessDetail.when(
      data: (data) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text('Business Details'),
            ),
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gapHeight12,
                        Row(
                          children: [
                            Text(
                              'Description',
                              style: AppTextStyle.header3,
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  edit(
                                      title: 'Description',
                                      oldData: data.description,
                                      maxLine: 14,
                                      fieldName: 'description');
                                },
                                icon: const Icon(Icons.mode_edit_outline))
                          ],
                        ),
                        gapHeight8,
                        MerchantContainer(data: data.description),
                        gapHeight24,
                        Row(
                          children: [
                            Text(
                              'Tags',
                              style: AppTextStyle.header3,
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  edit(
                                      title: 'Tags',
                                      fieldName: 'tags',
                                      option: 1,
                                      tags: data.tags);
                                },
                                icon: const Icon(Icons.mode_edit_outline))
                          ],
                        ),
                        gapHeight8,
                        Wrap(
                          spacing: 8,
                          runSpacing: 12,
                          children: data.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor:
                                  const Color.fromARGB(255, 254, 255, 255),
                              labelStyle: const TextStyle(color: Colors.black),
                            );
                          }).toList(),
                        ),
                        gapHeight24,
                        Row(
                          children: [
                            Text(
                              'Operating Hours',
                              style: AppTextStyle.header3,
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  edit(
                                      title: 'Operating Hours',
                                      oldData: data.operatingHours,
                                      fieldName: 'operatingHours',
                                      maxLine: 7);
                                },
                                icon: const Icon(Icons.mode_edit_outline))
                          ],
                        ),
                        gapHeight8,
                        MerchantContainer(data: data.operatingHours),
                        gapHeight24,
                        Text('Contact Information',
                            style: AppTextStyle.header3),
                        gapHeight8,
                        MerchantContainer(
                          widget: Row(
                            children: [
                              const Icon(
                                Icons.email_outlined,
                              ),
                              gapWidth12,
                              Text(data.businessEmail,
                                  style: AppTextStyle.bodyText),
                            ],
                          ),
                        ),
                        gapHeight4,
                        MerchantContainer(
                          widget: Row(
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                              ),
                              gapWidth12,
                              Text(data.contactNumber,
                                  style: AppTextStyle.bodyText),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {
                                    edit(
                                        title: 'Phone Number',
                                        oldData: data.contactNumber,
                                        fieldName: 'contactNumber');
                                  },
                                  icon: const Icon(Icons.mode_edit_outline))
                            ],
                          ),
                        ),
                        gapHeight16,
                        Row(
                          children: [
                            Text(
                              'Location',
                              style: AppTextStyle.header3,
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  edit(
                                      title: 'Location',
                                      oldData: data.address,
                                      fieldName: 'address',
                                      option: 2);
                                },
                                icon: const Icon(Icons.mode_edit_outline))
                          ],
                        ),
                        gapHeight8,
                        MerchantContainer(
                          data: data.address,
                        ),
                        gapHeight16,
                        Row(
                          children: [
                            Text(
                              'Photos',
                              style: AppTextStyle.header3,
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () async {
                                  await showMerchantImageSourceActionSheet(
                                      context,
                                      ref,
                                      data.photoUrls,
                                      widget.businessType,
                                      widget.businessID);
                                },
                                icon: const Icon(Icons.mode_edit_outline))
                          ],
                        ),
                        PhotosGridView(
                          photosUrls: data.photoUrls,
                        ),
                        gapHeight32,
                      ],
                    ),
                  ),
                ),
                if (isLoading == true)
                  Positioned.fill(
                    child: Container(
                        color: Colors.transparent, child: showLoading()),
                  )
              ],
            ),
          ),
        );
      },
      loading: () => Center(child: showLoading()),
      error: (err, stack) {
        return Center(child: Text(stack.toString()));
      },
    );
  }

  void edit(
      {required String title,
      String? oldData,
      required String fieldName,
      int? maxLine,
      int? option,
      List<String>? tags}) async {
    final result = await Navigator.pushNamed(context, CustomRouter.editInfoForm,
        arguments: EditInfoFormPage(
            oldData: oldData,
            title: title,
            collectionName: widget.businessType,
            docID: widget.businessID,
            maxLine: maxLine,
            tags: tags,
            option: option ?? 0,
            fieldName: fieldName));
    if (result == true) {
      if (widget.businessType == 'Food') {
        ref.invalidate(foodProvider(widget.businessID));
      } else {
        ref.invalidate(activityProvider(widget.businessID));
      }
    }
  }
}

class MerchantContainer extends StatelessWidget {
  final String? data;
  final Widget? widget;
  const MerchantContainer({
    this.data,
    this.widget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 235, 233, 233)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget ??
          Text(
            data ?? '',
            style: AppTextStyle.bodyText,
          ),
    );
  }
}
