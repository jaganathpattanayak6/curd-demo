import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:product_demo/model/db.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';


class CreateEditScreen extends StatefulWidget {
  int id;
  String screen;
  CreateEditScreen({ this.id,  this.screen});

  @override
  _CreateEditScreenState createState() => _CreateEditScreenState();
}

class _CreateEditScreenState extends State<CreateEditScreen> {
  TextEditingController nameTextController =  TextEditingController();
  TextEditingController dateTextController =  TextEditingController();
  TextEditingController placeTextController =  TextEditingController();

  var ratingpoint = 0.0;
  var ratingvalue = 0.0;

  DateTime selectedDate = DateTime.now();

  MyDb mydb = new MyDb();

  @override
  void initState() {
    mydb.open();
    if(widget.screen == "edit"){
      Future.delayed(Duration(milliseconds: 500), () async {
        var data = await mydb.getProduct(widget.id);
        if(data != null){
          nameTextController.text = data["name"];
          dateTextController.text = data["date"].toString();
          placeTextController.text = data["address"];
          setState(() {});
        }else{
          print("No any data with id: " + widget.id.toString());
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kPrimaryBodyColor,
      appBar: _getAppbar,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffffffff), Color(0xffECE4DF)],
            )),
        child: _body,
      ),
    );
  }

  get _getAppbar {
    return  AppBar(
      backgroundColor: Colors.redAccent,
      elevation: 3.0,
      title:  Text(
          widget.screen == "edit" ? 'Edit Product' : 'Add New Product',
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: IconButton(
          padding: const EdgeInsets.only(left: 10.0, bottom: 5.0),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }

  get _body {
    return SingleChildScrollView(
      child: Column(children: <Widget>[

        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
          // padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20.0),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                        child: Text(
                            widget.screen == "edit" ? 'Edit Product' : 'Add New Product',
                          style: GoogleFonts.poppins(
                              fontSize: 30.0,
                              //fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ))),
                const SizedBox(height: 10.0,),
                TextFormField(
                  controller: nameTextController,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    filled: true,
                    //fillColor: kPrimaryLightColor,
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(29)),
                        borderSide: BorderSide(
                            color: Color(0xffa8abc1), width: 1)),
                    contentPadding: EdgeInsets.only(left: 15.0),
                    prefixIcon:
                    Icon(Icons.apps_sharp, color: Colors.redAccent),
                    hintText: 'Product Name',
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(29)),
                        borderSide: BorderSide(
                            color: Color(0xffa8abc1), width: 1)),
                    errorBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Color(0x80eb5b77),
                          width: 1,
                        )),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: dateTextController,
                  textAlign: TextAlign.left,
                  readOnly: true, //this is important
                  onTap: _selectDate,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    filled: true,
                    //fillColor: kPrimaryLightColor,
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(29)),
                        borderSide: BorderSide(
                            color: Color(0xffa8abc1), width: 1)),
                    contentPadding: EdgeInsets.only(left: 15.0),
                    prefixIcon:
                    Icon(Icons.calendar_today, color: Colors.redAccent),
                    hintText: 'Launched At',
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(29)),
                        borderSide: BorderSide(
                            color: Color(0xffa8abc1), width: 1)),
                    errorBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Color(0x80eb5b77),
                          width: 1,
                        )),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: placeTextController,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    filled: true,
                    //fillColor: kPrimaryLightColor,
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(29)),
                        borderSide: BorderSide(
                            color: Color(0xffa8abc1), width: 1)),
                    contentPadding: EdgeInsets.only(left: 15.0),
                    prefixIcon:
                    Icon(Icons.location_on, color: Colors.redAccent),
                    hintText: 'Lunch site',
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(29)),
                        borderSide: BorderSide(
                            color: Color(0xffa8abc1), width: 1)),
                    errorBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Color(0x80eb5b77),
                          width: 1,
                        )),
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SmoothStarRating(
                    rating: ratingpoint,
                    isReadOnly: false,
                    size: 35,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star,
                    defaultIconData: Icons.star_border,
                    starCount: 5,
                    color: Colors.redAccent,
                    borderColor: Colors.redAccent,
                    allowHalfRating: false,
                    spacing: 3.0,
                    onRated: (value) {
                      ratingvalue = value;
                      print("rating value -> $value");
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  child: Center(
                    child: ElevatedButton(onPressed: (){
                      String name = nameTextController.text;
                      String date = nameTextController.text;
                      String place = nameTextController.text;
                      print('ratingvalue:: $ratingvalue');

                      if (name == null || name == "") {
                        Toast.show(
                            "Please enter product name",
                            context,
                            gravity: 1,
                            duration: Toast.LENGTH_LONG);
                        return;
                      } else if (date == null || date == "") {
                        Toast.show(
                            "Please enter date",
                            context,
                            gravity: 1,
                            duration: Toast.LENGTH_LONG);
                        return;
                      }else if (place == null || place == "") {
                        Toast.show(
                            "Please enter place",
                            context,
                            gravity: 1,
                            duration: Toast.LENGTH_LONG);
                        return;
                      }else if ("0.0" == ratingvalue) {
                        Toast.show(
                            "Please select rating ",
                            context,
                            gravity: 1,
                            duration: Toast.LENGTH_LONG);
                        return;
                      }else {
                        if(widget.screen == "edit"){
                          mydb.db.rawInsert("UPDATE products SET name = ?, date = ?, address = ?, starRate = ? WHERE id = ?",
                              [nameTextController.text, dateTextController.text, placeTextController.text, ratingvalue, widget.id]);

                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Updated")));
                          _successDialog(context, "Product Updated Successfully");
                        }else{
                          mydb.db.rawInsert("INSERT INTO products (name, date, address, starRate) VALUES (?,?, ?, ?);",
                              [nameTextController.text, dateTextController.text, placeTextController.text, ratingvalue]);

                          //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New Product Added")));
                          _successDialog(context, "New Product Added Successfully");
                          nameTextController.text = "";
                          dateTextController.text = "";
                          placeTextController.text = "";
                        }
                      }

                    }, child: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background
                        onPrimary: Colors.white, // foreground
                      ),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
        dateTextController.text = formattedDate;

      });
    }
  }

  Future<void> _successDialog(
      BuildContext context, String name) async {
    String msg = name ;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(30),
              child: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 185,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                    ),
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 8),
                    child: Column(
                      children: [
                        Text('Awesome!',
                            style: GoogleFonts.poppins(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center
                        ),
                        Text(msg,
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,),
                            maxLines: 2,
                            textAlign: TextAlign.center
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: SizedBox(
                            width: 150.0,
                            height: 36.0,
                            child: RaisedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Ok',
                                style: GoogleFonts.poppins(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                              color: Colors.greenAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: -40,
                      child: Container(
                        height: 80,
                        width: 80,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.greenAccent,
                        ),
                        child: Icon(
                          Icons.done,
                          size: 40.0,
                          color: Colors.white,
                        ),)
                  )
                ],
              )
          );
        });
  }
}