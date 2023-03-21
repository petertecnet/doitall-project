import 'package:flutter/material.dart';
import 'package:doitall/pages/auth/reset_password_page.dart';
import 'package:doitall/pages/company/company_edit_page.dart';
import 'package:doitall/pages/company/products/new_prdocut_page.dart';
import 'package:doitall/pages/company/products/product_page.dart';
import 'package:doitall/pages/login_page.dart';
import 'package:doitall/pages/home_page.dart';
import 'package:doitall/pages/user/user_edit_page.dart';
import 'package:doitall/pages/auth/email_verification_page.dart';
import 'package:doitall/pages/auth/forgotpassword_page.dart';
import 'package:doitall/pages/auth/new_register_page.dart';
import 'app_controller.dart';
import 'models/company_model.dart';
import 'models/user_model.dart';

class AppWidget extends StatefulWidget {
  final double initialValue;

  const AppWidget({Key? key, required this.initialValue}) : super(key: key);

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late CompanyModel company;
  late UserModel user;

  @override
  void initState() {
    super.initState();
    // Cria uma nova instância de Company com o valor inicial.
    company = CompanyModel();
    user = UserModel();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: AppController.instance.isDarkTheme
                ? Brightness.dark
                : Brightness.light,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/homepage': (context) => HomePage(
                  user: user,
                ),
            '/newregisterpage': (context) => NewRegisterPage(),
            '/forgotpasswordpage': (context) => ForgotpasswordPage(),
            '/ResetPasswordPage': (context) => ResetPasswordPage(email: ''),
            '/emailverificationpage': (context) => EmailVerificationPage(
                  user: user,
                ),
            '/usereditpage': (context) => UserEditPage(
                  user: user,
                ),
            '/companyeditpage': (context) =>
                CompanyEditPage(user: user, company: company),
            '/product': (context) => ProductPage(
                user: user,
                products: [], // passar a lista de produtos
                companyid: company.id!), // passar a empresa

            '/product/new': (context) => NewProductPage(
                  companyid: company.id!,
                  userid: user.id!,
                  user: user,
                ),
          },
        );
      },
    );
  }
}
