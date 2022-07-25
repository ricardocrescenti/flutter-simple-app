import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';

class SimpleAppLocalization extends SimpleLocalizations {
	
	static SimpleAppLocalization of(BuildContext context) {
		SimpleAppLocalization? localization = Localizations.of<SimpleAppLocalization>(context, SimpleAppLocalization);
		return localization ?? SimpleAppLocalization(Localizations.localeOf(context));
	}
	
	SimpleAppLocalization(Locale locale) : super(locale);

	@override
	Locale get defaultLocale => const Locale('en');

	@override
	Iterable<Locale> get suportedLocales => const [
		Locale('en'),
		Locale('es'),
		Locale('pt'),
	];

	@override
	Map<String, Map<dynamic, String>> get localizedValues => {
		'en': {
			// standard_form
			SimpleAppLocalizationEnum.saving: 'Saving'
		},
		'es': {
			// standard_form
			SimpleAppLocalizationEnum.saving: 'Guardando'
		},
		'pt': {
			// standard_form
			SimpleAppLocalizationEnum.saving: 'Salvando'
		}
	};

}