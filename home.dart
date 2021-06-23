import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _mobileController = TextEditingController();
  final _codeController = TextEditingController();
//returning void
  Future<Product?> getHttp(body) async {
    try {
      var dio = Dio();
      var response = await dio.get(
          'http://13.126.194.204:8000/v2/api/hotomV1/rewards/verify/?',
          queryParameters: body);

      Product product = Product.fromJson(response.data);
      return product;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text("Flutterapi")),
        body: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: "mobile",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: "Code",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      var body = {
                        "mobile": _mobileController.text,
                        "reward_code": _codeController.text,
                      };

                      Product? product = await getHttp(body);

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text(
                                    product != null ? product.message : ""),
                                actions: [
                                  Center(
                                    child: Container(
                                      height: 35,
                                      width: 110,
                                      decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  Product({
    required this.success,
    required this.message,
  });

  bool success;
  String message;

  static Product fromJson(Map<String, dynamic> json) => Product(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}

// mobile=9480954152&reward_code=HOTOMEMR5Y
