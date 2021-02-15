import 'package:flutter/material.dart';

class StandardBody extends StatelessWidget {
	static const EdgeInsets defaultPadding = const EdgeInsets.all(5);

	final Widget child;
	final EdgeInsets padding;
	final bool scroll;

	StandardBody({
		@required this.child,
		this.padding = StandardBody.defaultPadding,
		this.scroll = false,
	});

	@override
	Widget build(BuildContext context) {
		Widget widget = Container(
			padding: padding,
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