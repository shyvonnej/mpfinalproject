// ignore_for_file: unnecessary_null_comparison, avoid_print, unused_element, unused_local_variable

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:tmj_finalproject/model/config.dart';
import 'package:tmj_finalproject/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:nonce/nonce.dart';
import 'paymentpage.dart';
import 'tabpage1.dart';

class CartPage extends StatefulWidget {
  final User user;
  const CartPage({Key? key, required this.user}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List cartList = [];
  late double payableamount = 0;
  double totalprice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    late double screenHeight, screenWidth, resWidth;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.60;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CART'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteAll();
            },
          ),
        ],
      ),
      body: cartList.isEmpty
          ? const Center(
              child: Text(
                "Loading your cart..",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : SingleChildScrollView(
          child: Center(
                child: SizedBox(
                  width: resWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ListView.separated(
                            separatorBuilder: (context, index) {
                              return Column(
                                children: const [
                                  Divider(),
                                ],
                              );
                            },
                            itemCount: cartList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10,
                                child: SingleChildScrollView(
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: screenHeight /10,
                                            width: screenWidth / 5.8,
                                            child: ClipOval(
                                                child: CachedNetworkImage(
                                              fit: BoxFit.scaleDown,
                                              imageUrl: PCConfig.server +
                                                  "/tmj/images/products/${cartList[index]['prid']}.jpg",
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            )),
                                          ),
                                          Text(
                                            "RM " + cartList[index]['prprice'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 1, 10, 1),
                                          child: SizedBox(
                                              width: 2,
                                              child: SizedBox(
                                                height: screenWidth / 3.5,
                                              ))),
                                      SizedBox(
                                          width: screenWidth / 1.45,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      cartList[index]['prname'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: Colors.white),
                                                      maxLines: 1,
                                                    ),
                                                    Text(
                                                      "Available " +
                                                          cartList[index]
                                                              ['prqty'].toString() +
                                                          " unit",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Your Quantity " +
                                                          cartList[index]
                                                              ['cart_quantity'].toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: 20,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            SizedBox(width: 50, height: 30, child:
                                                            ElevatedButton(
                                                              onPressed: () => {
                                                                _updateCart(
                                                                    index, "add")
                                                              },
                                                              child: const Icon(
                                                                Icons.add,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        101,
                                                                        255,
                                                                        218,
                                                                        50),
                                                              ),
                                                            )
                                                            ),
                                                            Text("  " +
                                                              cartList[index][
                                                                  'cart_quantity'] + "  ",
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    Colors.white,
                                                              ),
                                                            ),
                                                            SizedBox(width: 50, height: 30, child:
                                                            ElevatedButton(
                                                              onPressed: () => {
                                                                _updateCart(index,
                                                                    "remove")
                                                              },
                                                              child: const Icon(
                                                                Icons.remove,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        101,
                                                                        255,
                                                                        218,
                                                                        50),
                                                              ),
                                                            ),
                                                            ),
                                                          ],
                                                        )),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: <Widget>[
                                                        Text(
                                                            "Total RM " +
                                                                cartList[index]
                                                                    ['prprice'],
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:FontWeight.bold,
                                                                  color: Colors.white)),
                                                        SizedBox(width: 50, height: 30, child:
                                                        ElevatedButton(
                                                          onPressed: () => {
                                                            _deleteCart(index)
                                                          },
                                                          child: const Icon(
                                                            Icons.delete,
                                                            color: Color.fromRGBO(
                                                                101,
                                                                255,
                                                                218,
                                                                50),))
                                                )])]))]))]))));
                            }),
                        const SizedBox(height: 20),
                        Table(
                            defaultColumnWidth: const FlexColumnWidth(1.0),
                            // ignore: prefer_const_literals_to_create_immutables
                            columnWidths: {
                              0: const FlexColumnWidth(7),
                              1: const FlexColumnWidth(3),
                            },
                            children: [
                              TableRow(children: [
                                const TableCell(
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      //height: 20,
                                      child: Text("Total Amount ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                ),
                                TableCell(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    //height: 20,
                                    child: Text(
                                        "RM" +
                                            totalprice.toStringAsFixed(2),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                ),
                              ]),
                            ]),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: _makePaymentDialog, child: const Text("Make Payment"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ]
                    ),
                  ),
                ),
              ),
          ),
    );
  }

  _loadCart() {
    http.post(Uri.parse(PCConfig.server + "/tmj/php/load_cart.php"),
        body: {"user_email": widget.user.email.toString()}).then((response) {
      if (response.body != "Cart Empty") {
        setState(() {
          var extractdata = jsonDecode(response.body);
          cartList = extractdata["cart"];
          for (int i = 0; i < cartList.length; i++) {
            totalprice = double.parse(cartList[i]['prprice']) + totalprice;
          }
          print(response
              .body);
          print(totalprice);
        });
      }
    });
  }

// needa edit other functions later too

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Text(
          'Delete all items?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(
                    Uri.parse(PCConfig.server + "/tmj/php/delete_cart.php"),
                    body: {"user_email": widget.user.email}).then((res) {
                  print(res.body);
                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Fluttertoast.showToast(
                        msg: "Failed",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        fontSize: 14.0);
                    return;
                  }
                });
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Color.fromRGBO(101, 255, 218, 50),
                ),
              )),
        ],
      ),
    );
  }

  _deleteCart(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              'Delete item?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    http.post(
                        Uri.parse(PCConfig.server + "/tmj/php/delete_cart.php"),
                        body: {
                          "user_email": widget.user.email,
                          "prid": cartList[index]['prid'],
                        }).then((res) {
                      print(res.body);
                      if (res.body == "success") {
                        _loadCart();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Failed",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.red,
                            fontSize: 14.0);
                      }
                    });
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          );
        });
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartList[index]['quantity']);
    int quantity = int.parse(cartList[index]['cart_quantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Fluttertoast.showToast(
            msg: "Quantity not available",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 14.0);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    http.post(Uri.parse(PCConfig.server + "/tmj/php/update_cart.php"), body: {
      "user_email": widget.user.email,
      "prid": cartList[index]['prid'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Fluttertoast.showToast(
            msg: "Cart Updated",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.green,
            fontSize: 14.0);
        _loadCart();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.red,
            fontSize: 14.0);
      }
    });
  }

   _makePaymentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              'Proceed with payment?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: const Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    makePayment();
                  },
                  child: const Text(
                    "Ok",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          );
        });
  }

  void _updatePayment() {
    totalprice = 0.0;
    setState(() {
      for (int i = 0; i < cartList.length; i++) {
        totalprice = double.parse(cartList[i]['yourprice']) + totalprice;
      }
      print(totalprice);
    });
  }

  makePayment() {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyyyy-');
    String orderid = Nonce.key().toString();
    print(orderid);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentPage(
                  user: widget.user,
                  val: totalprice.toStringAsFixed(2),
                )));
    _loadCart();
  }
}