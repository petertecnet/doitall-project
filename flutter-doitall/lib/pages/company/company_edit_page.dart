import 'dart:io';

import 'package:doitall/pages/user/user_edit_page.dart';
import 'package:flutter/material.dart';
import '../../Core/Animation/Fade_Animation.dart';
import '../../Core/Colors/Hex_Color.dart';
import '../../controller/company_controller.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/company_model.dart';
import '../../models/user_model.dart';
import '../components/drawer_component.dart';

enum FormData { Name, Phone, Email, Cpf }

class CompanyEditPage extends StatefulWidget {
  final UserModel user;
  final CompanyModel company;
  const CompanyEditPage({Key? key, required this.user, required this.company})
      : super(key: key);

  @override
  _CompanyEditPageState createState() =>
      _CompanyEditPageState(user: user, company: company);
}

class _CompanyEditPageState extends State<CompanyEditPage>
    with SingleTickerProviderStateMixin {
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color disable = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  FormData? selected;
  final UserModel user;
  final CompanyModel company;

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController cpfController = new TextEditingController();

  File? _image;
  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _image = File(_pickedFile!.path);
      });
      try {
        await CompanyController;
        var companyController = CompanyController();
        await companyController.updateImage(context, user, _image);
        // Aqui você pode exibir uma mensagem informando que a imagem foi enviada com sucesso
      } catch (e) {
        // Aqui você pode tratar possíveis erros que ocorrerem durante a chamada da API
        print("Ocorreu um erro ao enviar a imagem: $e");
      }
    }
  }

  _CompanyEditPageState({required this.user, required this.company});
  File imageFile = File('path/to/default/image.jpg');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Retorna false para impedir que a página seja fechada
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${company.fantasyName}'),
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
        ),
        drawer: DrawerComponent(user: user),
        body: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Container(
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
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Card(
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
                              GestureDetector(
                                onTap: () {
                                  _pickImage();
                                },
                                child: FadeAnimation(
                                  duration: Duration(milliseconds: 500),
                                  delay: 0.2,
                                  child: _pickedFile != null
                                      ? CircleAvatar(
                                          radius: 80,
                                          backgroundImage: FileImage(
                                            File(_pickedFile!.path),
                                          ),
                                        )
                                      : widget.company.logo == null
                                          ? CircleAvatar(
                                              radius: 80,
                                              backgroundImage: NetworkImage(
                                                "https://doitall.com.br/img/business.png",
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 80,
                                              backgroundImage: NetworkImage(
                                                "https://doitall.com.br/logos/${widget.company.id}-${widget.company.cnpj}/${widget.company.logo!}",
                                              ),
                                            ),
                                ),
                              ),
                              FadeAnimation(
                                duration: Duration(milliseconds: 100),
                                delay: 1,
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
                                      child: Text("EMPRESA: ",
                                          style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                              fontSize: 15)),
                                    ),
                                    SizedBox(height: 50),
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
                                      child: Text("${company.name}",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                      255, 237, 176, 176)
                                                  .withOpacity(0.9),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.5,
                                              fontSize: 10)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              FadeAnimation(
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
                                          SizedBox(height: 8),
                                          Text(
                                            "${widget.company.fantasyName}",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(height: 30),
                                          Row(
                                            children: [
                                              Icon(Icons.location_city,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "Cidade: ${widget.company.city ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
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
                                                "UF: ${widget.company.uf ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.money,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "Capital social:  ${widget.company.socialCapital ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.local_activity,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "Cep: ${widget.company.cep ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.email,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "Emal: ${widget.company.email ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.business,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "CNPJ: ${widget.company.cnpj ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.phone,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "Telefone: ${widget.company.phone ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.date_range,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "Data de abertura: ${widget.company.openDate ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(Icons.person,
                                                  color: Colors.black87),
                                              SizedBox(width: 8),
                                              Text(
                                                "Porte: ${widget.company.size ?? ""}",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
