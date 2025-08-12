import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rick_and_morty/theme/app_images.dart';

import '../theme/app_colors.dart';

PreferredSizeWidget appBarComponent(
  BuildContext context, {
  bool isSecondPage = false,
}) {
  return AppBar(
    toolbarHeight: kToolbarHeight * 2.2 + MediaQuery.of(context).padding.top,
    backgroundColor: AppColors.appBarColor,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    leading: Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Align(
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: () {
            if (isSecondPage) {
              Navigator.pop(context);
            }
          },
          child: Icon(
            isSecondPage ? Icons.arrow_back : Icons.menu,
            color: AppColors.white,
            size: 22,
          ),
        ),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(top: 17.5),
        child: Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(right: 16),
          child: Icon(
            Icons.account_circle_sharp,
            color: AppColors.white,
            size: 31,
          ),
        ),
      ),
    ],
    flexibleSpace: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 17.5),
        child: Column(
          children: [
            Image.asset(AppImages.logo),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "RICK AND MORTY API",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.393,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
