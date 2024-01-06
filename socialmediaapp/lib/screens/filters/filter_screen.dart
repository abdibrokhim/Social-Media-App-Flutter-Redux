import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/screens/filters/post_filters/post_filters_screen.dart';
import 'package:socialmediaapp/screens/filters/user_filters/user_filters_reducer.dart';
import 'package:socialmediaapp/screens/filters/post_filters/post_filters_reducer.dart';
import 'package:socialmediaapp/screens/filters/user_filters/user_filters_screen.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';


enum FilterType { users, posts }

class FilterScreen extends StatefulWidget {
  static const String routeName = "/filter";


  const FilterScreen({
    Key? key,
  }) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _filterController = TextEditingController();
  FilterType _selectedFilter = FilterType.users;
  bool isSearching = false;
  bool autoCompleteOn = false;

  @override

  void initState() {
    super.initState();
    _filterController.addListener(() {
      if (_filterController.text.isNotEmpty && _selectedFilter == FilterType.users) {
        StoreProvider.of<GlobalState>(context, listen: false).dispatch(AutoCompleteUserRequestAction(_filterController.text));
      } else if (_filterController.text.isNotEmpty && _selectedFilter == FilterType.posts) {
        StoreProvider.of<GlobalState>(context, listen: false).dispatch(AutoCompletePostRequestAction(_filterController.text));
      }
    });
  }

  void _search() {
    final String filter = _filterController.text;
    if (filter.isNotEmpty) {
      if (_selectedFilter == FilterType.users) {
        StoreProvider.of<GlobalState>(context).dispatch(FilterUsersRequestAction(filter));
      } else {
        StoreProvider.of<GlobalState>(context).dispatch(FilterPostsRequestAction(filter));
      }
      if (!StoreProvider.of<GlobalState>(context).state.appState.userState.searchHistory.contains(filter.toLowerCase())) {
        StoreProvider.of<GlobalState>(context).dispatch(SaveToUserHistoryAction(filter.toLowerCase()));
      }
      print('Search History: ${StoreProvider.of<GlobalState>(context).state.appState.userState.searchHistory}');
      setState(() {
        isSearching = false;
      });
    }
  }

  void _clearHistory() {
    StoreProvider.of<GlobalState>(context).dispatch(DeleteAllFromUserHistoryAction());
  }

  void _deleteSearchQuery(int index) {
    StoreProvider.of<GlobalState>(context).dispatch(DeleteFromUserHistoryAction(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _filterController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search_rounded),
                        onPressed: _search,
                      ),
                    ),
                    onTap: () => setState(() => isSearching = true),
                  ),
                ),
                DropdownButton<FilterType>(
                  value: _selectedFilter,
                  onChanged: (FilterType? newValue) => setState(() => _selectedFilter = newValue!),
                  items: FilterType.values.map((FilterType classType) {
                    return DropdownMenuItem<FilterType>(
                      value: classType,
                      child: Text(classType.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          StoreConnector<GlobalState, UserState>(
            converter: (store) => store.state.appState.userState,
            builder: (context, userState) {
              var store = StoreProvider.of<GlobalState>(context);
              return isSearching && userState.searchHistory.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(child: 
                      Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Search History'),
                                  ),
                                  TextButton(
                                    onPressed: _clearHistory,
                                    child: const Text('Clear'),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: userState.searchHistory.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const Icon(Icons.history_rounded),
                                    title: Text(userState.searchHistory[index]),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.clear_rounded),
                                      onPressed: () => _deleteSearchQuery(index),
                                    ),
                                    onTap: () {
                                      _filterController.text = userState.searchHistory[index];
                                      _search();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          if (isSearching && _filterController.text.isNotEmpty && _selectedFilter == FilterType.users)
                            Column(
                              children: [
                                const Divider(),
                                const SizedBox(height: 8.0),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('Auto Complete'),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: store.state.appState.userFiltersState.autoCompleteList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: const Icon(Icons.auto_mode_rounded),
                                      title: Text(store.state.appState.userFiltersState.autoCompleteList[index].username),
                                      onTap: () {
                                        _filterController.text = store.state.appState.userFiltersState.autoCompleteList[index].username;
                                        _search();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          if (isSearching && _filterController.text.isNotEmpty && _selectedFilter == FilterType.posts)
                            Column(
                              children: [
                                const Divider(),
                                const SizedBox(height: 8.0),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('Auto Complete'),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: store.state.appState.postFiltersState.autoCompleteList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: const Icon(Icons.auto_mode_rounded),
                                      title: Text(store.state.appState.postFiltersState.autoCompleteList[index].title),
                                      onTap: () {
                                        _filterController.text = store.state.appState.postFiltersState.autoCompleteList[index].title;
                                        _search();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      )
                      )
                    )
                  : Expanded(
                      child: _selectedFilter == FilterType.users
                          ? const UserFilterWidget()
                          : const PostFilterWidget(),
                    );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }
}
