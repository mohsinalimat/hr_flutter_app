import 'package:flutter/material.dart';
// import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:get/get.dart';
import 'package:hr_application/app/modules/HomePage/views/user_activity_view.dart';
import 'package:hr_application/data/controllers/app_storage_service.dart';
import 'package:hr_application/utils/app_extension.dart';
import 'package:hr_application/utils/theme/app_colors.dart';
import 'package:hr_application/utils/theme/app_theme.dart';
import 'package:hr_application/widgets/horizontal_date.dart';
import 'package:intl/intl.dart';

import '../controllers/home_page_controller.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          //? User Profile
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(minRadius: 35),
                16.width,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStorageController.to.currentUser?.fullName ?? '-',
                      style: Get.textTheme.headlineMedium,
                    ),
                    Text(
                      AppStorageController.to.currentUser?.companyName ?? '-',
                      style: Get.textTheme.bodyLarge,
                    ),
                  ],
                ),
                const Spacer(),
                IconButton.outlined(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_active_outlined),
                )
              ],
            ),
          ),
          12.height,
          //? Date Picker
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              return HorizontalDate(
                fromDate: DateTime.now(),
                toDate: DateTime.now().subtract(const Duration(days: 10)),
                selectedDate: controller.selectedDate.value,
                onTap: controller.onDateChnged,
              );
            }),
          ),
          28.height,
          //? Today Attendence Text
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              children: [
                Text("Today Attendence", style: Get.textTheme.headlineSmall),
                16.width,
                Obx(
                  () {
                    return controller.attendenceLoading.value
                        ? const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              color: AppColors.kFoundationPurple700,
                              strokeWidth: 1.5,
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              ],
            ),
          ),
          8.height,
          //? Check In && Check Out
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() {
                    return _buildCheckInOutCard(
                      Icons.input_rounded,
                      "Check In",
                      controller.attendenceModel.value?.inTime == null
                          ? "-"
                          : DateFormat("hh:mm:ss").parse(controller.attendenceModel.value!.inTime!).tohhMMh,
                      controller.userActivityModel.value?.checkIn?.msg ?? '',
                    );
                  }),
                ),
                10.width,
                Expanded(
                  child: Obx(
                    () {
                      return _buildCheckInOutCard(
                        Icons.input_rounded,
                        "Check Out",
                        controller.attendenceModel.value?.outTime == null
                            ? "-"
                            : DateFormat("hh:mm:ss").parse(controller.attendenceModel.value!.outTime!).tohhMMh,
                        controller.userActivityModel.value?.outTime?.msg ?? '',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          8.height,
          //? Break Time && Total Days
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Expanded(child: _buildCheckInOutCard(Icons.free_breakfast_outlined, "Break Time", "00:20 min", "Avg Time 30min")),
                Expanded(
                  child: Obx(
                    () {
                      return _buildCheckInOutCard(
                        Icons.free_breakfast_outlined,
                        "Break Time",
                        controller.calculateTimeDifference(
                                controller.attendenceModel.value?.breakInTime, controller.attendenceModel.value?.breakOutTime) ??
                            '-',
                        "",
                      );
                    },
                  ),
                ),
                10.width,
                Expanded(
                  child: _buildCheckInOutCard(
                    Icons.calendar_today_outlined,
                    "Total Days",
                    controller.countWorkingDays.toString(),
                    "Working Days",
                  ),
                ),
              ],
            ),
          ),
          20.height,
          //? Your Activity View All
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Your Activity", style: Get.textTheme.headlineSmall),
                    16.width,
                    Obx(
                      () {
                        return controller.activityLoading.value
                            ? const SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: AppColors.kFoundationPurple700,
                                  strokeWidth: 1.5,
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    "View All",
                    style: Get.textTheme.bodyLarge?.copyWith(
                      color: AppColors.kFoundationPurple700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                return UserActivityView(
                  userActivityModel: controller.userActivityModel.value,
                );
              })),
          28.height,
          //? Swipe Button
          // Obx(() {
          //   return controller.attendenceModel.value?.outTime == null &&
          //           (controller.selectedDate.value.year == controller.now.year &&
          //               controller.selectedDate.value.month == controller.now.month &&
          //               controller.selectedDate.value.day == controller.now.day)
          //       ? Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 16),
          //           child: SwipeButton.expand(
          //             thumb: const Icon(
          //               Icons.double_arrow_rounded,
          //               color: Colors.white,
          //             ),
          //             thumbPadding: const EdgeInsets.all(6),
          //             height: 58,
          //             borderRadius: borderRadius,
          //             activeThumbColor: AppColors.kFoundationPurple700,
          //             activeTrackColor: AppColors.kFoundationPurple100,
          //             onSwipe: controller.performInOut,
          //             child: Obx(() {
          //               return Text(
          //                 controller.userPerformActivty.value.label,
          //                 style: Get.textTheme.titleSmall,
          //               );
          //             }),
          //           ),
          //         )
          //       : const SizedBox();
          // }),
          60.height,
        ],
      ),
    );
  }

  _buildCheckInOutCard(
    IconData iconData,
    String title,
    String time,
    String description,
  ) {
    return DecoratedBox(
      decoration: kBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.kFoundationPurple100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      iconData,
                      size: 20,
                    ),
                  ),
                ),
                10.width,
                Text(
                  title,
                  style: Get.textTheme.bodyLarge,
                )
              ],
            ),
            8.height,
            Text(
              time,
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              description,
              style: Get.textTheme.bodyLarge,
            )
          ],
        ),
      ),
    );
  }
}