import 'package:crust/app/app_state.dart';
import 'package:crust/modules/home/home_actions.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<MyStore.Store>>(
        onInit: (Store<AppState> store) => store.dispatch(FetchStoresRequest()),
        converter: (Store<AppState> store) => store.state.home.stores,
        builder: (BuildContext context, List<MyStore.Store> stores) =>
            CustomScrollView(slivers: <Widget>[_appBar(), stores == null ? _loadingSliver() : _gridSliver(stores)]));
  }

  Widget _appBar() {
    return SliverAppBar(
        pinned: false,
        floating: false,
        expandedHeight: 60.0,
        backgroundColor: Burnt.primaryLight,
        elevation: 24.0,
        title: Text('Burntoast', style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: Burnt.fontFancy)));
  }

  Widget _loadingSliver() {
    return SliverFillRemaining(
      child: Container(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  Widget _gridSliver(stores) {
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        delegate: SliverChildListDelegate(List<Widget>.from(stores.map(_storeCard))));
  }

  Widget _storeCard(MyStore.Store store) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      Container(height: 100.0, child: Image.network(store.coverImage, fit: BoxFit.cover)),
      Padding(
          padding: EdgeInsets.only(left: 8.0, top: 5.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
            Text(store.location != null ? store.location : store.suburb, style: TextStyle(fontSize: 14.0)),
            Text(store.cuisines.join(', '), style: TextStyle(fontSize: 14.0)),
          ]))
    ]));
  }
}
