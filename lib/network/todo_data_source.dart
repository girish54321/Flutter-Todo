import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:reqres_app/network/ReqResClient.dart';
import 'package:reqres_app/network/model/result.dart';
import 'package:reqres_app/network/model/success_mutation.dart';
import 'package:reqres_app/network/model/user_todo_response.dart';
import 'package:reqres_app/network/util/api_path.dart';
import 'package:reqres_app/network/util/helper.dart';
import 'package:reqres_app/network/util/request_type.dart';
import 'package:reqres_app/widget/DialogHelper.dart';

class TodoDataSource {
  ReqResClient client = ReqResClient(Client());

  Future<Result> getUserToDo(parameter) async {
    Result incomingData = Result.loading("Loading");
    try {
      final response = await client.request(
          requestType: RequestType.GET,
          path: TodoApiPathHelper.getValue(TodoAPIPath.getTodo),
          params: parameter);
      if (response.statusCode == 200 || response.statusCode == 201) {
        incomingData = Result<UserTodoResponse>.success(
            UserTodoResponse.fromJson(json.decode(response.body)));
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

  Future<Result> deleteTodo(id) async {
    Result incomingData = Result.loading("Loading");
    try {
      final response = await client.request(
        requestType: RequestType.DELETE,
        path: TodoApiPathHelper.getValue(TodoAPIPath.deletetodo) + id,
      );
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

  Future<Result> createTodo(parameter, File? file) async {
    Result incomingData = Result.loading("Loading");
    try {
      final response = await client.request(
          requestType: RequestType.POST,
          path: TodoApiPathHelper.getValue(TodoAPIPath.createTodo),
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

  Future<Result> getTodoDetails(id) async {
    Result incomingData = Result.loading("Loading");
    try {
      final response = await client.request(
        requestType: RequestType.GET,
        path: TodoApiPathHelper.getValue(TodoAPIPath.getTodoInfo) + id,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        incomingData = Result<TodoDetailsModal>.success(
            TodoDetailsModal.fromJson(json.decode(response.body)));
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

  Future<Result> updateTodo(parameter) async {
    Result incomingData = Result.loading("Loading");
    try {
      final response = await client.request(
          requestType: RequestType.POST,
          path: TodoApiPathHelper.getValue(TodoAPIPath.updatetodo),
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
