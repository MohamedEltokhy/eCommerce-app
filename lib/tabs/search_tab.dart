import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/services/firebase_services.dart';
import 'package:ecommerce/widgets/custom_input.dart';
import 'package:ecommerce/widgets/product_card.dart';
import 'package:flutter/material.dart';


class SearchTab extends StatefulWidget {

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices =FirebaseServices();

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if(_searchString.isEmpty)
            Center(
              child: Container(
                  child: Text(
                    "Search Results",
                    style: Constants.regularDarkText,
                  ),
              ),
            )
          else
            FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.productsRef
                .orderBy("search_string")
                .startAt([_searchString])
                .endAt(["$_searchString\uf8ff"])
                .get(),

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
                      top: 128.0,
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
            Padding(
                padding: const EdgeInsets.only(
                 top: 45.0,
               ),
              child: CustomInput(
              hintText: "search here...",
              onSubmitted: (value){
                setState(() {
                  _searchString = value.toLowerCase();
                });
              },
            ),
          ),
        ],
      ),
    );;
  }
}
