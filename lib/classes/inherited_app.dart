import 'package:flutter/widgets.dart';
import 'package:simple_app/simple_app.dart';

/// This class is used on `build()` method of the `Module` to pass the module
/// reference to its descendants
class InheritedApp extends InheritedWidget {

	final StandardApp app;

	const InheritedApp({
		Key? key, 
		required this.app, 
		required Widget child 
	}) : super(key: key, child: child);
		
	@override
	bool updateShouldNotify(InheritedWidget oldWidget) => true;

}