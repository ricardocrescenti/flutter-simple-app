import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';

class StandardList<T> extends StatefulWidget {
  static EdgeInsets defaultPadding = const EdgeInsets.all(10);

  final AppBar appBar;
  final Widget drawer;
  //final EdgeInsets padding;
  final ListProvider<T> items;
  final Future<List<T>> Function(BuildContext context) loadItems;
  final bool canRetryLoadOnError;
  final EdgeInsets padding;
  final Widget Function(BuildContext context) buildEmptyPage;
  final Widget Function(BuildContext context, T item) buildItem;
  final Widget Function(BuildContext context) buildSeparator;
  //final T Function(BuildContext context, ListProvider<T> items) onInsert;
  //final T Function(BuildContext context, ListProvider<T> items, T item) onTap;
  //final T Function(BuildContext context, ListProvider<T> items, T item) onLongPress;
  //final Future<dynamic> Function(BuildContext context, Object error) processError;

  StandardList({
	this.appBar,
	this.drawer,
	//this.padding = const EdgeInsets.symmetric(vertical: 10),
	this.items,
	this.loadItems,
	this.canRetryLoadOnError = true,
  	this.padding,
	this.buildEmptyPage,
	@required this.buildItem,
	this.buildSeparator,
	//this.onInsert,
	//this.onTap,
	//this.onLongPress,
	//this.processError
  }) {
	  assert(items != null || loadItems != null);
  }

  @override
  State<StatefulWidget> createState() => _StandardListState<T>();
}

class _StandardListState<T> extends State<StandardList<T>> {
	ListProvider<T> items;
	Future<void> futureLoad;

	@override
	void initState() {
		super.initState();
		items = widget.items ?? ListProvider<T>();
 		futureLoad = _loadItems(context);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: widget.appBar,
			drawer: widget.drawer,
			body: FutureWidget<void>(
				future: futureLoad,
				retry: (context) => _retry(context),
				builder: (context, items) => _buildBody(context)
			),
		);
	}

	Widget _buildBody(BuildContext context) {
		return ListConsumer<T>(
			list: items, 
			builder: (context, items) {

				if (items.length == 0) {
					return widget.buildEmptyPage != null
						? widget.buildEmptyPage(context)
						: Container();
				}

				return ListView.separated(
					padding: widget.padding ?? StandardList.defaultPadding,
					itemBuilder: (context, index) => widget.buildItem(context, items[index]), 
					separatorBuilder: (context, index) => (widget.buildSeparator != null ? widget.buildSeparator(context) : Container()),
					itemCount: items.length
				);

			}
		);
	}

	// Widget _buildItem(BuildContext context, T item) {
	// 	return GestureDetector(
	// 		onLongPress: (widget.onLongPress != null ? () => widget.onLongPress(context, _items, item) : null),
	// 		onTap: (widget.onTap != null ? () => widget.onTap(context, _items, item) : null),
	// 		child: widget.buildItem(context, item),
	// 	);
	// }

	Future<void> _loadItems(BuildContext context) async {
		if (widget.loadItems == null) {
			return Future.value();
		}
		items.clearAddAll(await widget.loadItems(context));
	}

	Future<void> _retry(BuildContext context) {
		futureLoad = _loadItems(context);
		setState(() {});
		return futureLoad;
	}
}