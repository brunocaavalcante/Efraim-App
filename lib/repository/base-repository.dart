import 'package:cloud_firestore/cloud_firestore.dart';

class BaseRepository {
  BaseRepository._();
  static final BaseRepository _instance = BaseRepository._();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static get() {
    return BaseRepository._instance._firestore;
  }
}
