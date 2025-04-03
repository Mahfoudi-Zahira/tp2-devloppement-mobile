import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'update_show.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> shows = [];

  @override
  void initState() {
    super.initState();
    fetchShows();
  }

  Future<void> fetchShows() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/shows'));

    if (response.statusCode == 200) {
      setState(() {
        shows = jsonDecode(response.body);
      });
    }
  }

  void refreshPage() {
    fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des Shows")),
      body: RefreshIndicator(
        onRefresh: fetchShows,
        child: ListView.builder(
          itemCount: shows.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(shows[index]['title']),
              subtitle: Text(shows[index]['category']),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateShowPage(show: shows[index]),
                    ),
                  );
                  if (result == true) {
                    refreshPage();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
