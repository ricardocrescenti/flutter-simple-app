import 'package:flutter/material.dart';

class StandardBody extends StatelessWidget {
	static const EdgeInsets defaultPadding = const EdgeInsets.all(5);

	final EdgeInsets padding;
	final bool scroll;
	final Widget child;

	StandardBody({
		this.padding = StandardBody.defaultPadding,
		this.scroll = false,
		@required this.child,
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