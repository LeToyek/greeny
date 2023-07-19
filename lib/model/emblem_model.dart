import 'package:cloud_firestore/cloud_firestore.dart';

class EmblemModel {
  final String id;
  final String description;
  final String imageUrl;
  final int counter;
  static CollectionReference ref =
      FirebaseFirestore.instance.collection('emblems');

  EmblemModel({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.counter,
  });

  EmblemModel.fromQuery(DocumentSnapshot<Object?> query)
      : id = query.id,
        description = query['description'],
        imageUrl = query['image_url'],
        counter = query['max_count'];
}
