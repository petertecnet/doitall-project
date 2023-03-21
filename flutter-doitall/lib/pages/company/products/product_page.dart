import 'package:flutter/material.dart';
import 'package:doitall/models/product_model.dart' as model;
import 'package:doitall/models/company_model.dart';

import '../../../Core/Animation/Fade_Animation.dart';
import '../../../controller/product_controller.dart';
import '../../../models/user_model.dart';
import '../../components/drawer_component.dart';

class ProductPage extends StatelessWidget {
  final List<model.ProductModel> products;
  final int companyid;
  final UserModel user;

  const ProductPage({
    Key? key,
    required this.products,
    required this.companyid,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Retorna false para impedir que a página seja fechada
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Produtos '),
        ),
        drawer: DrawerComponent(user: user),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            final product = products[index];
            final price = product.price is double
                ? product.price
                : (product.price ?? '0.0');

            return Card(
              elevation: 1,
              color: Color.fromARGB(255, 96, 106, 117).withOpacity(0.4),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeAnimation(
                      duration: Duration(milliseconds: 100),
                      delay: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [],
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                FadeAnimation(
                                  duration: Duration(milliseconds: 500),
                                  delay: 0.2,
                                  child: product.imgproduct == null
                                      ? Image.network(
                                          "https://doitall.com.br/img/business.png",
                                          width: 160,
                                          height: 160,
                                        )
                                      : Image.network(
                                          "https://doitall.com.br/products/${product.id}-${product.companyid}/${product.imgproduct}",
                                          width: 160,
                                          height: 160,
                                        ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text("${product.name}".toUpperCase(),
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)
                                              .withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          fontSize: 20)),
                                ),
                                Text(
                                  "Preço: R\$ ${product.price}",
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
                                      "Categoria: ${product.category}",
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
                                      "Modelo: ${product.model}",
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
                                      "Tipo: ${product.type}",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Adicione o código para deletar o produto aqui
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Adicione o código para ver/editar o produto aqui
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
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
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final ProductController productController = ProductController();
            await productController.create(context, companyid, user.id!);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
