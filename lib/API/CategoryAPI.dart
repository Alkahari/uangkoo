import 'package:dio/dio.dart';
import 'package:uangkoo/API/Authentications.dart';

class CategoryAPI {
  var dio = Dio();
  void createCategory(int id, String name, int type) async {
    var email = await getEmail();
    var data = {
      "id":id,
      "email": email,
      "name": name,
      "type": type,
    };
    var result = await dio.post(
      "$BaseUrl/api/category/create_category.php",
      data: FormData.fromMap(data),
    );
    print(result.statusCode);
  }

  void deleteCategory(int id) async {
    var data = {
      "id":id,
    };
    var result = await dio.post(
      "$BaseUrl/api/category/delete_category.php",
      data: FormData.fromMap(data),
    );
    print(result.statusCode);

  }

  void updateCategory(int id, String text) async {
    var data = {
      "id":id,
      "name":text,
    };
    var result = await dio.post(
      "$BaseUrl/api/category/update_category.php",
      data: FormData.fromMap(data),
    );
    print(result.statusCode); 
  }
}
