import 'dart:convert';
import 'package:doitall/models/user_model.dart';
import 'package:doitall/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Core/Animation/Fade_Animation.dart';
import '../pages/auth/email_verification_page.dart';

class EmailVerificationController {
  Future<void> emailverification(
      BuildContext context, dynamic id, emailverifiedat) async {
    if (emailverifiedat != null) {
      final url = Uri.parse('https://doitall.com.br/api/auth/showuser');
      final response = await http.post(
        url,
        body: {
          'id': id.toString(),
        },
      );

      final json = jsonDecode(response.body);
      final user = UserModel.fromJson(json);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: user),
        ),
      );
    }
    final url =
        Uri.parse('https://doitall.com.br/api/auth/resendEmailVerification');
    final response = await http.post(
      url,
      body: {
        'id': id.toString(),
      },
    );

    final json = jsonDecode(response.body);
    final emailVerifiedAt = json['user']['email_verified_at'];
    final user = UserModel.fromJson(json);

    final token = json['token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    if (emailVerifiedAt != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: user),
        ),
      );
    }
    if (emailVerifiedAt == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerificationPage(user: user),
        ),
      );
    }
  }
}
