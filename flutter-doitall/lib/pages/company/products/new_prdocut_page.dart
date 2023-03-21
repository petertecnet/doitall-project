import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Core/Animation/Fade_Animation.dart';
import '../../../Core/Colors/Hex_Color.dart';
import '../../../controller/product_controller.dart';
import '../../../models/user_model.dart';
import '../../components/drawer_component.dart';

enum FormData { Name, Price, Category, Type, Brand, Description }

class NewProductPage extends StatefulWidget {
  final int companyid;
  final int userid;
  final UserModel user;

  @override
  const NewProductPage({
    Key? key,
    required this.userid,
    required this.companyid,
    required this.user,
  }) : super(key: key);

  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color disable = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  FormData? selected;
  final TextEditingController nameController = new TextEditingController();
  final priceController = TextEditingController();
  final TextEditingController categoryController = new TextEditingController();
  final TextEditingController typeController = new TextEditingController();
  final TextEditingController brandController = new TextEditingController();

  final TextEditingController descriptionController =
      new TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Retorna false para impedir que a página seja fechada
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Novo'),
        ),
        drawer: DrawerComponent(
          user: widget.user,
        ),
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
                  const SizedBox(
                    height: 30,
                  ),
                  Card(
                    elevation: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 400,
                        child: FadeAnimation(
                          duration: Duration(milliseconds: 500),
                          delay: 0.2,
                          child: _pickedFile != null
                              ? Image.file(File(_pickedFile!.path),
                                  width: 1, fit: BoxFit.cover)
                              : Image.network(
                                  "https://doitall.com.br/img/camera.png",
                                  width: 100,
                                ),
                        ),
                      ),
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
                        child: Text('Carregar imagem do item'),
                        onPressed: () => _pickImage(),
                      ),
                    ),
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
                            child: Container(
                              width: MediaQuery.of(context).size.width,
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
                                    Icons.text_fields,
                                    color: selected == FormData.Name
                                        ? enabledtxt
                                        : disable,
                                    size: 15,
                                  ),
                                  hintText: 'Nome',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Name
                                          ? enabledtxt
                                          : disable,
                                      fontSize: 15),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Name
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
                                color: selected == FormData.Price
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: priceController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Price;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.money_off_outlined,
                                    color: selected == FormData.Price
                                        ? enabledtxt
                                        : disable,
                                    size: 15,
                                  ),
                                  hintText: 'Preço',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Price
                                          ? enabledtxt
                                          : disable,
                                      fontSize: 15),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Price
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
                                color: selected == FormData.Category
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: categoryController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Category;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.category_outlined,
                                    color: selected == FormData.Category
                                        ? enabledtxt
                                        : disable,
                                    size: 15,
                                  ),
                                  hintText: 'Categoria',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Category
                                          ? enabledtxt
                                          : disable,
                                      fontSize: 15),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Category
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
                                color: selected == FormData.Type
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: typeController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Type;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.type_specimen,
                                    color: selected == FormData.Type
                                        ? enabledtxt
                                        : disable,
                                    size: 15,
                                  ),
                                  hintText: 'Tipo',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Type
                                          ? enabledtxt
                                          : disable,
                                      fontSize: 15),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Type
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
                                color: selected == FormData.Brand
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: brandController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Brand;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.shop_2_outlined,
                                    color: selected == FormData.Brand
                                        ? enabledtxt
                                        : disable,
                                    size: 15,
                                  ),
                                  hintText: 'Marca',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Brand
                                          ? enabledtxt
                                          : disable,
                                      fontSize: 15),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Brand
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
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: selected == FormData.Description
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: descriptionController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Description;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.description_outlined,
                                    color: selected == FormData.Description
                                        ? enabledtxt
                                        : disable,
                                    size: 15,
                                  ),
                                  hintText: 'Descrição',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Description
                                          ? enabledtxt
                                          : disable,
                                      fontSize: 15),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Description
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
                                  ProductController productController =
                                      ProductController();
                                  final double? price = double.tryParse(
                                      priceController.text
                                          .replaceAll(',', '.'));
                                  if (price != null) {
                                    productController.store(
                                      context,
                                      nameController.text,
                                      typeController.text,
                                      categoryController.text,
                                      brandController.text,
                                      descriptionController.text,
                                      price,
                                      widget.companyid,
                                      widget.userid,
                                      _image,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Color.fromARGB(255, 188, 28, 28),
                                        content: Text(
                                            'Por favor insira um valor de preço válido'),
                                        duration: Duration(seconds: 5),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Cadastrar",
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

                  //End of Center Card
                  //Start of outer card
                  const SizedBox(
                    height: 10,
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
