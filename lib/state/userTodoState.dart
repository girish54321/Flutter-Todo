import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:reqres_app/network/model/pagination.dart';
import 'package:reqres_app/network/model/result.dart';
import 'package:reqres_app/network/model/success_mutation.dart';
import 'package:reqres_app/network/model/user_todo_response.dart';
import 'package:reqres_app/network/todo_data_source.dart';
import 'package:reqres_app/network/util/helper.dart';

class UserTodoController extends GetxController {
  //* Reload userTodoList Controller
  final Rx<RefreshController> userTodoListController =
      RefreshController(initialRefresh: false).obs;
  final Rx<Pagination> pagination = Pagination(page: "1", size: "10").obs;

  Rx<UserTodoResponse> userTodo = UserTodoResponse().obs;
  Rx<UserTodoResponseTodo?> selectedTodo = UserTodoResponseTodo().obs;
  //TodoDataSource
  TodoDataSource apiResponse = TodoDataSource();

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    userTodoListController.value.dispose();
    super.onClose();
  }

  void updateSelectedTodo(parameter) {
    apiResponse.updateTodo(parameter).then((response) {
      if (response is SuccessState) {
        var res = response.value as SuccessMutation;
        if (res.success == true) {
          Helper().goBack();
          getSelctedTodoInfo();
        }
      } else {}
    }).catchError((error) {});
  }

  void getSelctedTodoInfo() {
    if (selectedTodo.value?.toDoId == null) {
      return;
    }
    apiResponse.getTodoDetails(selectedTodo.value!.toDoId!).then((response) {
      if (response is SuccessState) {
        var res = response.value as TodoDetailsModal;
        selectedTodo.value = res.todo;
        selectedTodo.refresh();
        getListOfTodo();
      } else {}
    }).catchError((error) {});
  }

  void selectTodo(UserTodoResponseTodo? todo) {
    selectedTodo.value = todo;
  }

  void loadTodoMore() {
    if (userTodo.value.totalPages! < int.parse(pagination.value.page ?? "")) {
      userTodoListController.value.footerMode?.value = LoadStatus.noMore;
      return;
    }
    pagination.value.page =
        (int.parse(pagination.value.page ?? "") + 1).toString();

    userTodoListController.value.footerMode?.value = LoadStatus.loading;
    apiResponse.getUserToDo(pagination.toJson()).then((response) {
      if (response is SuccessState) {
        var res = response.value as UserTodoResponse;
        userTodo.value.todo?.addAll(res.todo!);
        userTodo.refresh();
        userTodoListController.value.refreshCompleted();
      } else {
        userTodoListController.value.footerMode?.value = LoadStatus.failed;
      }
    }).catchError((error) {
      userTodoListController.value.footerMode?.value = LoadStatus.failed;
    });
    userTodoListController.value.footerMode?.value = LoadStatus.idle;
    userTodo.refresh();
  }

  void getListOfTodo() {
    pagination.value = Pagination(page: "1", size: "10");
    userTodoListController.value.footerMode?.value = LoadStatus.loading;
    apiResponse.getUserToDo(pagination.toJson()).then((response) {
      if (response is SuccessState) {
        var res = response.value as UserTodoResponse;
        userTodo.value = res;
        userTodo.refresh();
        userTodoListController.value.refreshCompleted();
      } else {
        userTodoListController.value.footerMode?.value = LoadStatus.failed;
      }
    }).catchError((error) {
      userTodoListController.value.footerMode?.value = LoadStatus.failed;
    });
    userTodoListController.value.footerMode?.value = LoadStatus.idle;
    userTodo.refresh();
  }

  void createTodo(parameter, file) {
    apiResponse.createTodo(parameter, file).then((response) {
      if (response is SuccessState) {
        var res = response.value as SuccessMutation;
        if (res.success == true) {
          getListOfTodo();
          Helper().goBack();
        }
      } else {}
    }).catchError((error) {});
    userTodo.refresh();
  }

  void deleteTodo(void Function(SuccessMutation) callback) {
    apiResponse.deleteTodo(selectedTodo.value?.toDoId).then((response) {
      if (response is SuccessState) {
        var res = response.value as SuccessMutation;
        if (res.success == true) {
          getListOfTodo();
          Helper().goBack();
          callback(res);
          selectedTodo.value = null;
          userTodo.refresh();
          selectedTodo.refresh();
        }
      } else {}
    }).catchError((error) {});
    userTodo.refresh();
  }
}
