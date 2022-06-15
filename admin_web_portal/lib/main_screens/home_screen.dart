import 'dart:async';

import 'package:admin_web_portal/authentication/login_screen.dart';
import 'package:admin_web_portal/riders/blocked_riders_screen.dart';
import 'package:admin_web_portal/riders/verified_riders_screen.dart';
import 'package:admin_web_portal/sellers/blocked_sellers_screen.dart';
import 'package:admin_web_portal/sellers/verified_sellers_screen.dart';
import 'package:admin_web_portal/users/blocked_users_screen.dart';
import 'package:admin_web_portal/users/verified_users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String timeText = "";
  String dateText = "";

  String formatCurrentLiveTime(DateTime time){
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentDate(DateTime date){
    return DateFormat("dd MMMM, yyyy").format(date);
  }

  getCurrentLiveTime(){
    final DateTime timeNow = DateTime.now();
    final String liveTime = formatCurrentLiveTime(timeNow);
    final String liveDate = formatCurrentDate(timeNow);

    if(this.mounted){
      setState(() {
        timeText = liveTime;
        dateText = liveDate;
      });
    }
  }
  
  @override
  void initState(){
    super.initState();
    
    //time
    timeText = formatCurrentLiveTime(DateTime.now());
    
    //date
    dateText = formatCurrentDate(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (timer){
      getCurrentLiveTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber,
                Colors.cyan,
              ],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "Admin Web Portal",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 3,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                timeText + "\n" + dateText,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //users activate and block accounts button ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //activate
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => const VerifiedUsersScreen()));
                    },
                    icon: const Icon(Icons.person_add, color: Colors.white,),
                    label: Text(
                      "Verified Users".toUpperCase() + "\n" + "Accounts".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(35),
                    primary: Colors.amber,
                  ),
                ),
                const SizedBox(width: 20,),
                //block
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const BlockedUsersScreen()));
                  },
                  icon: const Icon(Icons.block_flipped, color: Colors.white,),
                  label: Text(
                    "Blocked Users".toUpperCase() + "\n" + "Accounts".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(35),
                    primary: Colors.cyan,
                  ),
                ),
              ],
            ),
            //sellers activate and block accounts button ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //activate
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const VerifiedSellersScreen()));
                  },
                  icon: const Icon(Icons.person_add, color: Colors.white,),
                  label: Text(
                    "Verified Sellers".toUpperCase() + "\n" + "Accounts".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(35),
                    primary: Colors.cyan,
                  ),
                ),
                const SizedBox(width: 20,),
                //block
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const BlockedSellersScreen()));
                  },
                  icon: const Icon(Icons.block_flipped, color: Colors.white,),
                  label: Text(
                    "Blocked Sellers".toUpperCase() + "\n" + "Accounts".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(35),
                    primary: Colors.amber,
                  ),
                ),
              ],
            ),
            //riders activate and block accounts button ui
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //activate
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const VerifiedRidersScreen()));
                  },
                  icon: const Icon(Icons.person_add, color: Colors.white,),
                  label: Text(
                    "Verified Riders".toUpperCase() + "\n" + "Accounts".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(35),
                    primary: Colors.amber,
                  ),
                ),
                const SizedBox(width: 20,),
                //block
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const BlockedRidersScreen()));
                  },
                  icon: const Icon(Icons.block_flipped, color: Colors.white,),
                  label: Text(
                    "Blocked Riders".toUpperCase() + "\n" + "Accounts".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 15,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(35),
                    primary: Colors.cyan,
                  ),
                ),
              ],
            ),

            //logout button
            ElevatedButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout, color: Colors.white,),
              label: Text(
                "Logout".toUpperCase(),
                style: const TextStyle(
                  fontSize: 15,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(30),
                primary: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
