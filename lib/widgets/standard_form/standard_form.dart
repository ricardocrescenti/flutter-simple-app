import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';

class StandardForm extends StatefulWidget {

	static EdgeInsets defaultPadding = const EdgeInsets.all(15);

	final Widget? title;
	final List<Widget>? actions;
	final EdgeInsets? padding;
	final bool scroll;
	final bool popOnSave;
	final MapProvider<String, dynamic> Function(BuildContext context) initialValues;
	final Widget Function(BuildContext context, MapProvider formValues, FormLayout formLayout) buildForm;
	final Widget? bottomButtonChild;
	final Future<bool> Function(BuildContext context, MapProvider formValues)? onValidate;
	final Future<dynamic> Function(BuildContext context, MapProvider formValues)? onSave;
	final Future<dynamic> Function(BuildContext context, Object error)? processError;

	const StandardForm({
		Key? key,
		this.title,
		this.actions,
		this.padding,
		this.scroll = true,
		this.popOnSave = true,
		required this.initialValues,
		required this.buildForm,
		this.bottomButtonChild,
		this.onValidate,
		this.onSave,
		this.processError
	}): super(key: key);

	@override
	State<StatefulWidget> createState() => _StandardFormState();

}

class _StandardFormState extends State<StandardForm> {

	bool valueInitialized = false;
	late MapProvider<String, dynamic> formValues;
	GlobalKey<FormState> formState = GlobalKey();

	@override
	void didChangeDependencies() {

		super.didChangeDependencies();

		if (!valueInitialized) {
			formValues = widget.initialValues(context);
		}

	}

	@override
	Widget build(BuildContext context) {

		return Scaffold(
			appBar: _buildAppBar(context),
			body: _buildBody(),
			bottomNavigationBar: _buildBottomButton(context),
		);

	}

	_buildAppBar(BuildContext context) {

		if (widget.title == null) {
			return null;
		}

		return StandardApp.defaultAppBar(context, 
			title: widget.title,
			actions: widget.actions);

	}

	_buildBody() {

		return SimpleForm(
			formStateKey: formState,
			initialValues: Map.castFrom(formValues),
			onChange: (field, newValue) => formValues.setValue(field, newValue),
			child: FormLayout(
				padding: widget.padding ?? StandardForm.defaultPadding,
				scroll: widget.scroll,
				builder: (formLayout) => widget.buildForm(context, formValues, formLayout),
			)
		);

	}

	_buildBottomButton(BuildContext context) {

		if (widget.onSave == null) {
			return null;
		}
		
		return BottomButton(
			child: widget.bottomButtonChild ?? const Text('SALVAR'),
			onPressed: () => _save(context),
		);

	}

	_save(BuildContext context) async {

		if (formState.currentState == null || !formState.currentState!.validate()) {
			return;
		}

		if (widget.onValidate != null && !await widget.onValidate!(context, formValues)) {
			return;
		}

		showAwaitDialog(context, message: Text(SimpleAppLocalization.of(context)[SimpleAppLocalizationEnum.saving]), function: (context, updateMessage) async {
	
			return widget.onSave!(context, formValues)
				.catchError((onError) async {
					if (widget.processError != null) {
						await widget.processError!(context, onError);
					}
				});

		}).then((savedData) {
	
			if (widget.popOnSave && savedData != null) {
				Navigator.pop(context, savedData);
			}

		});

	}
}