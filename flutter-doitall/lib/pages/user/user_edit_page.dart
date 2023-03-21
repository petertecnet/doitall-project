import 'dart:io';

import 'package:flutter/material.dart';
import '../../Core/Animation/Fade_Animation.dart';
import '../../Core/Colors/Hex_Color.dart';
import '../../controller/user_controller.dart';
import '../../models/user_model.dart';
import '../components/drawer_component.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum FormData {
  Name,
  Phone,
  Email,
  Cpf,
  Complement,
  Cep,
  Password,
  CurrentlyPassword,
  Code
}

class UserEditPage extends StatefulWidget {
  final UserModel user;
  const UserEditPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserEditPageState createState() => _UserEditPageState(user: user);
}

class _UserEditPageState extends State<UserEditPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color disable = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  FormData? selected;
  final UserModel user;

  File? _image;
  PickedFile? _pickedFile;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (await Permission.photos.request().isGranted) {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else {
      // Você não tem permissão para acessar a galeria de imagens
      // Exiba uma mensagem ou solicite permissão novamente
    }
    if (_pickedFile != null) {
      setState(() {
        _image = File(_pickedFile!.path);
      });
    }
  }

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController cpfController = new TextEditingController();

  TextEditingController complementController = new TextEditingController();
  TextEditingController cepController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();
  TextEditingController currentlyPasswordController =
      new TextEditingController();

  _UserEditPageState({required this.user});
  File imageFile = File('path/to/default/image.jpg');
  @override
  void initState() {
    super.initState();
    imageFile = File('path/to/default/image.jpg');
    _tabController = TabController(length: 4, vsync: this);
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
          title: const Text('Meu perfil'),
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
              Tab(text: 'Dados Pessoais'),
              Tab(text: 'Endereço'),
              Tab(text: 'Acesso'),
              Tab(text: 'Avatar'),
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
                      FadeAnimation(
                        duration: Duration(milliseconds: 500),
                        delay: 0.2,
                        child: _pickedFile != null
                            ? CircleAvatar(
                                radius: 80,
                                backgroundImage:
                                    FileImage(File(_pickedFile!.path)),
                              )
                            : widget.user.avatar == null
                                ? CircleAvatar(
                                    radius: 80,
                                    backgroundImage: NetworkImage(
                                        "https://doitall.com.br/img/avatar.png"))
                                : CircleAvatar(
                                    radius: 80,
                                    backgroundImage: NetworkImage(
                                        "https://doitall.com.br/avatars/${widget.user.id}-${widget.user.cpf}/${widget.user.avatar}"),
                                  ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                      onTap: () {},
                                      child: Text("Dados pessoais",
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
                                          '${user.email!.isEmpty ? "Sem email cadastrado" : user.email}',
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
                                height: 10,
                              ),
                              Visibility(
                                visible: user.temporaryemail != null,
                                child: FadeAnimation(
                                  duration: Duration(milliseconds: 500),
                                  delay: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Text(
                                            "Va para aba 'ACESSO' pra confimar a alteração de email",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                        255, 205, 130, 130)
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                                fontSize: 10)),
                                      ),
                                    ],
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
                                      "Alterar",
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

            //tab2
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
                    'https://doitall.com.br/img/background2.png',
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
                              Visibility(
                                visible: user.complement?.isNotEmpty == true,
                                child: FadeAnimation(
                                  duration: Duration(milliseconds: 500),
                                  delay: 3,
                                  child: Card(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Endereço",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                        255, 205, 130, 130)
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                                fontSize: 20),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            "${widget.user.street ?? ""} - ${widget.user.complement ?? ""} ${widget.user.neighborhood ?? ""}",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.location_city,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "${user.city ?? ""}",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.location_on,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "${user.uf ?? ""}",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
                                    color: selected == FormData.Complement
                                        ? enabled
                                        : backgroundColor,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextField(
                                    controller: complementController,
                                    onTap: () {
                                      setState(() {
                                        selected = FormData.Complement;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.local_activity,
                                        color: selected == FormData.Complement
                                            ? enabledtxt
                                            : disable,
                                        size: 20,
                                      ),
                                      hintText: 'Sem complemento cadastrado',
                                      hintStyle: TextStyle(
                                          color: selected == FormData.Complement
                                              ? enabledtxt
                                              : disable,
                                          fontSize: 12),
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: selected == FormData.Complement
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
                                    color: selected == FormData.Cep
                                        ? enabled
                                        : backgroundColor,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextField(
                                    controller: cepController,
                                    onTap: () {
                                      setState(() {
                                        selected = FormData.Cep;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.credit_card,
                                        color: selected == FormData.Cep
                                            ? enabledtxt
                                            : disable,
                                        size: 20,
                                      ),
                                      hintText:
                                          '${user.cep!.isEmpty ? "Sem cep cadastrado" : user.cep}',
                                      hintStyle: TextStyle(
                                          color: selected == FormData.Cep
                                              ? enabledtxt
                                              : disable,
                                          fontSize: 12),
                                    ),
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: selected == FormData.Cep
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
                                      UserController userController2 =
                                          UserController();

                                      userController2.updateUseraddress(
                                          context,
                                          user,
                                          complementController.text,
                                          cepController.text);
                                    },
                                    child: Text(
                                      "Alterar",
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

            //tab3
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
                    'https://doitall.com.br/img/background2.png',
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
                                      child: Text("Acesso",
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
                                    color:
                                        selected == FormData.CurrentlyPassword
                                            ? enabled
                                            : backgroundColor,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextField(
                                    controller: currentlyPasswordController,
                                    onTap: () {
                                      setState(() {
                                        selected = FormData.CurrentlyPassword;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.lock_open_outlined,
                                          color: selected ==
                                                  FormData.CurrentlyPassword
                                              ? enabledtxt
                                              : disable,
                                          size: 20,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: ispasswordev
                                              ? Icon(
                                                  Icons.visibility_off,
                                                  color: selected ==
                                                          FormData
                                                              .CurrentlyPassword
                                                      ? enabledtxt
                                                      : disable,
                                                  size: 20,
                                                )
                                              : Icon(
                                                  Icons.visibility,
                                                  color: selected ==
                                                          FormData
                                                              .CurrentlyPassword
                                                      ? enabledtxt
                                                      : disable,
                                                  size: 20,
                                                ),
                                          onPressed: () => setState(() =>
                                              ispasswordev = !ispasswordev),
                                        ),
                                        hintText: 'Senha atual',
                                        hintStyle: TextStyle(
                                            color: selected ==
                                                    FormData.CurrentlyPassword
                                                ? enabledtxt
                                                : disable,
                                            fontSize: 12)),
                                    obscureText: ispasswordev,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: selected ==
                                                FormData.CurrentlyPassword
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
                                    color: selected == FormData.Password
                                        ? enabled
                                        : backgroundColor,
                                  ),
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
                                          size: 20,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: ispasswordev
                                              ? Icon(
                                                  Icons.visibility_off,
                                                  color: selected ==
                                                          FormData.Password
                                                      ? enabledtxt
                                                      : disable,
                                                  size: 20,
                                                )
                                              : Icon(
                                                  Icons.visibility,
                                                  color: selected ==
                                                          FormData.Password
                                                      ? enabledtxt
                                                      : disable,
                                                  size: 20,
                                                ),
                                          onPressed: () => setState(() =>
                                              ispasswordev = !ispasswordev),
                                        ),
                                        hintText: 'Nova senha',
                                        hintStyle: TextStyle(
                                            color: selected == FormData.Password
                                                ? enabledtxt
                                                : disable,
                                            fontSize: 12)),
                                    obscureText: ispasswordev,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        color: selected == FormData.Password
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
                                      UserController userController3 =
                                          UserController();

                                      userController3.updatePassword(
                                          context,
                                          user,
                                          currentlyPasswordController.text,
                                          passwordController.text);
                                    },
                                    child: Text(
                                      "Alterar",
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
                              Visibility(
                                visible: user.temporaryemail != null,
                                child: Column(
                                  children: [
                                    SizedBox(height: 40),
                                    Center(
                                      child: Text(
                                        "Foi solicitado alteração de email, para concluir informe o código que foi enviado para o email: ${user.temporaryemail}",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                    255, 223, 113, 113)
                                                .withOpacity(0.9),
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.5,
                                            fontSize: 15),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    FadeAnimation(
                                      duration: Duration(milliseconds: 500),
                                      delay: 3,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
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
                                            hintText: 'Digite o codigo',
                                            hintStyle: TextStyle(
                                                color: selected == FormData.Code
                                                    ? enabledtxt
                                                    : disable,
                                                fontSize: 15),
                                          ),
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          style: TextStyle(
                                              color: selected == FormData.Code
                                                  ? enabledtxt
                                                  : disable,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    FadeAnimation(
                                      duration: Duration(milliseconds: 500),
                                      delay: 1,
                                      child: TextButton(
                                        onPressed: () {
                                          UserController userController3 =
                                              UserController();
                                          userController3
                                              .changeemailcodevalidation(
                                            context,
                                            user,
                                            codeController.text,
                                          );
                                        },
                                        child: Text(
                                          "Alterar",
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
                                            vertical: 14.0,
                                            horizontal: 80,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                      ),
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

            //tab4
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
                    'https://doitall.com.br/img/background2.png',
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
                                      child: Text("Avatar",
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
                              FadeAnimation(
                                delay: 1,
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                    width: 300,
                                    height: 40,
                                    padding: const EdgeInsets.all(5.0),
                                    child: ElevatedButton(
                                      child: Text('Alterar foto'),
                                      onPressed: () => _pickImage(),
                                    )
                                    ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                duration: Duration(milliseconds: 500),
                                delay: 0.2,
                                child: _pickedFile != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            FileImage(File(_pickedFile!.path)),
                                      )
                                    : widget.user.avatar == null
                                        ? CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                "https://doitall.com.br/img/avatar.png"),
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                "https://doitall.com.br/avatars/${widget.user.id}-${widget.user.cpf}/${widget.user.avatar}"),
                                          ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                duration: Duration(milliseconds: 500),
                                delay: 1,
                                child: TextButton(
                                  onPressed: _image != null
                                      ? () {
                                          UserController userController4 =
                                              UserController();
                                          userController4.updateImage(
                                              context, user, _image!);
                                        }
                                      : null,
                                  child: Text(
                                    "Alterar",
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
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
