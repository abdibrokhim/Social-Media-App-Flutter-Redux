import 'package:socialmediaapp/components/category/category_model.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socialmediaapp/utils/env.dart';


class CategoryService {
  static Future<List<Category>> getCategoryList() async {
    try {
      final response = await http.get(
        Uri.parse('${Environments.backendServiceBaseUrl}/api/categories/live'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        AppLog.log().i('CategoryService categories: $data');
        final List<Category> categoryList = (data).map((e) => Category.fromJson(e)).toList();
        return categoryList;
      } else {
        return Future.error('Failed to get all categoryList');
      }
    } catch (e) {
      AppLog.log().e("error while fetching all categoryList: $e");
      return Future.error('Failed to get all categoryList');
    }
  }
}