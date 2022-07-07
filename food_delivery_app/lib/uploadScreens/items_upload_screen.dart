import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/global/global.dart';
import 'package:food_delivery_app/mainScreens/home_screen.dart';
import 'package:food_delivery_app/models/menus.dart';
import 'package:food_delivery_app/widgets/error_dialog.dart';
import 'package:food_delivery_app/widgets/progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage_ref;

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;
  ItemsUploadScreen({this.model});


  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  defaultScreen() {
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
        title: const Text(
          "Add New Items",
          style: TextStyle(
            fontSize: 30,
            fontFamily: "Lobster",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.amber,
                Colors.cyan,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shop_two, color: Colors.white, size: 200.0,),
              ElevatedButton(
                onPressed: () {
                  takeImage(context);
                },
                child: const Text(
                  "Add New Item",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext){
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Menu Image",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Capture with Camera",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onPressed: captureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Select from Gallery",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  captureImageWithCamera() async{
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async{
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  itemsUploadFormScreen() {
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
        title: const Text(
          "Uploading New Item",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Lobster",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            clearMenusUploadForm();
            // Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              uploading ? null : validateUploadForm();
            },
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
                fontFamily: "Varela",
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                          File(imageXFile!.path)
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "info",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "title",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "description",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.camera,
              color: Colors.cyan,
            ),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: "price",
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 1,
          ),
        ],
      ),
    );
  }

  clearMenusUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      descriptionController.clear();
      priceController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async{


    if(imageXFile != null)
    {
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && priceController.text.isNotEmpty){
        setState(() {
          uploading = true;
        });

        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        //save info to firestore
        saveInfo(downloadUrl);
      }
      else{
        showDialog(context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Please enter the required details for Item.",
              );
            });
      }
    }
    else {
      showDialog(context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please pick an image for Item.",
            );
          });
    }
  }

  uploadImage(mImageFile) async{
    storage_ref.Reference reference = storage_ref.FirebaseStorage.instance.ref().child("items");
    storage_ref.UploadTask uploadTask =reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storage_ref.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  saveInfo(String downloadUrl){
    final ref1 = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus").doc(widget.model!.menuID)
        .collection("items");

    ref1.doc(uniqueIdName).set({
      "itemID": uniqueIdName,
      "menuID": widget.model!.menuID,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "title": titleController.text.toString(),
      "longDescription": descriptionController.text.toString(),
      "price": int.parse(priceController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then((value) {
      final ref2 = FirebaseFirestore.instance
          .collection("items");

      ref2.doc(uniqueIdName).set({
        "itemID": uniqueIdName,
        "menuID": widget.model!.menuID,
        "sellerUID": sharedPreferences!.getString("uid"),
        "sellerName": sharedPreferences!.getString("name"),
        "shortInfo": shortInfoController.text.toString(),
        "title": titleController.text.toString(),
        "longDescription": descriptionController.text.toString(),
        "price": int.parse(priceController.text),
        "publishedDate": DateTime.now(),
        "status": "available",
        "thumbnailUrl": downloadUrl,
      });
    }).then((value) {
      clearMenusUploadForm();
      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemsUploadFormScreen();
  }
}
