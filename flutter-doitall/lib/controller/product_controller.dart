import 'dart:convert';
import 'dart:io';
import 'package:doitall/pages/company/products/new_prdocut_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../pages/company/products/product_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController {
  Future<void> create(BuildContext context, int companyid, int userid) async {
    try {
      final url = Uri.parse('https://doitall.com.br/api/user/show');
      final body = {
        'user_id': userid.toString(),
      };

      final response = await http.post(url, body: body);
      final json = jsonDecode(response.body);

      final user = UserModel.fromJson(json);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NewProductPage(companyid: companyid, userid: userid, user: user),
        ),
      );
    } catch (e) {
      print('Error decoding JSON: $e');
    }
  }

  Future<void> store(
      BuildContext context,
      String name,
      String type,
      String brand,
      String category,
      String description,
      double price,
      int companyid,
      int userid,
      File? _image) async {
    final url = Uri.parse('https://doitall.com.br/api/product/store');
    var request = http.MultipartRequest('POST', url);
    request.fields['user_id'] = userid.toString();
    request.fields['company_id'] = companyid.toString();
    request.fields['name'] = name;
    request.fields['type'] = type;
    request.fields['brand'] = brand;
    request.fields['category'] = category;
    request.fields['description'] = description;
    request.files
        .add(await http.MultipartFile.fromPath('img_product', _image!.path));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    var json = jsonDecode(response.body);

    if (json['status'] == 200) {
      final json = jsonDecode(response.body);
      final user = UserModel.fromJson(json);
      final List<dynamic> responseData = json['products'];
      final List<ProductModel> products =
          responseData.map((data) => ProductModel.fromJson(data)).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(
            products: products,
            user: user,
            companyid: companyid,
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(106, 85, 255, 0),
          content: Text(json['message']),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> getProductsByCompanyId(
      BuildContext context, int companyid, int userid) async {
    final url = Uri.parse('https://doitall.com.br/api/product/index');
    final body = {
      'company_id': companyid.toString(),
      'user_id': userid.toString(),
    };
    final response = await http.post(url, body: body);
    final json = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json['products'];
      final user = UserModel.fromJson(json);
      final List<ProductModel> products =
          responseData.map((data) => ProductModel.fromJson(data)).toList();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductPage(
                  user: user,
                  products: products,
                  companyid: companyid,
                )),
      );
    } else {
      throw Exception('Failed to load products');
    }
  }
}
