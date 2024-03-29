import 'package:flutter/material.dart';
import 'package:simple_app/simple_app.dart';

class StandardList<T> extends StatefulWidget {
	static EdgeInsets defaultPadding = const EdgeInsets.symmetric(vertical: 15);
	static EdgeInsets defaultItemPadding = const EdgeInsets.symmetric(horizontal: 15);

	final AppBar? appBar;
	final Widget? drawer;
	//final EdgeInsets padding;
	final ListProvider<T>? items;
	final Future<List<T>> Function(BuildContext context)? loadItems;
	final bool canRetryLoadOnError;
	final EdgeInsets? padding;
	final EdgeInsets? itemPadding;
	final Widget Function(BuildContext context)? buildEmptyPage;
	final Widget Function(BuildContext context, ListProvider<T> item, Widget Function(BuildContext context, int index, T item) buildItem)? buildItems;
	final Widget Function(BuildContext context, int index, T? item) buildItem;
	final Widget Function(BuildContext context, int index, T? item)? buildSeparator;
	//final T Function(BuildContext context, ListProvider<T> items) onInsert;
	//final T Function(BuildContext context, ListProvider<T> items, T item) onTap;
	//final T Function(BuildContext context, ListProvider<T> items, T item) onLongPress;
	//final Future<dynamic> Function(BuildContext context, Object error) processError;

	const StandardList({
		Key? key,
		this.appBar,
		this.drawer,
		this.items,
		this.loadItems,
		this.canRetryLoadOnError = true,
		this.padding,
		this.itemPadding,
		this.buildEmptyPage,
		this.buildItems,
		required this.buildItem,
		this.buildSeparator,
	}): super(key: key);

	@override
	State<StatefulWidget> createState() => _StandardListState<T>();

}

class _StandardListState<T> extends State<StandardList<T>> {

	late ListProvider<T> items;
	late Future<void> futureLoad;

	@override
	void initState() {

		super.initState();
		items = widget.items ?? ListProvider<T>();
 		futureLoad = _loadItems(context);

	}

	@override
	Widget build(BuildContext context) {

		assert(widget.items != null || widget.loadItems != null);

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

				if (items.isEmpty) {
					return widget.buildEmptyPage != null
						? widget.buildEmptyPage!(context)
						: Container();
				}

				return _buildItems(context);

			}
		);

	}

	Widget _buildItems(BuildContext context) {

		if (widget.buildItems != null) {
			return widget.buildItems!(context, items, _buildItem);
		}

		return ListView.separated(
			padding: widget.padding ?? StandardList.defaultPadding,
			itemBuilder: (context, index) => _buildItem(context, index, items[index]), 
			separatorBuilder: (context, index) => _buildSeparator(context, index, items[index]),
			itemCount: items.length
		);

	}

	Widget _buildItem(BuildContext context, int index, T? item) {

		return Padding(
			padding: widget.itemPadding ?? StandardList.defaultItemPadding,
			child: widget.buildItem(context, index, item)
		);

	}

	Widget _buildSeparator(BuildContext context, int index, T? item) {

		if (widget.buildSeparator == null) {
			return Container();
		}

		return widget.buildSeparator!(context, index, item);

	}

	Future<void> _loadItems(BuildContext context) async {

		if (widget.loadItems == null) {
			return Future.value();
		}

		items.clearAddAll(await widget.loadItems!(context));

	}

	Future<void> _retry(BuildContext context) {

		futureLoad = _loadItems(context);
		setState(() {});
		return futureLoad;

	}

}