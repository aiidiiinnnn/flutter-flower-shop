import 'package:flutter/foundation.dart';

class FilterHelper {
  final List<BaseFilterModel> filters = [];

  FilterHelper();

  void add(final BaseFilterModel value) {
    filters.put(
      value,
      (element) => element.key == value.key,
    );
  }

  void append(final BaseFilterModel value) {
    filters.add(value);
  }

  void removeByKey(final String key) =>
      filters.removeWhere((final element) => element.key == key);

  void remove(
    final BaseFilterModel filterModel,
  ) =>
      filters.remove(filterModel);

  List<T> getFiltersModelByType<T extends BaseFilterModel>() =>
      filters.cast<T>().toList();

  bool any(final String key) => filters.any(
        (element) => element.key == key,
      );

  T singleFilterByKey<T extends BaseFilterModel>(final String key) =>
      filters.cast<T>().singleWhere(
            (element) => element.key == key,
          );

  List<T> getFiltersByKey<T extends BaseFilterModel>(final String key) =>
      filters
          .cast<T>()
          .where(
            (element) => element.key == key,
          )
          .toList();

  void clear() {
    filters.clear();
  }

  String query() {
    final query = StringBuffer();
    for (final element in filters) {
      query.write(element.query);
    }

    return query.isEmpty ? '' : '?${query.toString().substring(1)}';
  }
}

@immutable
abstract class BaseFilterModel {
  /// Query key
  final String key;

  /// Human readable query when you want to show filters in tags,
  /// maybe you need readable text to show your users
  final String? text;

  /// Whether to show above text or not
  final bool show;

  const BaseFilterModel({
    required this.key,
    this.text,
    this.show = false,
  }) : assert(
          !show || text != null,
          'text must not be null when show is true',
        );

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is BaseFilterModel &&
          runtimeType == other.runtimeType &&
          key == other.key;

  String get query;

  @override
  int get hashCode => key.hashCode;
}

class EqualFilterModel extends BaseFilterModel {
  /// Query value
  final String value;

  const EqualFilterModel({
    required super.key,
    required this.value,
    super.text,
    super.show,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EqualFilterModel &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          value == other.value;

  @override
  String get query => '&$key=$value';

  @override
  int get hashCode => key.hashCode;
}

enum SortType {
  none(''),
  ascending('%2b'),
  descending('%2d');

  final String queryKey;

  const SortType(this.queryKey);
}

class SortFilterModel extends BaseFilterModel {
  final SortType sortType;

  const SortFilterModel({
    required super.key,
    required this.sortType,
    super.text,
    super.show,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortFilterModel &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          sortType == other.sortType;

  @override
  String get query => '&Expression=${sortType.queryKey}$key';

  @override
  int get hashCode => key.hashCode;
}

class RangeFilterModel extends BaseFilterModel {
  /// Query start value
  final String? startValue;

  /// Query end value
  final String? endValue;

  const RangeFilterModel({
    required super.key,
    this.startValue,
    this.endValue,
    super.text,
    super.show,
  }) : assert(
          startValue != null || endValue != null,
          'start or end should not be null',
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RangeFilterModel &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          startValue == other.startValue &&
          endValue == other.endValue;

  @override
  String get query => '$startRangeQuery$endRangeQuery';

  String get startRangeQuery =>
      startValue != null ? '&start$key=$startValue' : '';

  String get endRangeQuery => endValue != null ? '&end$key=$endValue' : '';

  @override
  int get hashCode => key.hashCode;
}

extension TaavListExtension<T> on List<T> {
  List<T> put(final T element, final bool Function(T element) selector) {
    final index = indexWhere(selector);
    if (index >= 0) {
      this[index] = element;
    } else {
      add(element);
    }

    return this;
  }
}
