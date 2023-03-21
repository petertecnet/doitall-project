import 'dart:convert';
import 'dart:io';
import 'package:doitall/models/company_model.dart';
import 'package:doitall/models/user_model.dart';
import 'package:doitall/pages/company/new_company_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../pages/company/company_edit_page.dart';

class CompanyController {
  Future<void> updateImage(
      BuildContext context, UserModel user, File? _image) async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 3, 3),
          content: Text('Nenhuma foto selecionada'),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final url = Uri.parse('https://doitall.com.br/api/company/updateImage');
    var request = http.MultipartRequest('POST', url);
    request.fields['userid'] = user.id.toString();
    request.files.add(await http.MultipartFile.fromPath('logo', _image.path));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var json = jsonDecode(response.body);
    if (json['status'] == 200) {
      final user = UserModel.fromJson(json);
      final company = CompanyModel.fromJson(json);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(106, 85, 255, 0),
          content: Text(json['message']),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompanyEditPage(
            user: user,
            company: company,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 255, 3, 3),
          content: Text(json['message']),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> index(BuildContext context, int userid) async {
    final url = Uri.parse('https://doitall.com.br/api/company/show');
    final body = {
      'user_id': userid.toString(),
    };
    final response = await http.post(url, body: body);
    final jsonBody = response.body;

    if (response.statusCode != 200) {
      print('Error: ${response.statusCode} ${response.reasonPhrase}');
      print('Response body: $jsonBody');
      return;
    }

    try {
      final json = jsonDecode(jsonBody);
      if (json['status'] == 200) {
        final user = UserModel.fromJson(json);
        final company = CompanyModel.fromJson(json);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyEditPage(user: user, company: company),
          ),
        );
      } else {
        print('Error: ${json['status']} ${json['message']}');
      }
    } catch (e) {
      print('Error decoding JSON: $e');
      print('Response body: $jsonBody');
    }
  }

  Future<void> newCompany(
    BuildContext context,
    UserModel user,
    String cnpj,
  ) async {
    final url = Uri.parse('https://doitall.com.br/api/company/store');

    final response = await http.post(
      url,
      body: {
        'userid': user.id.toString(),
        'cnpj': cnpj,
      },
    );
    final json = jsonDecode(response.body);
    final message = json['message'];

    if (json['status'] == 200) {
      final user = UserModel.fromJson(json);
      final company = CompanyModel.fromJson(json);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CompanyEditPage(user: user, company: company),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color.fromARGB(255, 3, 37, 255),
          content: Center(child: Text(message)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Center(child: Text(message)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
