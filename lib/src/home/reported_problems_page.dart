import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportedProblemsPage extends StatelessWidget {
  const ReportedProblemsPage({super.key});

  Future<void> _upvote(String docId, int currentVotes) async {
    final ref = FirebaseFirestore.instance.collection("reports").doc(docId);
    await ref.update({"upvotes": currentVotes + 1});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reported Problems")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("reports")
            .orderBy("upvotes", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No problems reported yet."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final data = docs[i].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: data["imageUrl"] != null
                      ? Image.network(data["imageUrl"], width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  title: Text(data["description"] ?? "No description"),
                  subtitle: Text("Dept: ${data["department"]} | Upvotes: ${data["upvotes"] ?? 0}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.thumb_up),
                    onPressed: () => _upvote(docs[i].id, data["upvotes"] ?? 0),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
