import 'dart:convert';
import 'package:elloro/appconstant/app_color.dart';
import 'package:elloro/appconstant/custom_textstyle.dart';
import 'package:elloro/model/add_catalog_model.dart';
import 'package:elloro/model/catalog_detail_model.dart';
import 'package:elloro/model/cataloge_list_model.dart';
import 'package:elloro/model/commonmodel.dart';
import 'package:elloro/model/favrouiteList_model.dart';
import 'package:elloro/model/favrouite_audio_model.dart';
import 'package:elloro/model/feedback_model.dart';
import 'package:elloro/model/forgot_password_model.dart';
import 'package:elloro/model/get_user_data.dart';
import 'package:elloro/model/login_model.dart';
import 'package:elloro/model/purchase_list_model.dart';
import 'package:elloro/model/purchase_model.dart';
import 'package:elloro/model/rating_model.dart';
import 'package:elloro/model/recent_audio_model.dart';
import 'package:elloro/model/recommendation_list_model.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:elloro/model/verify_user_model.dart';
import 'package:elloro/provider/provider.dart';
import 'package:elloro/screen/bottom_navigation/bottom_navigation.dart';
import 'package:elloro/screen/login_screen/login_screen.dart';
import 'package:elloro/screen/otp_screen/otp_screen.dart';
import 'package:elloro/screen/thank_you_screen/thank_you_screen.dart';
import 'package:elloro/services/api_endpoints.dart';
import 'package:elloro/widget/custom_snackbar.dart';
import 'package:elloro/widget/texteditingcontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_response_model.dart';
import 'dio_client.dart';
import 'exception.dart';
import 'function.dart';

class ApiService {
  ApiClient apiClient = ApiClient();

