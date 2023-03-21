import 'package:flutter/material.dart';
import 'package:doitall/controller/auth_controller.dart';
import '../../Core/Animation/Fade_Animation.dart';
import '../../Core/Colors/Hex_Color.dart';
import '../login_page.dart';

enum FormData { Email, Code, Password }

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({Key? key, required this.email}) : super(key: key);
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState(email: '');
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color disable = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  FormData? selected;
  final String email;
  final TextEditingController codeController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  _ResetPasswordPageState({required this.email});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Retorna false para impedir que a página seja fechada
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.1, 0.4, 0.7, 0.9],
              colors: [
                HexColor("#FFFFFF").withOpacity(0.8),
                HexColor("#FFFFFF"),
                HexColor("#FFFFFF"),
                HexColor("#FFFFFF")
              ],
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  HexColor("#fff").withOpacity(0.9), BlendMode.dstATop),
              image: const NetworkImage(
                'https://doitall.com.br/img/background.png',
              ),
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    color: const Color.fromARGB(255, 171, 211, 250)
                        .withOpacity(0.4),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeAnimation(
                            duration: Duration(milliseconds: 500),
                            delay: 0.2,
                            child: Image.network(
                              "https://doitall.com.br/img/logo.png",
                              width: 100,
                              height: 100,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                              duration: Duration(milliseconds: 500),
                              delay: 2,
                              child: Center(
                                child: Text(
                                  "Foi enviado um codigo no email: ${widget.email}  para aletação de senha   Confirme seu codigo e crie uma nova senha",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      letterSpacing: 1),
                                ),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            duration: Duration(milliseconds: 500),
                            delay: 3,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: selected == FormData.Code
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: codeController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Code;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: selected == FormData.Code
                                        ? enabledtxt
                                        : disable,
                                    size: 15,
                                  ),
                                  hintText: 'Confirme o codigo',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Code
                                          ? enabledtxt
                                          : disable,
                                      fontSize: 15),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Code
                                        ? enabledtxt
                                        : disable,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            duration: Duration(milliseconds: 500),
                            delay: 3,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: selected == FormData.Password
                                      ? enabled
                                      : backgroundColor),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: passwordController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Password;
                                  });
                                },
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.lock_open_outlined,
                                      color: selected == FormData.Password
                                          ? enabledtxt
                                          : disable,
                                      size: 15,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: ispasswordev
                                          ? Icon(
                                              Icons.visibility_off,
                                              color:
                                                  selected == FormData.Password
                                                      ? enabledtxt
                                                      : disable,
                                              size: 15,
                                            )
                                          : Icon(
                                              Icons.visibility,
                                              color:
                                                  selected == FormData.Password
                                                      ? enabledtxt
                                                      : disable,
                                              size: 15,
                                            ),
                                      onPressed: () => setState(
                                          () => ispasswordev = !ispasswordev),
                                    ),
                                    hintText: 'Senha',
                                    hintStyle: TextStyle(
                                        color: selected == FormData.Password
                                            ? enabledtxt
                                            : disable,
                                        fontSize: 15)),
                                obscureText: ispasswordev,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Password
                                        ? enabledtxt
                                        : disable,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            duration: Duration(milliseconds: 500),
                            delay: 1,
                            child: TextButton(
                                onPressed: () {
                                  AuthController authController =
                                      AuthController();
                                  authController.codevalidationPassword(
                                    context,
                                    widget.email,
                                    codeController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                                },
                                child: Text(
                                  "Alterar senha",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFF2697FF),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0, horizontal: 80),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)))),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                            duration: Duration(milliseconds: 500),
                            delay: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("Lembra a senha? ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        letterSpacing: 0.5,
                                        fontSize: 14)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return LoginPage();
                                    }));
                                  },
                                  child: Text("Fazer login",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                          fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
