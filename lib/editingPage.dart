import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class editpage extends StatefulWidget {
  const editpage({Key? key, this.id}) : super(key: key);
  final id;

  @override
  _editpageState createState() => _editpageState();
}

class _editpageState extends State<editpage> {

  late TextEditingController name, salary, age;


  @override
  void initState() {
    name = TextEditingController();
    salary = TextEditingController();
    age = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editting details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: getdata(widget.id),
              builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
                if(snapshot.hasData) {
                  if(snapshot.data?.statusCode == 200) {
                    var a_data = jsonDecode(snapshot.data!.body) as Map;
                    var data = a_data['data'] as Map;
                    name.text = data['employee_name'];
                    salary.text = data['employee_salary'].toString();
                    age.text = data['employee_age'].toString();
                    print(data);
                  }
                  else {
                    return Center(child: Text('${snapshot.data?.statusCode} | Too Many Requests',style: TextStyle(fontSize: 20),),);
                  }
                }
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('Edit Details'),
                      SizedBox(height: 30,),
                      TextField(
                        controller: name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            label: Text('Name'),
                            floatingLabelBehavior: FloatingLabelBehavior.auto
                        ),
                      ),
                      SizedBox(height: 30,),
                      TextField(
                        controller: salary,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            label: Text('salary'),
                            floatingLabelBehavior: FloatingLabelBehavior.auto
                        ),
                      ),
                      SizedBox(height: 30,),
                      TextField(
                        controller: age,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            label: Text('age'),
                            floatingLabelBehavior: FloatingLabelBehavior.auto
                        ),
                      ),
                      SizedBox(height: 30,),
                      SizedBox(width: MediaQuery.of(context).size.width,child: ElevatedButton(onPressed: () async {
                        await getupdated();
                        Navigator.pop(context);
                      },child: Text('Update'),),)
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getupdated() async {
    var response = await http.get(Uri.parse('https://dummy.restapiexample.com/public/api/v1/update/21'));
    if(response.statusCode == 200) {
      print(response.body);
      Navigator.pop(context);
    }
    else {
      print(response.statusCode);
    }
  }

  Future<http.Response> getdata(int index) async {
    var response = await http.get(Uri.parse('https://dummy.restapiexample.com/api/v1/employee/$index'));
    return response;
  }
}
