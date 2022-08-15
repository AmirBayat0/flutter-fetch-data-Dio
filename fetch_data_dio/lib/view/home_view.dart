// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controller/home_controller.dart';
import '../utils/colors.dart';
import '../view/details_view.dart';
import '../utils/constants.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgColor,
      appBar: _buildAppBar(),
      floatingActionButton: Obx(() =>
          homeController.isInternetConnect.value ? _buildFAB() : Container()),
      body: Obx(
        () => SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: homeController.isInternetConnect.value
              ? homeController.isLoading.value
                  ? _buildLoading()
                  : _buildMainBody()
              : _buildNoInternetConnection(context),
        ),
      ),
    );
  }


  /// AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: MyColors.prColor,
      centerTitle: true,
      title: const Text("Restful API - Dio"),
    );
  }
  
  /// Floating Action Button
  FloatingActionButton _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        homeController.isListViewScrollToTheDown.value
            ? homeController.scrollListViewUpward()
            : homeController.scrollListViewDownward();
      },
      backgroundColor: MyColors.prColor,
      child: FaIcon(
        homeController.isListViewScrollToTheDown.value
            ? FontAwesomeIcons.arrowUp
            : FontAwesomeIcons.arrowDown,
      ),
    );
  }

  /// When Internet is't Okay, show thsi widget
  Center _buildNoInternetConnection(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: Lottie.asset('assets/b.json'),
          ),
          MaterialButton(
            onPressed: () => _materialOnTapButton(context),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: MyColors.prColor,
            child: const Text(
              "Try Again",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  /// Main Body
  RefreshIndicator _buildMainBody() {
    return RefreshIndicator(
      color: MyColors.prColor,
      onRefresh: () {
        return homeController.getPosts();
      },
      child: ScrollablePositionedList.builder(
        itemScrollController: homeController.itemController,
        physics: const BouncingScrollPhysics(),
        itemCount: homeController.posts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.to(
                DetailsView(index: index),
                transition: Transition.cupertino,
              );
            },
            child: Card(
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(homeController.posts[index].id.toString()),
                  ),
                ),
                title: Text(
                  homeController.posts[index].title,
                ),
                subtitle: Text(
                  homeController.posts[index].body,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Loading Widget
  Center _buildLoading() {
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Lottie.asset(
          'assets/a.json',
        ),
      ),
    );
  }

  /// onTap Func of "Try Again Button"
  void _materialOnTapButton(BuildContext context) async {
    if (await InternetConnectionChecker().hasConnection == true) {
      homeController.getPosts();
    } else {
      showCustomSnackBar(context);
    }
  }
}
