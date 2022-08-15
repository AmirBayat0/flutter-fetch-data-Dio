import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../model/post_model.dart';
import '../services/dio_service.dart';

class HomeController extends GetxController {
  RxList<PostModel> posts = RxList();
  RxBool isLoading = true.obs;
  RxBool isListViewScrollToTheDown = false.obs;
  RxBool isInternetConnect = true.obs;

  var url = "https://jsonplaceholder.typicode.com/posts";
  var itemController = ItemScrollController();

  /// For Chcecking Internet Conection
  isInternrtConnect() async {
    isInternetConnect.value  = await InternetConnectionChecker().hasConnection;
     
  }

  /// Callin Api and getting data From server
  getPosts() async {
    isInternrtConnect();
    isLoading.value = true;
    var response = await DioService().getMethod(url);

    if (response.statusCode == 200) {
      response.data.forEach(
        (element) {
          posts.add(PostModel.fromJson(element));
        },
      );
      isLoading.value = false;
    }
  }

  /// Scroll Listview To Down
  scrollListViewDownward() {
    itemController.scrollTo(
        index: posts.length - 4,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn);
    isListViewScrollToTheDown.value = true;
  }

  /// Scroll Listview To Up
  scrollListViewUpward() {
    itemController.scrollTo(
        index: 0,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn);
    isListViewScrollToTheDown.value = false;
  }

  @override
  void onInit() {
    getPosts();
    isInternrtConnect();
    super.onInit();
  }
}
