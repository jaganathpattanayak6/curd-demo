import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_demo/model/db.dart';
import 'package:product_demo/view/create_edit_product.dart';


class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Map> slist = [];
  MyDb mydb = new MyDb();
  String starval;

  @override
  void initState() {
    setState(() {
      mydb.open();
      getdata();
    });
    super.initState();
  }

  getdata(){
    Future.delayed(Duration(milliseconds: 500),() async {
      slist = await mydb.db.rawQuery('SELECT * FROM products');
      setState(() { });
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: slist.length == 0?Text("No any product to show."):

          Column(
            children: slist.map((prone){
              if(prone["starRate"] == "1.0"){
                starval ="*";
              }else if(prone["starRate"] == "2.0"){
                starval ="**";
              }else if(prone["starRate"] == "3.0"){
                starval ="***";
              }else if(prone["starRate"] == "4.0"){
                starval ="****";
              }else if(prone["starRate"] == "5.0"){
                starval ="*****";
              }else{
                starval ="";
              }
              return Card(
                child: ListTile(
                  leading: Icon(Icons.apps_sharp, color: Colors.redAccent),
                  title: Text(prone["name"],
                    style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),),
                  subtitle: RichText(
                    text: TextSpan(
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                            text: (" Date: "),
                            style: new TextStyle(
                                fontWeight:
                                FontWeight.w600)),
                        new TextSpan(
                            text: (prone["date"].toString()),
                            style: new TextStyle(
                                fontWeight:
                                FontWeight.w300)),
                        new TextSpan(
                            text: ("\n Address: "),
                            style: new TextStyle(
                                fontWeight:
                                FontWeight.w600)),
                        new TextSpan(
                            text: (prone["address"]),
                            style: new TextStyle(
                                fontWeight:
                                FontWeight.w300)),
                        new TextSpan(
                            text: ("\n "),
                            style: new TextStyle(
                                fontWeight:
                                FontWeight.w600)),
                        new TextSpan(
                            text: ( starval),
                            style: new TextStyle(
                                color: Colors.redAccent,fontSize: 30,fontWeight:
                            FontWeight.w600)),
                      ],
                    ),
                  ),
                  /*Text("Date: " + prone["date"].toString() + ",\n Address: " + prone["address"]+ ",\n Rate: " + starval,
                    style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        //fontWeight: FontWeight.bold,
                        color: Colors.black),),*/
                  trailing: Wrap(children: [

                    IconButton(onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateEditScreen(
                              id: prone["id"],
                              screen: 'edit',
                            )),
                      ).then((value) {
                        setState(() {
                          getdata();
                        });
                      });
                    }, icon: Icon(Icons.edit)),


                    IconButton(onPressed: () async {

                      print("iiiii ${[prone["id"]]}");
                      await mydb.db.rawDelete("DELETE FROM products WHERE id = ?", [prone["id"]]);
                      print("Data Deleted");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Data Deleted")));
                      getdata();
                    }, icon: Icon(Icons.delete, color:Colors.red))


                  ],),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:  () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateEditScreen(
                  id: 0,
                  screen: 'create',
                )),
          ).then((value) {
            setState(() {
              getdata();
            });
          });
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}