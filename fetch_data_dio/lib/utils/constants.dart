import 'package:flutter/cupertino.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

showCustomSnackBar(BuildContext context) => showTopSnackBar(
      context,
      const CustomSnackBar.error(
        message:
            "Something went wrong. Please check your Internet Connection and try again",
      ),
    );
