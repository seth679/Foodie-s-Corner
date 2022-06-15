import 'package:admin_web_portal/main_screens/home_screen.dart';
import 'package:admin_web_portal/widgets/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedRidersScreen extends StatefulWidget {
  const BlockedRidersScreen({Key? key}) : super(key: key);

  @override
  State<BlockedRidersScreen> createState() => _BlockedRidersScreenState();
}

class _BlockedRidersScreenState extends State<BlockedRidersScreen> {

  QuerySnapshot? allRiders;

  displayDialogBoxForActivatingAccount(riderDocumentID){
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
                  Map<String, dynamic> riderDataMap = {
                    "status": "approved",
                  };

                  FirebaseFirestore.instance
                      .collection("riders")
                      .doc(riderDocumentID)
                      .update(riderDataMap).then((value)
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
        .collection("riders")
        .where("status", isEqualTo: "not approved")
        .get().then((blockedRiders)
    {
      setState(() {
        allRiders = blockedRiders;
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    Widget displayBlockedRidersDesign(){
      if(allRiders != null){
        return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allRiders!.docs.length,
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
                              image: NetworkImage(allRiders!.docs[i].get("riderAvatarUrl")),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        title: Text(
                          allRiders!.docs[i].get("riderName"),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.email, color: Colors.black,),
                            const SizedBox(width: 20,),
                            Text(
                              allRiders!.docs[i].get("riderEmail"),
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
                            "Total Earnings: ".toUpperCase() + "₹ " + allRiders!.docs[i].get("earnings").toString(),
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
                          "Total Earnings: ".toUpperCase() + "₹ " + allRiders!.docs[i].get("earnings").toString(),
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
                          displayDialogBoxForActivatingAccount(allRiders!.docs[i].id);
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
      appBar: SimpleAppBar(title: "Blocked Riders Accounts",),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: displayBlockedRidersDesign(),
        ),
      ),
    );
  }
}
