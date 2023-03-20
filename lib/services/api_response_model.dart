import 'package:fluttertoast/fluttertoast.dart';

class ApiResponseModel<T> {
  int success;
  String message;
  T response;
  int statusCode;

  ApiResponseModel({
    this.success = 0,
    required this.message,
    required this.response,
    required this.statusCode,
  });

  factory ApiResponseModel.fromJson(
      Map<String, dynamic> parsedData, int statusCode) {
    return ApiResponseModel(
      success: parsedData['success'] ?? 0,
      message: parsedData['message'] ?? '',
      response: parsedData['data'] != null ? parsedData['data'] : "",
      statusCode: statusCode,
    );
  }

  static errorShow(dynamic apiResponse) {
    if (apiResponse["error"] != null) {
      Fluttertoast.showToast(msg: apiResponse["error"]);
    } else if (apiResponse["message"] != null) {
      Fluttertoast.showToast(msg: apiResponse["message"]);
    } else if (apiResponse["msg"] != null) {
      Fluttertoast.showToast(msg: apiResponse["msg"]);
    } else if (apiResponse["errors"] != null) {
      Fluttertoast.showToast(msg: apiResponse["errors"].toString());
    } else if (apiResponse.reasonPhrase != null) {
      Fluttertoast.showToast(msg: apiResponse.reasonPhrase);
    }
  }
}
//
// class ResponseException {
//   String id;
//   String exceptionMessage;
//   String details;
//   String referenceErrorCode;
//   String referenceDocumentLink;
//   List<String> validationErrors;
//   bool hasValidationErrors;
//
//   ResponseException(
//       {this.id,
//       this.exceptionMessage,
//       this.details,
//       this.referenceErrorCode,
//       this.referenceDocumentLink,
//       this.validationErrors,
//       this.hasValidationErrors});
//
//   ResponseException.fromJson(Map<String, dynamic> json) {
//     id = json['$id'];
//     exceptionMessage = json['ExceptionMessage'];
//     details = json['Details'];
//     referenceErrorCode = json['ReferenceErrorCode'];
//     referenceDocumentLink = json['ReferenceDocumentLink'];
//     validationErrors = json['ValidationErrors'].cast<String>();
//     hasValidationErrors = json['HasValidationErrors'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['$id'] = this.id;
//     data['ExceptionMessage'] = this.exceptionMessage;
//     data['Details'] = this.details;
//     data['ReferenceErrorCode'] = this.referenceErrorCode;
//     data['ReferenceDocumentLink'] = this.referenceDocumentLink;
//     data['ValidationErrors'] = this.validationErrors;
//     data['HasValidationErrors'] = this.hasValidationErrors;
//     return data;
//   }
// }
