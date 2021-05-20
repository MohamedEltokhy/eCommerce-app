import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/services/firebase_services.dart';
import 'package:ecommerce/widgets/custom_action_bar.dart';
import 'package:ecommerce/widgets/image_swipe.dart';
import 'package:ecommerce/widgets/product_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;

  const ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  FirebaseServices _firebaseServices = FirebaseServices();

//  final CollectionReference _productRef =
//      FirebaseFirestore.instance.collection("Products");
//
//  final CollectionReference _userRef =
//  FirebaseFirestore.instance.collection("Users");

  //User _user =FirebaseAuth.instance.currentUser;

  String _selectedProductSize = "0";

  Future _addToCart(){
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set(
        {
          "size": _selectedProductSize
        }
    );
  }

  Future _addToSaved(){
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set(
        {
          "size": _selectedProductSize
        }
    );
  }

  final SnackBar _snackBar =SnackBar(content: Text(" product added to the cart"));
  final SnackBar _snackBar2 =SnackBar(content: Text(" product added to the saved"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {

                // firebase document data map
                Map<String, dynamic> documentData = snapshot.data.data();

                // list of images and sizes
                List imageList = documentData['images'];
                List productSizes =documentData['size'];

                // set initial size
                _selectedProductSize = productSizes[0];

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                   ImageSwipe(imageList: imageList,),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0
                      ),
                      child: Text(
                        "${documentData['name']}",
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 24.0),
                      child: Text(
                        "${documentData['price']} LE",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).accentColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 24.0),
                      child: Text(
                        "${documentData['desc']}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 24.0),
                      child: Text(
                        "Select Size ",
                        style: Constants.regularDarkText,
                      ),
                    ),
                   ProductSize(
                     productSizes: productSizes,
                     onSelected: (size){
                       _selectedProductSize = size;
                     },
                   ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(_snackBar2);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              alignment: Alignment.center,
                              width: 60.0,
                              height: 60.0,
                              child: Image(
                                width:24.0,
                                image: AssetImage(
                                  "assets/images/save.png"
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async{
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 60.0,
                                margin:EdgeInsets.only(
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                    "add to cart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              // loading state
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          CustomActionBar(
            hasBackArrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
