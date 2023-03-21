import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../pages/auth/email_verification_page.dart';
import 'dart:io';

import '../pages/user/user_edit_page.dart';

class UserController {
  Future<void> index(BuildContext context, UserModel user, String name,
      String email, String phone, String cpf) async {
    final url = Uri.parse('https://doitall.com.br/api/user/show');
    final body = {
      'id': user.id.toString(),
    };
    final response = await http.put(url, body: body);
    final json = jsonDecode(response.body);

    if (json['status'] == 200) {
      final user = UserModel.fromJson(json);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserEditPage(user: user),
        ),
      );
    }
  }

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

    final url = Uri.parse('https://doitall.com.br/api/user/updateImage');
    var request = http.MultipartRequest('POST', url);
    request.fields['id'] = user.id.toString();
    request.files.add(await http.MultipartFile.fromPath('avatar', _image.path));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var json = jsonDecode(response.body);
    if (json['status'] == 200) {
      final user = UserModel.fromJson(json);
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
          builder: (context) => UserEditPage(user: user),
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

  Future<void> updateUser(BuildContext context, UserModel user, String name,
      String email, String phone, String cpf) async {
    if (name.isEmpty) name = user.name!!;
    if (phone.isEmpty) phone = user.phone!;
    if (email.isEmpty) email = user.email!;
    if (cpf.isEmpty) cpf = user.cpf!;
    final url = Uri.parse('https://doitall.com.br/api/user/userupdate');
    final body = {
      'id': user.id.toString(),
      'name': name,
      'email': email,
      'phone': phone,
      'cpf': cpf
    };
    final response = await http.put(url, body: body);
    final json = jsonDecode(response.body);

    if (json['status'] == 200) {
      final user = UserModel.fromJson(json);
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
          builder: (context) => UserEditPage(user: user),
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

  Future<void> updateUseraddress(BuildContext context, UserModel user,
      String complement, String cep) async {
    if (complement.isEmpty) complement = user.complement!;
    if (cep.isEmpty) cep = user.cep!;
    final url = Uri.parse('https://doitall.com.br/api/user/updateAddress');
    final body = {
      'id': user.id.toString(),
      'complement': complement,
      'cep': cep
    };
    final response = await http.put(url, body: body);
    final json = jsonDecode(response.body);

    if (json['status'] == 200) {
      final user = UserModel.fromJson(json);
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
          builder: (context) => UserEditPage(user: user),
        ),
      );
    }
    if (json['status'] != 200) {
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

  Future<void> updatePassword(BuildContext context, UserModel user,
      String currentlyPassword, String newPassword) async {
    final name = user.name!;
    final phone = user.phone!;
    final email = user.email!;
    final cpf = user.cpf!;
    final url = Uri.parse('https://doitall.com.br/api/user/userupdate');
    final body = {
      'id': user.id.toString(),
      'currentlyPassword': currentlyPassword,
      'newPassword': newPassword,
      'name': name,
      'phone': phone,
      'email': email,
      'cpf': cpf
    };
    final response = await http.put(url, body: body);
    final json = jsonDecode(response.body);

    if (json['status'] == 200) {
      final user = UserModel.fromJson(json);
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
          builder: (context) => UserEditPage(user: user),
        ),
      );
    }
    if (json['status'] != 200) {
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

  Future<void> changeemailcodevalidation(
      BuildContext context, UserModel user, String code) async {
    final url =
        Uri.parse('https://doitall.com.br/api/user/changeemailcodevalidation');

    final body = {'id': user.id.toString(), 'verification_code': code};
    final response = await http.post(url, body: body);
    final json = jsonDecode(response.body);

    if (json['status'] == 200) {
      final user = UserModel.fromJson(json);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserEditPage(user: user),
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
    }

    if (json['status'] != 200) {
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
}
