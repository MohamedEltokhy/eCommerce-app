import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/screens/product_page.dart';
import 'package:ecommerce/widgets/custom_action_bar.dart';
import 'package:ecommerce/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class HomeTab extends StatelessWidget {

final CollectionReference _productRef =
FirebaseFirestore.instance.collection("Products");
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children:[
          FutureBuilder<QuerySnapshot>(
              future: _productRef.get(),
              builder: (context,snapshot){
                if(snapshot.hasError){
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                // collection data to display
                if(snapshot.connectionState == ConnectionState.done){
                  //display the data in listView
                  return ListView(
                    padding: EdgeInsets.only(
                      top: 100.0,
                      bottom: 12.0
                    ),
                    children: snapshot.data.docs.map((document){
                      return ProductCard(
                        title: document['name'],
                        imageUrl: document['images'][0],
                        price: "${document['price']} LE",
                        productId: document.id,
                      );
                    }).toList(),
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
            title: "Home",
            hasBackArrow: false,
            hasBackground: false,
          ),
        ]
      ),
    );
  }
}
