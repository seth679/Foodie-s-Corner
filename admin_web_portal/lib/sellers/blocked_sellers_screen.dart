import 'package:admin_web_portal/main_screens/home_screen.dart';
import 'package:admin_web_portal/widgets/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedSellersScreen extends StatefulWidget {
  const BlockedSellersScreen({Key? key}) : super(key: key);

  @override
  State<BlockedSellersScreen> createState() => _BlockedSellersScreenState();
}

class _BlockedSellersScreenState extends State<BlockedSellersScreen> {

  QuerySnapshot? allSellers;

  displayDialogBoxForActivatingAccount(sellerDocumentID){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text(
              "Activate Account",
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              "Do you want to activate this account?",
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 2,

              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
              ElevatedButton(
                onPressed: () {
                  Map<String, dynamic> sellerDataMap = {
                    "status": "approved",
                  };

                  FirebaseFirestore.instance
                      .collection("sellers")
                      .doc(sellerDocumentID)
                      .update(sellerDataMap).then((value)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));

                    SnackBar snackBar = const SnackBar(content: Text(
                      "Activated Successfully.",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                      backgroundColor: Colors.cyan,
                      duration: Duration(seconds: 2),

                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                },
                child: const Text("Yes"),
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {

    super.initState();

    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "not approved")
        .get().then((blockedSellers)
    {
      setState(() {
        allSellers = blockedSellers;
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    Widget displayBlockedSellersDesign(){
      if(allSellers != null){
        return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allSellers!.docs.length,
            itemBuilder: (context, i)
            {
              return Card(
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        leading: Container(
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(allSellers!.docs[i].get("sellerAvatarUrl")),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        title: Text(
                          allSellers!.docs[i].get("sellerName"),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.email, color: Colors.black,),
                            const SizedBox(width: 20,),
                            Text(
                              allSellers!.docs[i].get("sellerEmail"),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber,

                        ),
                        onPressed: () {
                          SnackBar snackBar = SnackBar(content: Text(
                            "Total Earnings: ".toUpperCase() + "₹ " + allSellers!.docs[i].get("earnings").toString(),
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                            backgroundColor: Colors.amber,
                            duration: const Duration(seconds: 2),

                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(Icons.person_pin_sharp, color: Colors.white,),
                        label: Text(
                          "Total Earnings: ".toUpperCase() + "₹ " + allSellers!.docs[i].get("earnings").toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,

                        ),
                        onPressed: () {
                          displayDialogBoxForActivatingAccount(allSellers!.docs[i].id);
                        },
                        icon: const Icon(Icons.person_pin_sharp, color: Colors.white,),
                        label: Text(
                          "Activate this Account".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        );
      }
      else{
        return const Center(
          child: Text(
            "No Record Found",
            style: TextStyle(fontSize: 30,),
          ),
        );
      }

    }

    return Scaffold(
      appBar: SimpleAppBar(title: "Blocked Sellers Accounts",),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: displayBlockedSellersDesign(),
        ),
      ),
    );
  }
}
