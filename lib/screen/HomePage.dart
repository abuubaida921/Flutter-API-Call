import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> users = [];
  String deviceLocation = '';
  bool isShowList = false;
  bool isShowLocation = false;
  bool is_loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple API Call "),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              InkWell(
                onTap: callUsersFromServer,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      "Load User List from API",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: callMyLocationFromServer,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      "Show My Location from API",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              isShowList
                  ? Flexible(
                      child: Container(
                      child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final name =
                                user['firstName'] + " " + user['lastName'];
                            final email = user['email'];
                            final profile_imgUrl = user['image'];
                            return ListTile(
                              leading: ClipRRect(
                                child: Image.network(profile_imgUrl),
                              ),
                              title: Text(name),
                              subtitle: Text(email),
                            );
                          }),
                    ))
                  : Text(""),
              isShowLocation
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(deviceLocation),
                      ],
                    )
                  : Text(""),
              is_loading
                  ? CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.black,
                    )
                  : Text(""),
            ],
          )),
    );
  }

  Future<void> callUsersFromServer() async {
    setState(() {
      this.isShowLocation = false;
      this.is_loading = true;
    });
    const uRL = "https://dummyjson.com/users";
    final uri = Uri.parse(uRL);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['users'];
      this.is_loading = false;
      this.isShowList = true;
    });
  }

  Future<void> callMyLocationFromServer() async {
    setState(() {
      this.isShowList = false;
      this.is_loading = true;
    });
    const uRL = "http://ip-api.com/json";
    final uri = Uri.parse(uRL);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      this.is_loading = false;
      deviceLocation = "City: " +
          json['city'] +
          "\nCountry: " +
          json['country'] +
          "\nLat: " +
          json['lat'].toString() +
          "\nLon: " +
          json['lon'].toString();
      this.isShowLocation = true;
    });
  }
}
