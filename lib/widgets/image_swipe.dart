import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;

  const ImageSwipe({this.imageList});


  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {

  int _selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.0,
      width: double.infinity,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (num){
              setState(() {
                _selectedPage = num;
              });
            },
            children: [
              for(var i = 0; i < widget.imageList.length; i++)
                Container(
                  child:Image.network(
                    "${widget.imageList[i]}",
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 20.0,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(var i = 0; i < widget.imageList.length; i++)
                  AnimatedContainer(
                    duration: Duration(
                      milliseconds: 300,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.0
                    ),
                    width: _selectedPage == i ? 18.0 : 8.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
