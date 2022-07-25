import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_app/simple_app.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;

Map<String, Map> _configs = {};
Future<Map<String, Map>>? _futureLoadConfig;

class StandardApp extends StatefulWidget {

	static StandardApp of(BuildContext context) {

		InheritedApp? inheritedApp = context.dependOnInheritedWidgetOfExactType<InheritedApp>();
		return inheritedApp!.app;

	}

	final String Function(BuildContext context) title;
	final Widget Function(BuildContext context)? logo;
	final BoxDecoration Function(BuildContext context)? background;
	final Locale? locale;
	final Iterable<Locale> supportedLocales;
	final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
	final ThemeMode? themeMode;
	final ThemeData? theme;
	final ThemeData? darkTheme;
	final AppBarConfig? Function(BuildContext context)? appBarConfig;
	final Widget Function(BuildContext context)? home;
	final String? defaultRoute;
	/// lista os json files with configurations
	final List<String>? configFiles;

	// static Route _mainRoute;
	// static Route get mainRoute => _mainRoute;

	static Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();

	Future<Map<String, Map>>? get configFilesLoaded {
		return _futureLoadConfig;
	}

	const StandardApp({
		Key? key,
		required this.title,
		this.logo,
		this.background,
		this.locale,
		required this.supportedLocales,
		this.localizationsDelegates,
		this.themeMode = ThemeMode.system,
		this.theme,
		this.darkTheme,
		this.appBarConfig,
		this.home,
		this.defaultRoute,
		this.configFiles
	}): super(key: key);

	@override
	State<StatefulWidget> createState() => _StandardApp();

	// static navigateToMainRoute(BuildContext context, String mainRoute) {
	//   Navigator.of(context, rootNavigator: true).popUntil((route) {
	//     return route.isFirst;
	//   });
	//   if (mainRoute != StandardApp.mainRoute.settings.name) {
	//     Navigator.of(context, rootNavigator: true).pushReplacementNamed(mainRoute);
	//   }
	// }

	static Map? config(String configName) {
		return _configs[configName];
	}

	static AppBar defaultAppBar(BuildContext context, {
		Widget? leading,
		bool? automaticallyImplyLeading,
		Widget? title,
		List<Widget>? actions,
		Widget? flexibleSpace,
		PreferredSizeWidget? bottom,
		double? elevation,
		ShapeBorder? shape,
		Color? backgroundColor,
		SystemUiOverlayStyle? systemOverlayStyle,
		IconThemeData? iconTheme,
		IconThemeData? actionsIconTheme,
		TextStyle? toolbarTextStyle,
		TextStyle? titleTextStyle,
		bool? primary,
		bool? centerTitle,
		double? titleSpacing,
		double? toolbarOpacity,
		double? bottomOpacity,
	}) {

		StandardApp standardApp = of(context);
		AppBarConfig? appBarConfig = (standardApp.appBarConfig != null ? standardApp.appBarConfig!(context) : null);

		return AppBar(
			leading: leading,
			automaticallyImplyLeading: (automaticallyImplyLeading ?? appBarConfig?.automaticallyImplyLeading ?? true),
			title: title,
			actions: actions,
			flexibleSpace: flexibleSpace,
			bottom: bottom,
			elevation: (elevation ?? appBarConfig?.elevation),
			shape: (shape ?? appBarConfig?.shape),
			backgroundColor: (backgroundColor ?? appBarConfig?.backgroundColor),
			systemOverlayStyle: (systemOverlayStyle ?? appBarConfig?.systemOverlayStyle),
			iconTheme: (iconTheme ?? appBarConfig?.iconTheme),
			actionsIconTheme: (actionsIconTheme ?? appBarConfig?.actionsIconTheme),
			toolbarTextStyle: (toolbarTextStyle ?? appBarConfig?.toolbarTextStyle),
			titleTextStyle: (titleTextStyle ?? appBarConfig?.titleTextStyle),
			primary: (primary ?? true),
			centerTitle: (centerTitle ?? appBarConfig?.centerTitle),
			titleSpacing: (titleSpacing ?? appBarConfig?.titleSpacing ?? NavigationToolbar.kMiddleSpacing),
			toolbarOpacity: (toolbarOpacity ?? appBarConfig?.toolbarOpacity ?? 1.0),
			bottomOpacity: (bottomOpacity ?? appBarConfig?.bottomOpacity ?? 1.0),
		);
	
	}

