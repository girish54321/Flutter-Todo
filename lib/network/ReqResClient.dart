import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:reqres_app/AppConst/AppConst.dart';
import 'util/nothing.dart';
import 'package:http/http.dart' as http;
import 'util/request_type.dart';
import 'util/request_type_exception.dart';

class ReqResClient {
  static const String _baseUrl = "http://192.168.0.108:2000/api/v1";
  final Client _client;
  GetStorage box = GetStorage();

  ReqResClient(this._client);

  Future<Response> request(
      {required RequestType requestType,
      required String path,
      Map<String, String>? params,
      File? file,
      dynamic parameter = Nothing}) async {
    //* Check for the Token
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (box.hasData(JWT_KEY)) 'Authorization': 'Bearer ${box.read(JWT_KEY)}',
    };
    switch (requestType) {
      case RequestType.GET:
        var uri = _baseUrl +
            path +
            ((params != null) ? this.queryParameters(params) : "");
        print("GET URL: " + uri);
        return _client.get(
          Uri.parse(uri),
          headers: headers,
        );
      case RequestType.POST:
        print("POST URL: " + "$_baseUrl/$path");
        if (file != null) {
          return createUploadFile("$_baseUrl/$path", file, parameter,
              'Bearer ${box.read(JWT_KEY)}');
        } else {
          return _client.post(Uri.parse("$_baseUrl/$path"),
              headers: headers, body: json.encode(parameter));
        }
      case RequestType.DELETE:
        print("DELETE URL: " + "$_baseUrl/$path");
        return _client.delete(
          Uri.parse("$_baseUrl/$path"),
          headers: headers,
        );

      default:
        return throw RequestTypeNotFoundException(
            "The HTTP request mentioned is not found");
    }
  }

  Future<Response> createUploadFile(
      String url, File file, dynamic parameter, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(url),
    );
    Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'Authorization': 'Bearer ${box.read(JWT_KEY)}'
    };
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split('/').last,
      ),
    );
    request.fields.addAll(parameter);
    request.headers.addAll(headers);
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    return response;
  }

  String queryParameters(Map<String, String> params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }
}
