import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';

class StandardList<T> extends StatefulWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget drawer;
  final EdgeInsets padding;
  final Future<List<T>> Function(BuildContext context) loadItems;
  final bool canRetryLoadOnError;
  final Widget Function(BuildContext context, T item) buildItem;
  final T Function(BuildContext context, ListProvider<T> items) onInsert;
  final T Function(BuildContext context, ListProvider<T> items, T item) onTap;
  final T Function(BuildContext context, ListProvider<T> items, T item) onLongPress;
  final Future<dynamic> Function(BuildContext context, Object error) processError;

  StandardList({
	@required this.title,
	this.actions,
	this.drawer,
	this.padding = const EdgeInsets.symmetric(vertical: 10),
	@required this.loadItems,
	this.canRetryLoadOnError = true,
	@required this.buildItem,
	this.onInsert,
	this.onTap,
	this.onLongPress,
	this.processError
  });

  @override
  State<StatefulWidget> createState() => _StandardListState<T>();
}

class _StandardListState<T> extends State<StandardList<T>> {
	ListProvider<T> _items = ListProvider();

	@override
	void initState() {
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: StandardApp.appBar(context, 
				title: widget.title, 
				actions: widget.actions
			),
			drawer: widget.drawer,
			body: FutureWidget<void>(
				load: (context) => _loadItems(context),
				allowRetry: true,
				builder: (context, items) => _buildBody()
			),
		);
	}

	_buildBody() {
		return ListConsumer(
			list: _items, 
			builder: (context, items) {

				return ListView.separated(
					padding: EdgeInsets.symmetric(vertical: 10),
					itemBuilder: (context, index) => _buildItem(context, items[index]), 
					separatorBuilder: (context, index) => Divider(), 
					itemCount: items.length
				);

			}
		);
	}

	_buildItem(BuildContext context, T item) {
		return GestureDetector(
			onLongPress: (widget.onLongPress != null ? () => widget.onLongPress(context, _items, item) : null),
			onTap: (widget.onTap != null ? () => widget.onTap(context, _items, item) : null),
			child: widget.buildItem(context, item),
		);
	}

	_loadItems(BuildContext context) async {
		List<T> items = await widget.loadItems(context);
		_items.clearAddAll(items);
	}
}