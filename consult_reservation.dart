import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Views/visitor/update_reservation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../park_owner/form_addPark.dart';
import '../park_owner/park.dart';
import '../park_owner/update_park.dart';
import 'database_reservation.dart';
class ConsultReservation extends StatefulWidget {
  const ConsultReservation({ Key? key }) : super(key: key);

  @override
  State<ConsultReservation> createState() => _ConsultReservationState();
}

class _ConsultReservationState extends State<ConsultReservation> {
  late DatabaseReservation db;
  List docs= [];
  initialise(){
    db = DatabaseReservation();
    db.initiliase();
    db.read().then((value) => {
      setState(() {
      docs = value;
    })
    },);
   
    
  }
  @override
  void initState(){
    super.initState();
    initialise();
  }
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          
          "Consult Parking" , 
          style: TextStyle(
            fontSize:20 ),),

        actions: [
          IconButton(
            onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder:(context)=> FormAddPark()));
            }, 
            icon: Icon(Icons.library_add),
            iconSize: 30,
            padding: EdgeInsets.symmetric(horizontal: 20),)
        ],
            ),

            
      
      body:RefreshIndicator(
        onRefresh: () async { 
          //Navigator.push(context,MaterialPageRoute(builder:(context)=> ConsultPark()));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ConsultReservation()));
         },
        child: ListView.builder(
                
        itemCount: docs.length,
        itemBuilder: (BuildContext context , int index){
          return Slidable(
            key: ValueKey(index),
            startActionPane: ActionPane(
              //dismissible: DismissiblePane(onDismissed: (){},),
              motion: ScrollMotion(),
              children: [
                 SlidableAction(
                   
                   onPressed:
                   (BuildContext context){
                     //print(docs[index]["id"]);
                     FirebaseFirestore.instance.collection("reservation").doc(docs[index]["id"]).delete();
                     Navigator.push(context,MaterialPageRoute(builder:(context)=> ConsultReservation()));
                     
                   },
                   
                    
                   
                   backgroundColor: Colors.deepOrange,
                   foregroundColor: Colors.white,
                   icon: Icons.delete,
                   label: 'Delete',
                   
                   
                ),
                SlidableAction(
                   onPressed:(BuildContext context) {
                     print(docs[index]["id"]);
                     Navigator.push(context, MaterialPageRoute(builder:(context)=>  UpdateReservation(name: docs[index]["name"], id: docs[index]["id"],plateNumber:docs[index]["plate_number"],phoneNumber:docs[index]["phone_number"])));
                   } ,
                   backgroundColor: Colors.greenAccent,
                   foregroundColor: Colors.white,
                   icon: Icons.update_outlined,
                   label: 'Update',
                  
                   ),
               ],
            ),
            
            
            child:ListTile(
                  title: Text("name: ${docs[index]['name']} phone_number:${docs[index]["phone_number"]} plate_number:${docs[index]["plate_number"]} start_time:${docs[index]["start_time"]} finish_time :${docs[index]["finish_time"]}" , style: TextStyle(fontSize: 20),),
                   minVerticalPadding: 20,
                  
                   
                  //trailing: Text("Adresse: "+docs[index]['adresse'] ,  style: TextStyle(fontSize: 20)),
                ),
                

            );
        }),
      
    ));
    
    
  }

 

  
}