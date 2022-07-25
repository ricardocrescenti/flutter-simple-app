// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_app/simple_app.dart';

class SplashScreenPage extends StatefulWidget {

	final int secondsAwait;
	final Widget Function(BuildContext context)? logo;
	final Widget Function(BuildContext context)? title;
	final BoxDecoration Function(BuildContext context)? background;
	final Future<String> Function(BuildContext context)? load;

	const SplashScreenPage({
		Key? key,
		this.secondsAwait = 3,
		this.logo,
		this.title,
		this.background,
		this.load,
	}): super(key: key);

	@override
	State<StatefulWidget> createState() => _SplashScreenPageState();

}

class _SplashScreenPageState extends State<SplashScreenPage> {

	Future? _futureLoad;
	late Future<PackageInfo> packageInfo;
	
	@override
	void initState() {

		super.initState();
		packageInfo = StandardApp.packageInfo;

	}

	@override
	void didChangeDependencies() {

		super.didChangeDependencies();
		_futureLoad ??= _startLoad(context);

	}

	@override
	Widget build(BuildContext context) {

		StandardApp standardApp = StandardApp.of(context);
		ThemeData themeData = Theme.of(context);
		
		List<Widget> childs = [];

		if (widget.logo != null || standardApp.logo != null) {
			childs.add(Expanded(
				child: (widget.logo != null ? widget.logo!(context) : standardApp.logo!(context))
			));
		}

		childs.add(Padding(
			padding: EdgeInsets.only(top: (childs.isNotEmpty ? 15 : 0)),
			child: (widget.title != null ? widget.title!(context) : Text(standardApp.title(context), style: Theme.of(context).primaryTextTheme.subtitle2))
		));
		
		childs.add(Padding(
			padding: EdgeInsets.only(top: 5, bottom: (childs.isNotEmpty ? 15 : 0)),
			child: FutureWidget<PackageInfo>(
				future: packageInfo, 
				awaitWidget: (context) => Container(),
				builder: (context, packageInfo) => Text(packageInfo!.version, style: Theme.of(context).primaryTextTheme.caption!.copyWith(color: Theme.of(context).primaryTextTheme.subtitle2!.color), textScaleFactor: 0.7))
			)
		);

		return Scaffold(
			backgroundColor: themeData.colorScheme.primary,
			body: Container(
				decoration: _buildBackground(context, standardApp),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: childs,
					)
				]),
			)
		);

	}

	Decoration? _buildBackground(BuildContext context, StandardApp standardApp) {

		if (widget.background != null || standardApp.background != null) {
			return (widget.background != null ? widget.background!(context) : standardApp.background!(context));
		}

		return null;
	}

	Future<void> _startLoad(BuildContext context) async {

		StandardApp? standardApp = StandardApp.of(context);

		await standardApp.configFilesLoaded;

		Future<String> futureLoad = (widget.load != null
			? widget.load!(context)
			: Future.value(standardApp.defaultRoute));
		Future<String> futureSeconds = Future.delayed(Duration(seconds: widget.secondsAwait), () => '');

		Future.wait<String>([futureLoad, futureSeconds]).then((routeName) => Navigator.pushReplacementNamed(context, routeName[0]));

	}

}