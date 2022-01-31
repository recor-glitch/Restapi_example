import 'dart:convert';
import 'package:demo_vayug/editingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class retrivelist extends StatefulWidget {
  const retrivelist({Key? key}) : super(key: key);

  @override
  _retrivelistState createState() => _retrivelistState();
}

class _retrivelistState extends State<retrivelist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Listing'),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getlist(),
          builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
            if(snapshot.hasData) {
              if(snapshot.data?.statusCode == 200) {
                var a_data = jsonDecode(snapshot.data!.body) as Map;
                var data = a_data['data'] as List;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(data[index]['employee_name']),
                        trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => editpage(id: data[index]['id'],),
                              ));
                        },)
                    );
                  },);
              }
              else {
                return Center(child: Text('${snapshot.data?.statusCode} | Too Many Requests',style: TextStyle(fontSize: 20),),);
              }
            }
            return Center(child: CircularProgressIndicator(),);
          },),
      )
    );
  }


  Future<http.Response> getlist() async {
    var response = await http.get(Uri.parse('https://dummy.restapiexample.com/api/v1/employees'));
    return response;
  }
}
