import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:simple_app/simple_app.dart';

abstract class StorageServicePattern extends Service {
  StorageReference _storage;
  StorageReference get storage => _storage;

  StorageServicePattern(Module module) : super(module) {
    initializeStorage();
  }

  initializeStorage() async {
    final _auth = FirebaseAuth.instance;
    final options = await _auth.app.options;
    final storageBucket = (!options.storageBucket.startsWith('gs://') ? 'gs://' : '') + options.storageBucket;
    _storage = FirebaseStorage(app: _auth.app, storageBucket: storageBucket).ref();
  }
}