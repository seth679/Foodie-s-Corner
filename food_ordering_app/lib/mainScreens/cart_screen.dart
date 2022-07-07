import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_ordering_app/assistantMethods/assistant_methods.dart';
import 'package:food_ordering_app/assistantMethods/cart_item_counter.dart';
import 'package:food_ordering_app/assistantMethods/total_amount.dart';
import 'package:food_ordering_app/mainScreens/address_screen.dart';
import 'package:food_ordering_app/models/items.dart';
import 'package:food_ordering_app/splashScreen/splash_screen.dart';
import 'package:food_ordering_app/widgets/cart_item_design.dart';
import 'package:food_ordering_app/widgets/progress_bar.dart';
import 'package:food_ordering_app/widgets/text_widget_header.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;

  CartScreen({this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);
    separateItemQuantityList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan,
                  Colors.amber,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.clear_all,
          ),
          onPressed: () {
            clearCartNow(context);
            Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen()));

            Fluttertoast.showToast(msg: "Cart has been cleared.");
          },
        ),
        title: const Text(
          "Foodie,s Corner",
          style: TextStyle(
            fontSize: 45,
            fontFamily: "Signatra",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  print("Clicked");
                  //send user to cart screen
                  // Navigator.push(context, MaterialPageRoute(builder: (c) => CartScreen(sellerUID: widget.sellerUID)));
                },
                icon: const Icon(Icons.shopping_cart),
              ),
              Positioned(child: Stack(
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 3,
                    right: 4,
                    child: Center(
                      child: Consumer<CartItemCounter>(
                        builder: (context, counter, c){
                          return Text(
                            counter.count.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),

        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {
                clearCartNow(context);
                Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen()));

                Fluttertoast.showToast(msg: "Cart has been cleared.");
              },
              label: const Text("Clear Cart", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.clear_all),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => AddressScreen(
                          totalAmount: totalAmount.toDouble(),
                          sellerUID: widget.sellerUID,
                        )));
              },
              label: const Text("Check Out", style: TextStyle(fontSize: 16),),
              backgroundColor: Colors.cyan,
              icon: const Icon(Icons.navigate_next),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          //overall total amount
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "My Cart List")),
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c){
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                          "Total Price: ₹ ${amountProvider.tAmount.toString()}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),),
                ),
              );
            }),
          ),

          //display cart items with quantity
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : snapshot.data!.docs.length == 0
                  ? //startBuildingCart()
                    Container()
                  : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index)
                    {
                      Items model = Items.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String, dynamic>
                      );

                      if(index == 0){
                        totalAmount = 0;
                        totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                      }
                      else{
                        totalAmount = totalAmount + (model.price! * separateItemQuantityList![index]);
                      }

                      if(snapshot.data!.docs.length - 1 == index){
                        WidgetsBinding.instance!.addPostFrameCallback((timeStamp)
                        {
                          Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                        });
                      }

                      return CartItemDesign(
                        model: model,
                        context: context,
                        quantity: separateItemQuantityList![index],
                      );
                    },
                      childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                    ),
                    );


            }
          ),
        ],
      ),
    );
  }
}
