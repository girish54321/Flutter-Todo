enum APIPath { login, users, signUp, profile, updateProfile }

enum TodoAPIPath { getTodo, deletetodo, createTodo, updatetodo, getTodoInfo }

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.login:
        return "auth/login";
      case APIPath.signUp:
        return "auth/signup";
      case APIPath.users:
        return "/users";
      case APIPath.updateProfile:
        return "profile/update-profile";
      case APIPath.profile:
        return "/profile/user-profile";
      default:
        return "";
    }
  }
}

class TodoApiPathHelper {
  static String getValue(TodoAPIPath path) {
    switch (path) {
      case TodoAPIPath.getTodo:
        return "/todo/getalltodos";
      case TodoAPIPath.deletetodo:
        return "todo/deletetodo/";
      case TodoAPIPath.createTodo:
        return "todo/addtodo";
      case TodoAPIPath.updatetodo:
        return "todo/updatetodo";
      case TodoAPIPath.getTodoInfo:
        return "/todo/gettodo/";
      default:
        return "";
    }
  }
}
