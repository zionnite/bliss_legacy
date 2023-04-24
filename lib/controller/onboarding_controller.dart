import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:oga_bliss/util/currency_formatter.dart';

import '../model/onboarding_model.dart';
import '../widget/onboarding_widget.dart';

class OnboardingCongroller extends GetxController {
  OnboardingCongroller get getXID => Get.find<OnboardingCongroller>();

  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    onboardingWidget(
      model: OnboardingModel(
        image_name: 'assets/images/coin_2.png',
        title: 'Bliss Legacy',
        sub_title:
            'We provide you simple and easy way to make you become a property owner',
        counter: '1/3',
        bgColor: Colors.blue.shade900,
      ),
    ),
    onboardingWidget(
      model: OnboardingModel(
        image_name: 'assets/images/subscription.png',
        title: 'Subscription',
        sub_title:
            'Start your journey of becoming a property owner with ${CurrencyFormatter.getCurrencyFormatter(amount: '1000')} daily',
        counter: '2/3',
        bgColor: Colors.blue.shade900,
      ),
    ),
    onboardingWidget(
      model: OnboardingModel(
        image_name: 'assets/images/earning.png',
        title: 'Earning',
        sub_title:
            'Bliss Legacy provide you simple way to earn on it\'s Platform',
        counter: '3/3',
        bgColor: Colors.blue.shade900,
      ),
    ),
  ];

  onPageChanged(int activePageIndex) => currentPage.value = activePageIndex;
  skip() => controller.jumpToPage(page: 2);

  animateToNextSlide() {
    int nextPage = controller.currentPage + 1;
    controller.animateToPage(page: nextPage);
  }
}
