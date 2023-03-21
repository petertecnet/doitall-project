import 'package:doitall/pages/user/user_edit_page.dart';
import 'package:flutter/material.dart';
import '../Core/Animation/Fade_Animation.dart';
import '../Core/Colors/Hex_Color.dart';
import '../controller/user_controller.dart';
import '../models/user_model.dart';
import 'components/drawer_component.dart';

enum FormData { Name, Phone, Email, Cpf }

class HomePage extends StatefulWidget {
  final UserModel user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(user: user);
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color disable = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  FormData? selected;
  final UserModel user;

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController cpfController = new TextEditingController();

  _HomePageState({required this.user});

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Retorna false para impedir que a página seja fechada
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
        ),
        drawer: DrawerComponent(user: user),
        body: TabBarView(
          controller: _tabController,
          children: [
            Container(
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
                                delay: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return UserEditPage(
                                            user: user,
                                          );
                                        }));
                                      },
                                      child: Text("Meu dados",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                              fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                delay: 1,
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                  width: 300,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: selected == FormData.Name
                                        ? enabled
                                        : backgroundColor,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextField(
                                    controller: nameController,
                                    onTap: () {
                                      setState(() {
                                        selected = FormData.Name;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.title,
                                        color: selected == FormData.Name
                                            ? enabledtxt
                                            : disable,
                                        size: 20,
                                      ),
                                      hintText:
                                          '${user.name!.isEmpty ? "Sem nome cadastrado" : user.name}',
                                      hintStyle: TextStyle(
                                          color: selected == FormData.Name
                                              ? enabledtxt
                                              : disable,
                                          fontSize: 12),
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: selected == FormData.Name
                                            ? enabledtxt
                                            : disable,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                delay: 1,
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                  width: 300,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: selected == FormData.Email
                                        ? enabled
                                        : backgroundColor,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextField(
                                    controller: emailController,
                                    onTap: () {
                                      setState(() {
                                        selected = FormData.Email;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: selected == FormData.Email
                                            ? enabledtxt
                                            : disable,
                                        size: 20,
                                      ),
                                      hintText:
                                          '${user.email!.isEmpty ? "Sem nome cadastrado" : user.email}',
                                      hintStyle: TextStyle(
                                          color: selected == FormData.Email
                                              ? enabledtxt
                                              : disable,
                                          fontSize: 12),
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: selected == FormData.Email
                                            ? enabledtxt
                                            : disable,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                delay: 1,
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                  width: 300,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: selected == FormData.Phone
                                        ? enabled
                                        : backgroundColor,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextField(
                                    controller: phoneController,
                                    onTap: () {
                                      setState(() {
                                        selected = FormData.Phone;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: selected == FormData.Phone
                                            ? enabledtxt
                                            : disable,
                                        size: 20,
                                      ),
                                      hintText:
                                          '${user.phone!.isEmpty ? "Sem nome cadastrado" : user.phone}',
                                      hintStyle: TextStyle(
                                          color: selected == FormData.Phone
                                              ? enabledtxt
                                              : disable,
                                          fontSize: 12),
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: selected == FormData.Phone
                                            ? enabledtxt
                                            : disable,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                delay: 1,
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                  width: 300,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: selected == FormData.Cpf
                                        ? enabled
                                        : backgroundColor,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextField(
                                    controller: cpfController,
                                    onTap: () {
                                      setState(() {
                                        selected = FormData.Cpf;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.credit_card,
                                        color: selected == FormData.Cpf
                                            ? enabledtxt
                                            : disable,
                                        size: 20,
                                      ),
                                      hintText:
                                          '${user.cpf!.isEmpty ? "Sem CPF cadastrado" : user.cpf}',
                                      hintStyle: TextStyle(
                                          color: selected == FormData.Cpf
                                              ? enabledtxt
                                              : disable,
                                          fontSize: 12),
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: selected == FormData.Cpf
                                            ? enabledtxt
                                            : disable,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
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
                                      UserController userController =
                                          UserController();

                                      userController.updateUser(
                                          context,
                                          user,
                                          nameController.text,
                                          emailController.text,
                                          phoneController.text,
                                          cpfController.text);
                                    },
                                    child: Text(
                                      "Enviar",
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Text('Tab 2 content'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