  Future userRegister(
      {required BuildContext context,
      required FormData data,
      Functions? functions}) async {
    try {
      ApiResponseModel? apiResponse =
          await apiClient.post(EndPoints.register, data: data);

      if (apiResponse != null) {
        if (apiResponse.success == 1) {
          UserRegisterModel userRegisterModel =
              UserRegisterModel.fromJson(apiResponse.response);

          await Provider.of<UserProvider>(context, listen: false)
              .setUser(currentUser: userRegisterModel);

          //SharedPreferences preferences = await SharedPreferences.getInstance();
          // preferences.setString("user", jsonEncode(userRegisterModel.toJson()));

          Functions.toast(apiResponse.message);

          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtpScreen(
                          userid: userRegisterModel.userId.toString())))
              .then((value) {
            MyTextController.passwordController.clear();
            MyTextController.emailController.clear();
            MyTextController.referralCodeController.clear();
            MyTextController.nameController.clear();
          });

          // Get.to(() => OtpScreen(userid: userRegisterModel.userId.toString())).then((value) {
          //   MyTextController.passwordController.clear();
          //   MyTextController.emailController.clear();
          //   MyTextController.referralCodeController.clear();
          //   MyTextController.nameController.clear();
          // });

          return userRegisterModel;
        } else {
          Functions.toast(apiResponse.message);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future verifyUser(
      {required BuildContext context, required FormData data}) async {
    try {
      ApiResponseModel? apiResponse =
          await apiClient.post(EndPoints.verifyUser, data: data);

      if (apiResponse != null) {
        if (apiResponse.success == 1) {
          VerifyUser verifyUser = VerifyUser.fromJson(apiResponse.response);

          UserRegisterModel userRegisterModel =
              UserRegisterModel.fromJson(apiResponse.response);

          (apiResponse.response);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("user", jsonEncode(verifyUser.toJson()));

          await Provider.of<UserProvider>(context, listen: false)
              .setUser(currentUser: userRegisterModel);

          (verifyUser.toJson().toString());
          Functions.toast(apiResponse.message);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ThankYouScreen()),
              (route) => false);

          // Get.to(() => ThankYouScreen());
          return verifyUser;
        } else {
          Functions.toast(apiResponse.message);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future loginUser(
      {required BuildContext context, required FormData data}) async {
    try {
      ApiResponseModel? apiResponse = await apiClient.post(
        EndPoints.loginUser,
        data: data,
      );

      if (apiResponse != null) {
        if (apiResponse.success == 1) {
          LoginModel loginModel = LoginModel.fromJson(apiResponse.response);

          UserRegisterModel userRegisterModel =
              UserRegisterModel.fromJson(apiResponse.response);

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("user", jsonEncode(loginModel.toJson()));

          if (apiResponse.message == "User Account is not Verified") {
            Get.to(() => OtpScreen(userid: loginModel.userId.toString()));
          }
          //LoginModel loginModel = LoginModel.fromJson(apiResponse.response);
          //await Provider.of<UserProvider>(context)
          //.setUser(currentUser: loginModel);

          else {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString("user", jsonEncode(loginModel.toJson()));

            await Provider.of<UserProvider>(context, listen: false)
                .setUser(currentUser: userRegisterModel);
            // (loginModel);
            Functions.toast(apiResponse.message);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomNavigation()),
                (route) => false);
            //Get.to(() => BottomNavigation());

            return loginModel;
          }
        } else {
          Functions.toast(apiResponse.message);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future forgotPassword(
      {required BuildContext context, required FormData data}) async {
    try {
      ApiResponseModel? apiResponse =
          await apiClient.post(EndPoints.forgotPassword, data: data);

      if (apiResponse != null) {
        if (apiResponse.success == 1) {
          // Navigator.pop(context);
          ForgotPasswordModel forgotPasswordModel =
              ForgotPasswordModel.fromJson(apiResponse.response);

          Functions.toast(apiResponse.message);

          Get.to(() => LoginScreen());
          return forgotPasswordModel;
        } else {
          Functions.toast(apiResponse.message);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future changePassword(
      {required BuildContext context,
      required FormData data,
      required UserRegisterModel loginModel}) async {
    try {
      ApiResponseModel? apiResponse = await apiClient.post(
          EndPoints.changePassword,
          data: data,
          options: Options(
              headers: {"authorization": "Bearer ${loginModel.apiToken}"}));

      if (apiResponse!.statusCode == 401) {
        Get.to(() => LoginScreen());
        Functions.toast('Session expired please login');
      }

      if (apiResponse != null) {
        if (apiResponse.success == 1 && apiResponse.success != null) {
          Functions.toast(apiResponse.message);

          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
          // return forgotPasswordModel;
        } else {
          Functions.toast(apiResponse.message);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future updateProfile(
      {required BuildContext context,
      required FormData data,
      required UserRegisterModel userRegisterModel}) async {
    try {
      ApiResponseModel? apiResponse = await apiClient.post(
          EndPoints.updateProfile,
          data: data,
          options: Options(headers: {
            "authorization": "Bearer ${userRegisterModel.apiToken}"
          }));

      if (apiResponse != null) {
        if (apiResponse.statusCode == 200) {
          UserRegisterModel userRegisterModel =
              UserRegisterModel.fromJson(apiResponse.response);

          await Provider.of<UserProvider>(context, listen: false)
              .setUser(currentUser: userRegisterModel);

          ("hello" + userRegisterModel.toJson().toString());

          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("user", jsonEncode(userRegisterModel.toJson()));

          //  Functions.toast(apiResponse.message);

          Get.back();
          return userRegisterModel;
        } else {
          Functions.toast(apiResponse.message);
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future getUserData(
      {required BuildContext context,
      //required FormData data,
      required UserRegisterModel userRegisterModel}) async {
    try {
      Response response = await apiClient.dio.post(EndPoints.getUserData,
          //data: data,
          options: Options(headers: {
            "authorization": "Bearer ${userRegisterModel.apiToken}"
          }));

      GetUserData getUserData = GetUserData.fromJson(response.data);

      if (response.data != null) {
        if (response.statusCode == 200) {
          if (getUserData.success == 0 &&
              getUserData.message == "User does not exist") {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove("user");

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          }

          return getUserData;
        }
      }
    } on DioError catch (e) {
      ("1-9-22");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future catalogeList(
      {required BuildContext context,
      required UserRegisterModel userRegisterModel,
      String? textEditingController,
      FormData? data}) async {
    try {
      if (textEditingController != "") {
        Response response = await apiClient.dio.post(EndPoints.catalogueList,
            data: data,
            options: Options(
              headers: {
                "authorization": "Bearer ${userRegisterModel.apiToken}"
              },
            ));

        CataLogList catalogeList = CataLogList.fromJson(response.data);

        if (response.statusCode == 200) {
          if (catalogeList.success == 0 &&
              catalogeList.message == "User does not exist") {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove("user");

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          }

          return catalogeList;
        }
      } else {
        Response response = await apiClient.dio.post(EndPoints.catalogueList,
            options: Options(headers: {
              "authorization": "Bearer ${userRegisterModel.apiToken}"
            }));

        CataLogList catalogeList = CataLogList.fromJson(response.data);

        if (response.data != null) {
          //(response.statusCode);
          if (response.statusCode == 200) {
            // (response.data);

            //   ("hello kem cho");
            if (catalogeList.success == 0 &&
                catalogeList.message == "User does not exist") {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.remove("user");

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false);
            }

            return catalogeList;
          }
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future searchcatalog(
      {required BuildContext context,
      required UserRegisterModel userRegisterModel,
      FormData? data,
      String? textEditingController}) async {
    try {
      Response response = await apiClient.dio.post(EndPoints.catalogueList,
          data: data,
          options: Options(
            headers: {"authorization": "Bearer ${userRegisterModel.apiToken}"},
          ));
      CataLogList catalogeList = CataLogList.fromJson(response.data);

      if (response.statusCode == 200) {
        (response.data);
        return catalogeList;
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future<int?> purchase(
      {required BuildContext context,
      required FormData data,
      required UserRegisterModel userRegisterModel,
      CataLogList? cataLogListData}) async {
    try {
      Response response = await apiClient.dio.post(EndPoints.audioPurchase,
          data: data,
          options: Options(headers: {
            "authorization": "Bearer ${userRegisterModel.apiToken}"
          }));

      if (response.data != null) {
        if (response.statusCode == 200) {
          Purchase purchase = Purchase.fromJson(response.data);

          (response.data);

          if (purchase.success == 1) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColor.black,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Text(
                  purchase.message.toString(),
                  style: CustomTextStyle.body1
                      .copyWith(color: AppColor.primarycolor),
                )));
            return 1;
          } else {
            //   Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColor.black,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Text(
                  purchase.message.toString(),
                  style: CustomTextStyle.body1
                      .copyWith(color: AppColor.primarycolor),
                )));

            return 0;
          }
        } else {
          return 0;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return 0;
    }
  }

  Future purchaseCatalogList({
    required BuildContext context,
    required UserRegisterModel userRegisterModel,
    String? controller,
    FormData? data,
  }) async {
    try {
      if (controller != "") {
        Response response = await apiClient.dio.post(EndPoints.purchaseList,
            data: data,
            options: Options(headers: {
              "authorization": "Bearer ${userRegisterModel.apiToken}"
            }));

        PurchaseList purchaseList = PurchaseList.fromJson(response.data);

        if (response.data != null) {
          if (response.statusCode == 200) {
            return purchaseList;
          }
        }
      } else {
        Response response = await apiClient.dio.post(EndPoints.purchaseList,
            data: data,
            options: Options(headers: {
              "authorization": "Bearer ${userRegisterModel.apiToken}"
            }));

        PurchaseList purchaseList = PurchaseList.fromJson(response.data);

        if (response.data != null) {
          if (response.statusCode == 200) {
            (response.data);

            // if (purchaseList.success == 0 &&
            //     purchaseList.message == "User does not exist") {
            //   SharedPreferences preferences =
            //       await SharedPreferences.getInstance();
            //   preferences.remove("user");
            //
            //   Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(builder: (context) => LoginScreen()),
            //       (route) => false);
            // }

            return purchaseList;
          }
        }
      }
    } on DioError catch (e) {
      ("3-9-22");
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future favouriteAudio(
      {required BuildContext context,
      required UserRegisterModel userRegisterModel,
      required FormData data}) async {
    try {
      Response response = await apiClient.dio.post(EndPoints.favouriteAudio,
          options: Options(headers: {
            "authorization": "Bearer ${userRegisterModel.apiToken}"
          }),
          data: data);

      if (response.data != null) {
        if (response.statusCode == 200) {
          (response.data);

          FavouriteAudio favouriteAudio =
              FavouriteAudio.fromJson(response.data);
          if (favouriteAudio.success == 0 &&
              favouriteAudio.message == "User does not exist") {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove("user");

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          }

          return favouriteAudio;
        }
      }
    } on DioError catch (e) {
      ("4-9-22");

      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future favouriteAudioList({
    required BuildContext context,
    required UserRegisterModel userRegisterModel,
  }) async {
    try {
      Response response = await apiClient.dio.post(
        EndPoints.favouriteList,
        options: Options(
            headers: {"authorization": "Bearer ${userRegisterModel.apiToken}"}),
      );

      if (response.data != null) {
        if (response.statusCode == 200) {
          (response.data.toString());

          FavrouiteList favrouiteList = FavrouiteList.fromJson(response.data);

          // if (favrouiteList.success == 0 &&
          //     favrouiteList.message == "User does not exist") {
          //   SharedPreferences preferences =
          //       await SharedPreferences.getInstance();
          //   preferences.remove("user");
          //
          //   Navigator.pushAndRemoveUntil(
          //       context,
          //       MaterialPageRoute(builder: (context) => LoginScreen()),
          //       (route) => false);
          // }

          return favrouiteList;
        }
      }
    } on DioError catch (e) {
      ("5 -9-22");

      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future catalogRating({
    required BuildContext context,
    required UserRegisterModel userRegisterModel,
    required FormData data,
  }) async {
    try {
      Response response = await apiClient.dio.post(
        EndPoints.rating,
        data: data,
        options: Options(
            headers: {"authorization": "Bearer ${userRegisterModel.apiToken}"}),
      );
      if (response.data != null) {
        if (response.statusCode == 200) {
          (response.data);

          Rating ratingdata = Rating.fromJson(response.data);

          if (ratingdata.success == 1) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColor.black,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Text(
                  ratingdata.message.toString(),
                  style: CustomTextStyle.body1
                      .copyWith(color: AppColor.primarycolor),
                )));
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: AppColor.black,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Text(
                  ratingdata.message.toString(),
                  style: CustomTextStyle.body1
                      .copyWith(color: AppColor.primarycolor),
                )));
          }

          return ratingdata;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future catalogDetails(
      {required BuildContext context,
      required UserRegisterModel userRegisterModel,
      required FormData data}) async {
    try {
      Response response = await apiClient.dio.post(
        EndPoints.catalogueDetails,
        data: data,
        options: Options(
            headers: {"authorization": "Bearer ${userRegisterModel.apiToken}"}),
      );

      if (response.data != null) {
        if (response.statusCode == 200) {
          (response.data);

          CatalogDetail catalogDetail = CatalogDetail.fromJson(response.data);

          if (catalogDetail.success == 1) {
            (catalogDetail.data);
          } else {
            (catalogDetail.data);
          }

          return catalogDetail;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future recentAudio({
    required BuildContext context,
    required UserRegisterModel userRegisterModel,
  }) async {
    try {
      Response response = await apiClient.dio.post(
        EndPoints.recentCatalog,
        options: Options(
            headers: {"authorization": "Bearer ${userRegisterModel.apiToken}"}),
      );

      if (response.data != null) {
        if (response.statusCode == 200) {
          (response.data);

          RecentAudio recentAudio = RecentAudio.fromJson(response.data);

          return recentAudio;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future audioFeedback({
    required BuildContext context,
    required UserRegisterModel userRegisterModel,
    required FormData data,
  }) async {
    try {
      Response response = await apiClient.dio.post(
        EndPoints.feedback,
        data: data,
        options: Options(
            headers: {"authorization": "Bearer ${userRegisterModel.apiToken}"}),
      );

      if (response.data != null) {
        if (response.statusCode == 200) {
          (response.data);

          FeedbackData feedback = FeedbackData.fromJson(response.data);

          if (feedback.success == 1) {
            GlobalSnackBar.show(context, feedback.message.toString());
            (feedback.data);
          } else {
            GlobalSnackBar.show(context, feedback.message.toString());
            (feedback.data);
          }

          return feedback;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future addCatalogueDownload({
    required BuildContext context,
    required UserRegisterModel userRegisterModel,
    required FormData data,
  }) async {
    try {
      Response response = await apiClient.dio.post(
        EndPoints.addCatalogueDownload,
        data: data,
        options: Options(
            headers: {"authorization": "Bearer ${userRegisterModel.apiToken}"}),
      );

      if (response.data != null) {
        if (response.statusCode == 200) {
          (response.data);

          AddCatalogDownload addCatalogDownload =
              AddCatalogDownload.fromJson(response.data);

          if (addCatalogDownload.success == 1) {
            // GlobalSnackBar.show(context, addCatalogDownload.message.toString());
            (addCatalogDownload.data);
          } else {
            GlobalSnackBar.show(context, addCatalogDownload.message.toString());
            (addCatalogDownload.data);
          }
          return addCatalogDownload;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future purchaseDeleteAudio({
    required BuildContext context,
    required UserRegisterModel userRegisterModel,
    required FormData data,
  }) async {
    try {
      Response response = await apiClient.dio.post(
        EndPoints.purchaseAudioDelete,
        data: data,
        options: Options(
            headers: {"authorization": "Bearer ${userRegisterModel.apiToken}"}),
      );

      CommonModel commonModel = CommonModel.fromJson(response.data);

      if (response.data != null) {
        if (response.statusCode == 200) {
          (response.data);

          if (commonModel.success == 1) {
            (response.data);
          } else {
            (response.data);
          }
          return commonModel;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future fetchRecommendationList({
    required BuildContext context,
    required UserRegisterModel userRegisterModel,
  }) async {
    try {
      Response response = await apiClient.dio.post(
        EndPoints.recommendationList,
        options: Options(
            headers: {"authorization": "Bearer ${userRegisterModel.apiToken}"}),
      );

      if (response.data != null) {
        if (response.statusCode == 200) {
          RecommendationList recommendationList =
              RecommendationList.fromJson(response.data);

          return recommendationList;
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future resendOtp(
      {required BuildContext context, required FormData data}) async {
    try {
      Response response =
          await apiClient.dio.post(EndPoints.resendOtp, data: data);
      CommonModel commonModel = CommonModel.fromJson(response.data);

      if (response.data != null) {
        if (response.statusCode == 200) {
          if (commonModel.success == 1) {
            GlobalSnackBar.show(context, commonModel.message.toString());
          } else {
            GlobalSnackBar.show(context, commonModel.message.toString());
          }
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      return;
    }
  }

  Future tokenPurchase({
    required BuildContext context,
    required FormData data,
    required UserRegisterModel userRegisterModel,
  }) async {
    try {
      print(userRegisterModel.apiToken);
      Response response = await apiClient.dio.post(EndPoints.tokenPurchase,
          data: data,
          options: Options(headers: {
            "authorization": "Bearer ${userRegisterModel.apiToken}"
          }));

      print(response.data);
      CommonModel commonModel = CommonModel.fromJson(response.data);

      if (response.data != null) {
        if (commonModel.success == 1) {
          GlobalSnackBar.show(context, commonModel.message.toString());
        } else {
          GlobalSnackBar.show(context, commonModel.message.toString());
        }
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      Functions.toast(errorMessage);
      print(e);
      return;
    }
  }
}
