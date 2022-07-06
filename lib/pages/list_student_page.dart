import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cruid/pages/update_student_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListStudentPage extends StatefulWidget {

  @override
  State<ListStudentPage> createState() => _ListStudentPageState();
}

class _ListStudentPageState extends State<ListStudentPage> {

  final Stream<QuerySnapshot> studentsStream = FirebaseFirestore.instance.collection('students').snapshots();

  CollectionReference students = FirebaseFirestore.instance.collection('students');

  Future <void> deleteUser(id){
    print('User Deleted$id');

    return students.doc(id).delete()
    .then((value) => print('User Deleted'))
    .catchError((Error)=>print('failed to delete user : $Error'));

  }
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(stream: studentsStream,builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if(snapshot.hasError){
        print('Something Went Wrong');
      }
      if(snapshot.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
      }
      final List storedocs =[];       //taking data out from the DB in docs
      snapshot.data!.docs.map((DocumentSnapshot documents) {
        Map a =documents.data() as Map <String ,dynamic>;
        storedocs.add(a);
        a['id']=documents.id;
      }).toList();

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                border: TableBorder.all(),
                columnWidths: const <int, TableColumnWidth>{
                  1: FixedColumnWidth(140),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children: [
                    TableCell(
                        child: Container(
                      color: Colors.greenAccent,
                      child: Center(
                        child: Text(
                          "Name",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                    TableCell(
                        child: Container(
                      color: Colors.greenAccent,
                      child: Center(
                        child: Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                    TableCell(
                        child: Container(
                      color: Colors.greenAccent,
                      child: Center(
                        child: Text(
                          "Actions",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
                  ]),
                  for(var i=0;i<storedocs.length;i++)...[
                  TableRow(children: [
                    TableCell(
                        child: Container(
                      child: Center(
                        child: Text(
                          storedocs[i]['name'],
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    )),
                    TableCell(
                        child: Container(
                      child: Center(
                        child: Text(
                          storedocs[i]['email'],
                          style: TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    )),
                    TableCell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateStudentPage(id:storedocs[i]['id'])))
                                  },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.orange,
                              )),
                          IconButton(
                              onPressed: () => {
                                deleteUser(storedocs[i]['id'])
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.orange,
                              ))
                        ],
                      ),
                    )
                  ]
                  )
                  ],
                ],
              ),
            ),
          );
    });

  }
}