import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';
import 'package:simple_app/simple_app.dart';
import 'package:simple_app/widgets/standard_form/standard_form.dart';
import 'package:simple_form/simple_form.dart';
import 'package:standard_dialogs/standard_dialogs.dart';

abstract class StandardFormPage<T> extends Component {

	@override
	Widget build(BuildContext context, Controller controller) {
		return StandardForm(
			title: buildTitle(context, controller),
			actions: buildActions(context, controller),
			initialValues: (context) => initialValues(context, controller),
			buildForm: (context, values, formLayout) => buildForm(context, controller, values, formLayout),
			onSave: (context, values) => processSave(context, controller, values)
		);
	}

	Widget buildTitle(BuildContext context, Controller controller);

	List<Widget> buildActions(BuildContext context, Controller controller) {
		return [];
	}

	Widget buildForm(BuildContext context, Controller controller, ValuesProvider values, FormLayout formLayout);

	Map<String, dynamic> processInitialValues(BuildContext context, Controller controller) {
		return initialValues(context, controller);
	}

	Map<String, dynamic> initialValues(BuildContext context, Controller controller);

	Future<T> processSave(BuildContext context, Controller controller, ValuesProvider values) async {
		return await showAwaitDialog<T>(context, 
			message: Text(SimpleAppLocalization.of(context)[SimpleAppLocalizationEnum.saving]), 
			function: (context, updateMessage) => this.save(context, controller, values.getValues())
		);
	}

	Future<T> save(BuildContext context, Controller controller, Map<String, dynamic> json);
}
