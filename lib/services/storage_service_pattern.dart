import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:simple_app/simple_app.dart';

abstract class StorageServicePattern extends Service {
  StorageReference _storage;
  StorageReference get storage => _storage;

  LocalStorage _localStorage;
  LocalStorage get localStorage => _localStorage;

  StorageServicePattern(Module module) : super(module) {
    initializeStorage();
  }

  initializeStorage() async {
    final _auth = FirebaseAuth.instance;
    final options = await _auth.app.options;
    final storageBucket = (!options.storageBucket.startsWith('gs://') ? 'gs://' : '') + options.storageBucket;
    _storage = FirebaseStorage(app: _auth.app, storageBucket: storageBucket).ref();
  }

  Future<bool> initializeCache({String fileName}) {
    _localStorage = new LocalStorage('cache_' + (fileName == null || fileName.isEmpty ? this.runtimeType.toString() : fileName) + '.json', null, {});
    return _localStorage.ready;
  }

  Future<String> getPublicUrl(String filePath) async {
    String publicUrl;

    if (_localStorage != null) {
      await _localStorage.ready;
      publicUrl = _localStorage.getItem(filePath);
    }

    publicUrl ??= await _storage.child(filePath).getDownloadURL();

    if (_localStorage != null && publicUrl != null) {
      _localStorage.setItem(filePath, publicUrl);
    }

    return publicUrl;
  }
}