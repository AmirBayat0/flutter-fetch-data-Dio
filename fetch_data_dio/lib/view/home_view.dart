import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controller/home_controller.dart';
import '../utils/colors.dart';
import '../view/details_view.dart';
import '../utils/constants.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey.shade900,
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: const Color.fromARGB(255, 22, 22, 22),
      items: const <Widget>[
        Icon(
          Icons.explore,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.search,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.settings,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          Icons.person,
          size: 30,
          color: Colors.white,
        ),
      ],
      onTap: (index) {},
    );
  }

  /// AppBar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: MyColors.prColor,
      centerTitle: true,
      title: const Text("GetX • Rest API • Dio"),
    );
  }

  /// Floating Action Button
  Widget _buildFAB() {
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

  /// When Internet is't Okay, show this widget
  Widget _buildNoInternetConnection(BuildContext context) {
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
            minWidth: 130,
            height: 45,
            onPressed: () => _materialOnTapButton(context),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: MyColors.prColor,
            child: const Text(
              "Try Again",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody() {
    return LiquidPullToRefresh(
      color: MyColors.prColor,
      showChildOpacityTransition: true,
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
              color: const Color.fromARGB(255, 9, 9, 9),
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      homeController.posts[index].id.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.white),
                    ),
                  ),
                ),
                title: Text(
                  homeController.posts[index].title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Colors.white),
                ),
                subtitle: Text(
                  homeController.posts[index].body,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    color: Colors.grey,
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
  Widget _buildLoading() {
    return const Center(
      child: SizedBox(
          width: 150,
          height: 150,
          child: Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
            ),
          )),
    );
  }

  /// onTap Func of "Try Again Button"
  void _materialOnTapButton(BuildContext context) async {
    if (await InternetConnectionChecker().hasConnection == true) {
      homeController.getPosts();
    } else {
      showCustomSnackBar(context: context);
    }
  }
}
