import 'package:flutter/material.dart';

class StandardBody extends StatelessWidget {

	static EdgeInsets defaultPadding = const EdgeInsets.all(10);

	final EdgeInsets? padding;
	final bool scroll;
	final Widget child;

	const StandardBody({
		Key? key,
		this.padding,
		this.scroll = false,
		required this.child,
	}): super(key: key);

	@override
	Widget build(BuildContext context) {

		Widget widget = Container(
			padding: padding ?? StandardBody.defaultPadding,
			child: child
		);

		if (scroll) {
			widget = SingleChildScrollView(
				child: widget,
			);
		}

		return widget;

	}
}