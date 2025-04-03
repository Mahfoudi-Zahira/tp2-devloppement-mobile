import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateShowPage extends StatefulWidget {
  final Map<String, dynamic> show;

  UpdateShowPage({required this.show});

  @override
  _UpdateShowPageState createState() => _UpdateShowPageState();
}

class _UpdateShowPageState extends State<UpdateShowPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;
  late TextEditingController imageController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.show['title']);
    descriptionController = TextEditingController(text: widget.show['description']);
    categoryController = TextEditingController(text: widget.show['category']);
    imageController = TextEditingController(text: widget.show['image']);
  }

  Future<void> updateShow() async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:5000/shows/${widget.show['id']}'),
      body: jsonEncode({
        'title': titleController.text,
        'description': descriptionController.text,
        'category': categoryController.text,
        'image': imageController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mise à jour réussie !")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la mise à jour")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modifier le show")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Titre")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
            TextField(controller: categoryController, decoration: InputDecoration(labelText: "Catégorie")),
            TextField(controller: imageController, decoration: InputDecoration(labelText: "Image URL")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateShow, child: Text("Mettre à jour")),
          ],
        ),
      ),
    );
  }
}
