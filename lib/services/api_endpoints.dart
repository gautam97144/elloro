import 'package:flutter/material.dart';

class EndPoints {
  static const String baseUrl = "http://3.66.82.143/api/";
  static var register = "new_registration";
  static var verifyUser = "verify-user";
  static var loginUser = "login";
  static var forgotPassword = "forgot-password";
  static var changePassword = "change-password";
  static var updateProfile = "update-profile";
  static var getUserData = "get-profile";
  static var catalogueList = "catalogue-list";
  static var purchaseList = "my-audio-purchase-list";
  static var audioPurchase = "audio-purchase";
  static var favouriteAudio = "favourite-unfavourite-audio";
  static var favouriteList = "favourite-list";
  static var rating = "add-catalogue-rating";
  static var catalogueDetails = "catalogue-details";
  static var recentCatalog = "recent-catalogue";
  static var feedback = "add-feedback";
  static var addCatalogueDownload = "add-catalogue-download";
  static var purchaseAudioDelete = "purchased-audio-delete";
  static var recommendationList = "recommendation-list";
  static var resendOtp = "resend-otp";
  static var tokenPurchase = "token-purchase";
}
