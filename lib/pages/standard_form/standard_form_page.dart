import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';
import 'package:simple_app/pages/standard_form/standard_form_controller.dart';
import 'package:simple_app/simple_app.dart';
import 'package:simple_app/widgets/standard_form/standard_form.dart';
import 'package:simple_form/simple_form.dart';
import 'package:standard_dialogs/standard_dialogs.dart';

abstract class StandardFormPage<T> extends Component<StandardFormController<T>> {
	
	@override
  	StandardFormController<T> initController(BuildContext context, Module module) => StandardFormController<T>(module);

	@override
	Widget build(BuildContext context, StandardFormController<T> controller) {
		return StandardForm(
			title: buildTitle(context, controller),
			actions: buildActions(context, controller),
			initialValues: (context) => processInitialValues(context, controller),
			buildForm: (context, values, formLayout) => buildForm(context, controller, values, formLayout),
			onSave: (context, values) => processSave(context, controller, values)
		);
	}

	Widget buildTitle(BuildContext context, StandardFormController<T> controller);

	List<Widget> buildActions(BuildContext context, StandardFormController<T> controller) {
		return [];
	}

	Widget buildForm(BuildContext context, StandardFormController<T> controller, ValuesProvider values, FormLayout formLayout);

	Map<String, dynamic> processInitialValues(BuildContext context, StandardFormController<T> controller) {
		return initialValues(context, controller);
	}

	Map<String, dynamic> initialValues(BuildContext context, StandardFormController<T> controller);

	Future<T> processSave(BuildContext context, StandardFormController<T> controller, ValuesProvider values) async {
		return await showAwaitDialog<T>(context, 
			message: Text(SimpleAppLocalization.of(context)[SimpleAppLocalizationEnum.saving]), 
			function: (context, updateMessage) => this.save(context, controller, values.getValues())
		);
	}

	Future<T> save(BuildContext context, StandardFormController<T> controller, Map<String, dynamic> json);
}
