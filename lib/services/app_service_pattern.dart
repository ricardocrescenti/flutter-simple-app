import 'package:localstorage/localstorage.dart';

abstract class SimpleLocalStorage {

	LocalStorage? _localStorage;
	LocalStorage? get localStorage => _localStorage;

	Future<bool> initializeCache({String? fileName}) {

		_localStorage = LocalStorage('cache_${(fileName == null || fileName.isEmpty ? runtimeType.toString() : fileName)}.json', null, {});
		return _localStorage!.ready;

	}

}