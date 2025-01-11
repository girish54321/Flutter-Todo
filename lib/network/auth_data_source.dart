import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:reqres_app/network/ReqResClient.dart';
import 'package:reqres_app/network/dataModel/LoginSuccess.dart';
import 'package:reqres_app/network/model/result.dart';
import 'package:reqres_app/network/model/success_mutation.dart';
import 'package:reqres_app/network/model/user_proofile_response.dart';
import 'package:reqres_app/network/util/api_path.dart';
import 'package:reqres_app/network/util/helper.dart';
import 'package:reqres_app/network/util/request_type.dart';
import 'package:reqres_app/widget/DialogHelper.dart';

class AuthDataSource {
  ReqResClient client = ReqResClient(Client());

  Future<Result> userLogin(parameter) async {
    Result incomingData = Result.loading("Loading");
    try {
      final response = await client.request(
          requestType: RequestType.POST,
          path: APIPathHelper.getValue(APIPath.login),
          parameter: parameter);
      if (response.statusCode == 200 || response.statusCode == 201) {
        incomingData = Result<LoginSuccess>.success(
            LoginSuccess.fromJson(json.decode(response.body)));
        return incomingData;
      } else {
        Helper().createErrorModal(response);
        incomingData = Result.error(response.statusCode);
        return incomingData;
      }
    } catch (error) {
      incomingData = Result.error("Something went wrong!");
      DialogHelper.showErrorDialog(description: "Something went wrong!");
      return incomingData;
    }
  }

  Future<Result> getProfile() async {
    Result incomingData = Result.loading("Loading");
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: APIPathHelper.getValue(APIPath.profile),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        incomingData = Result<UserProofileResponse>.success(
            UserProofileResponse.fromJson(json.decode(response.body)));
        return incomingData;
      } else {
        Helper().createErrorModal(response);
        incomingData = Result.error(response.statusCode);
        return incomingData;
      }
    } catch (error) {
      incomingData = Result.error("Something went wrong!");
      DialogHelper.showErrorDialog(description: "Something went wrong!");
      return incomingData;
    }
  }

  Future<Result> updateProfile(parameter, File? file) async {
    Result incomingData = Result.loading("Loading");
    try {
      final response = await client.request(
          requestType: RequestType.POST,
          path: APIPathHelper.getValue(APIPath.updateProfile),
          file: file,
          parameter: parameter);
      if (response.statusCode == 200 || response.statusCode == 201) {
        incomingData = Result<SuccessMutation>.success(
            SuccessMutation.fromJson(json.decode(response.body)));
        return incomingData;
      } else {
        Helper().createErrorModal(response);
        incomingData = Result.error(response.statusCode);
        return incomingData;
      }
    } catch (error) {
      incomingData = Result.error("Something went wrong!");
      DialogHelper.showErrorDialog(description: "Something went wrong!");
      return incomingData;
    }
  }
}
