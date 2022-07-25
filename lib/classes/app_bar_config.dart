import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarConfig {

	final bool automaticallyImplyLeading;
	final double? elevation;
	final ShapeBorder? shape;
	final Color? backgroundColor;
	final SystemUiOverlayStyle? systemOverlayStyle;
	final IconThemeData? iconTheme;
	final IconThemeData? actionsIconTheme;
	final TextStyle? toolbarTextStyle;
	final TextStyle? titleTextStyle;
	final bool? centerTitle;
	final double? titleSpacing;
	final double? toolbarOpacity;
	final double? bottomOpacity;

	AppBarConfig({
		this.automaticallyImplyLeading = true,
		this.elevation,
		this.shape,
		this.backgroundColor,
		this.systemOverlayStyle,
		this.iconTheme,
		this.actionsIconTheme,
		this.toolbarTextStyle,
		this.titleTextStyle,
		this.centerTitle = true,
		this.titleSpacing = NavigationToolbar.kMiddleSpacing,
		this.toolbarOpacity = 1.0,
		this.bottomOpacity = 1.0
	});

}