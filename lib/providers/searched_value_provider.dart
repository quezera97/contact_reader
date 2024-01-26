import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchedValueProvider = StateNotifierProvider<SearchedFilterProvider, String>(
  (ref) => SearchedFilterProvider(),
);

class SearchedFilterProvider extends StateNotifier<String> {
  SearchedFilterProvider() : super('');

  void setSearchedValueProvider(String searchedValue) {
    state = searchedValue;
  }
}
