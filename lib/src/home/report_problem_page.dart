import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firestore_service.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  final _descController = TextEditingController();
  String? _department;
  File? _image;
  DateTime? _date;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _submitReport() async {
    await FirestoreService().addReport(
      dept: _department!,
      desc: _descController.text,
      date: _date!,
      image: _image!,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Problem reported successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Problem")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: _department,
              items: ["Sanitation", "EB", "Public Works"]
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => setState(() => _department = v),
              decoration: const InputDecoration(labelText: "Department"),
            ),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: "Short Description")),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera),
              label: const Text("Upload Image"),
            ),
            ElevatedButton(
              onPressed: _submitReport,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
