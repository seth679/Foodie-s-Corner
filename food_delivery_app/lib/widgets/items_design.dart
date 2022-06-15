import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/global/global.dart';
import 'package:food_delivery_app/mainScreens/item_detail_screen.dart';
import 'package:food_delivery_app/models/items.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ItemsDesignWidget extends StatefulWidget {
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});

  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {

  deleteMenu(String menuID){
    FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(menuID)
        .delete();

    Fluttertoast.showToast(msg: "Menu Deleted Successfully.");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemDetailsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 1.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model!.title!,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 18,
                      fontFamily: "Train",
                    ),
                  ),
                  // IconButton(
                  //     onPressed: () {
                  //       //delete menu
                  //       // deleteMenu(widget.model!.menuID!);
                  //     },
                  //     icon: const Icon(
                  //       Icons.delete_sweep,
                  //       color: Colors.purple,
                  //     )
                  // )
                ],
              ),
              const SizedBox(height: 2.0,),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 2.0,),



              Text(
                widget.model!.shortInfo!,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,

                ),
              ),
              const SizedBox(height: 1.0,),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