	static SliverAppBar defaultSliverAppBar(BuildContext context, {
		Widget? leading,
		bool? automaticallyImplyLeading,
		Widget? title,
		List<Widget>? actions,
		Widget? flexibleSpace,
		PreferredSizeWidget? bottom,
		double? elevation,
		ShapeBorder? shape,
		Color? shadowColor,
		bool? forceElevated,
		Color? backgroundColor,
		SystemUiOverlayStyle? systemOverlayStyle,
		IconThemeData? iconTheme,
		IconThemeData? actionsIconTheme,
		TextStyle? toolbarTextStyle,
		TextStyle? titleTextStyle,
		bool primary = true,
		bool? centerTitle,
		bool? excludeHeaderSemantics,
		double? titleSpacing,
		double? collapsedHeight,
		double? expandedHeight,
		bool floating = false,
		bool pinned = false,
		bool snap = false,
		bool stretch = false,
		double stretchTriggerOffset = 100.0,
		AsyncCallback? onStretchTrigger,
		double toolbarHeight = kToolbarHeight,
		double? leadingWidth,
	}) {

		StandardApp standardApp = of(context);
		AppBarConfig? appBarConfig = (standardApp.appBarConfig != null ? standardApp.appBarConfig!(context) : null);

		return SliverAppBar(
			leading: leading,
			automaticallyImplyLeading: (automaticallyImplyLeading ?? appBarConfig?.automaticallyImplyLeading ?? true),
			title: title,
			actions: actions,
			flexibleSpace: flexibleSpace,
			bottom: bottom,
			elevation: (elevation ?? appBarConfig?.elevation),
			shape: (shape ?? appBarConfig?.shape),
			shadowColor: shadowColor,
			forceElevated: (forceElevated ?? false),
			backgroundColor: (backgroundColor ?? appBarConfig?.backgroundColor),
			systemOverlayStyle: (systemOverlayStyle ?? appBarConfig?.systemOverlayStyle),
			iconTheme: (iconTheme ?? appBarConfig?.iconTheme),
			actionsIconTheme: (actionsIconTheme ?? appBarConfig?.actionsIconTheme),
			toolbarTextStyle: (toolbarTextStyle ?? appBarConfig?.toolbarTextStyle),
			titleTextStyle: (titleTextStyle ?? appBarConfig?.titleTextStyle),
			primary: primary,
			centerTitle: (centerTitle ?? appBarConfig?.centerTitle),
			excludeHeaderSemantics: (excludeHeaderSemantics ?? false),
			titleSpacing: (titleSpacing ?? appBarConfig?.titleSpacing ?? NavigationToolbar.kMiddleSpacing),
			collapsedHeight: collapsedHeight,
			expandedHeight: expandedHeight,
			floating: floating,
			pinned: pinned,
			snap: snap,
			stretch: stretch,
			stretchTriggerOffset: stretchTriggerOffset,
			onStretchTrigger: onStretchTrigger,
			toolbarHeight: toolbarHeight,
			leadingWidth: leadingWidth
		);

	}
}

class _StandardApp extends State<StandardApp> {

	@override
	void initState() {

		super.initState();

		if (widget.configFiles != null) {
			_futureLoadConfig = _loadConfigFiles(widget.configFiles!);
		}

	}

	@override
	Widget build(BuildContext context) {

		return InheritedApp(
			app: widget,
			child: MaterialApp(
				onGenerateTitle: widget.title,
				locale: widget.locale,
				supportedLocales: widget.supportedLocales,
				localizationsDelegates: [
					GlobalMaterialLocalizations.delegate,
					GlobalCupertinoLocalizations.delegate,
					GlobalWidgetsLocalizations.delegate,
					...(widget.localizationsDelegates ?? [])
				],
				themeMode: widget.themeMode,
				theme: widget.theme,
				darkTheme: widget.darkTheme,
				home: (widget.home != null 
					? widget.home!(context)
					: const SplashScreenPage()),
				onGenerateRoute: Module.onGenerateRoute,
				// navigatorObservers: [RouterObserver(
				//   onPush: (route, previousRoute) { if (previousRoute == null) _onChangeMainRoute(route); },
				//   onReplace: (newRoute, previousRoute) => _onChangeMainRoute(newRoute)
				// )],
			)
		);

	}

	// _onChangeMainRoute(Route route) {
	//   StandardApp._mainRoute = route;
	// }

	Future<Map<String, Map>>? _loadConfigFiles(List<String> configFiles) async {

		for (String configFile in widget.configFiles ?? []) {
			
			String fileName = configFile.substring(0, configFile.lastIndexOf('.')).split('/').last;
			String fileText = await rootBundle.loadString(configFile);
			_configs[fileName] = jsonDecode(fileText);
			
		}
		return _configs;

	}

}