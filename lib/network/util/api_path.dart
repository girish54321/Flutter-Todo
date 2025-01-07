enum APIPath { login, users, signUp }

enum TodoAPIPath { getTodo, deletetodo, createTodo }

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.login:
        return "auth/login";
      case APIPath.signUp:
        return "auth/signup";
      case APIPath.users:
        return "/users";
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
      default:
        return "";
    }
  }
}
