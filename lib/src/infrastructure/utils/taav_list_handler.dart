import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_ui/taav_ui.dart';

import 'filter_helper.dart';

abstract class _TaavListBaseHandler<T, S extends State> {
  _TaavListBaseHandler({
    this.hasPagination = true,
    this.limit = 10,
  });

  int _offset = 0;
  final bool hasPagination;
  final int limit;
  final RxBool hasMoreData = true.obs;
  final RxBool showError = false.obs;
  final List<T> list = <T>[];
  final FilterHelper filterHelper = FilterHelper();
  final GlobalKey<S> key = GlobalKey<S>();

  void _clearItemsByKey();

  void _removeItemByKey(final int index);

  void _addItemsByKey(
    final List<T> items, {
    required final bool withAnimation,
  });

  void _addItemByKey(
    final T item, {
    required final bool withAnimation,
    final int? atIndex,
  });

  void _editItemByKey({
    required final T item,
    required final int index,
  });

  bool _isKeyAvailable();

  ///Call this method before sending request to server.
  void prepare({required final bool resetData}) {
    showError.value = false;
    hasMoreData.value = true;
    if (resetData) {
      _offset = 0;
      clearItems();
    }
  }

  ///Call this method after getting error response from server.
  void onError() => showError.value = true;

  ///Call this method after getting success response from server.
  void onSuccess({
    required final List<T> items,
    final bool withAnimation = true,
  }) {
    addItems(
      items,
      withAnimation: withAnimation,
    );
    if (hasPagination) {
      _offset++;
    }
    hasMoreData.value = hasPagination && items.length >= limit;
    showError.value = false;
  }

  void addItems(final List<T> items, {final bool withAnimation = true}) {
    if (_isKeyAvailable()) {
      _addItemsByKey(items, withAnimation: withAnimation);
    } else {
      list.addAll(items);
    }
  }

  void addItem(
    final T item, {
    final int? atIndex,
    final bool withAnimation = true,
  }) {
    if (_isKeyAvailable()) {
      _addItemByKey(
        item,
        atIndex: atIndex,
        withAnimation: withAnimation,
      );
    } else {
      list.insert(atIndex ?? list.length, item);
    }
  }

  void removeAt(final int index) {
    if (_isKeyAvailable()) {
      _removeItemByKey(index);
    } else {
      list.removeAt(index);
    }
  }

  void clearItems() {
    if (_isKeyAvailable()) {
      _clearItemsByKey();
    } else {
      list.clear();
    }
  }

  void editItem({
    required final T item,
    required final int index,
  }) {
    if (_isKeyAvailable()) {
      _editItemByKey(item: item, index: index);
    } else {
      list[index] = item;
    }
  }

  String get query {
    if (hasPagination) {
      filterHelper
          .add(EqualFilterModel(key: 'limit', value: limit.toString()));
      filterHelper
          .add(EqualFilterModel(key: 'offset', value: _offset.toString()));
    }

    return filterHelper.query();
  }
}

class TaavListViewHandler<T>
    extends _TaavListBaseHandler<T, TaavListViewState<T>> {
  TaavListViewHandler({
    super.limit,
    super.hasPagination,
  });

  @override
  void _clearItemsByKey() {
    key.currentState?.clearAllItems();
  }

  @override
  void _addItemsByKey(
    final List<T> items, {
    required final bool withAnimation,
  }) {
    key.currentState?.addAll(items, withAnimation: withAnimation);
  }

  @override
  void _addItemByKey(
    final T item, {
    required final bool withAnimation,
    final int? atIndex,
  }) {
    key.currentState?.addItem(
      item,
      atIndex: atIndex,
      withAnimation: withAnimation,
    );
  }

  @override
  void _removeItemByKey(final int index) {
    key.currentState?.removeItemAt(index);
  }

  @override
  void _editItemByKey({
    required final T item,
    required final int index,
  }) {
    key.currentState?[index] = item;
  }

  @override
  bool _isKeyAvailable() => key.currentState != null;
}

class TaavGridViewHandler<T>
    extends _TaavListBaseHandler<T, TaavGridViewState<T>> {
  TaavGridViewHandler({
    super.limit,
    super.hasPagination,
  });

  @override
  void _clearItemsByKey() {
    key.currentState?.clearAllItems();
  }

  @override
  void _addItemsByKey(
    final List<T> items, {
    required final bool withAnimation,
  }) {
    key.currentState?.addAll(items, withAnimation: withAnimation);
  }

  @override
  void _addItemByKey(
    final T item, {
    required final bool withAnimation,
    final int? atIndex,
  }) {
    key.currentState?.addItem(
      item,
      atIndex: atIndex,
      withAnimation: withAnimation,
    );
  }

  @override
  bool _isKeyAvailable() => key.currentState != null;

  @override
  void _removeItemByKey(final int index) {
    key.currentState?.removeItemAt(index);
  }

  @override
  void _editItemByKey({
    required final T item,
    required final int index,
  }) {
    key.currentState?[index] = item;
  }
}
