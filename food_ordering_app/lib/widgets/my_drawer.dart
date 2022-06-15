import 'package:flutter/material.dart';
import 'package:food_ordering_app/authentication/auth_screen.dart';
import 'package:food_ordering_app/global/global.dart';
import 'package:food_ordering_app/mainScreens/address_screen.dart';
import 'package:food_ordering_app/mainScreens/history_screen.dart';
import 'package:food_ordering_app/mainScreens/home_screen.dart';
import 'package:food_ordering_app/mainScreens/my_orders_screen.dart';
import 'package:food_ordering_app/mainScreens/search_screen.dart';

class MyDrawer extends StatelessWidget {
  // const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //header drawer
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [

                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                    sharedPreferences!.getString("name")!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Train"
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12,),
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: const [
                Divider(
                  height: 10,
                  color: Colors.blueGrey,
                  thickness: 2,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black,),
            title: const Text(
              "Home",
              style: TextStyle(
                color: Colors.black
              ),
            ),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
            },
          ),
          const Divider(
            height: 10,
            color: Colors.blueGrey,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.reorder, color: Colors.black,),
            title: const Text(
              "My Orders",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => MyOrdersScreen()));
            },
          ),
          const Divider(
            height: 10,
            color: Colors.blueGrey,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.access_time, color: Colors.black,),
            title: const Text(
              "History",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => HistoryScreen()));
            },
          ),
          const Divider(
            height: 10,
            color: Colors.blueGrey,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.search, color: Colors.black,),
            title: const Text(
              "Search",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => SearchScreen()));
            },
          ),
          const Divider(
            height: 10,
            color: Colors.blueGrey,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.add_location, color: Colors.black,),
            title: const Text(
              "Add New Address",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (c) => AddressScreen()));
            },
          ),
          const Divider(
            height: 10,
            color: Colors.blueGrey,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.black,),
            title: const Text(
              "Sign Out",
              style: TextStyle(
                  color: Colors.black
              ),
            ),
            onTap: () {
              firebaseAuth.signOut().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
              });
            },
          ),
          const Divider(
            height: 10,
            color: Colors.blueGrey,
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
