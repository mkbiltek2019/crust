import 'dart:async';

import 'package:crust/components/my_profile/find_user_screen.dart';
import 'package:crust/components/my_profile/my_qr_screen.dart';
import 'package:crust/components/my_profile/set_picture_screen.dart';
import 'package:crust/components/my_profile/update_profile_screen.dart';
import 'package:crust/components/post_list/post_list_list.dart';
import 'package:crust/components/screens/about_screen.dart';
import 'package:crust/main.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/user.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/post/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: _Props.fromStore,
      builder: (context, props) {
        return _Presenter(me: props.me, logout: props.logout);
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final User me;
  final Function logout;

  _Presenter({Key key, this.me, this.logout}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  final String defaultProfilePic =
      'https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/users%2Fprofile-pictures%2F1565423370052-9201.jpg?alt=media&token=1a80c164-4ca6-4174-bd46-c8c265c17ae9';
  ScrollController _scrollie;
  List<Post> posts;
  bool loading = false;
  int limit = 7;
  int offset = 0;

  @override
  initState() {
    super.initState();
    _scrollie = ScrollController()
      ..addListener(() {
        if (loading == false && limit > 0 && _scrollie.position.extentAfter < 500) _getMorePosts();
      });
    _load();
  }

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  _load() async {
    var fresh = await _getPosts();
    this.setState(() => posts = fresh);
  }

  removeFromList(int index) {
    this.setState(() => posts = List<Post>.from(posts)..removeAt(index));
  }

  Future<List<Post>> _getPosts() async {
    return PostService.fetchMyPosts(userId: widget.me.id, limit: limit, offset: offset);
  }

  _getMorePosts() async {
    this.setState(() => loading = true);
    var fresh = await _getPosts();
    if (fresh.isEmpty) {
      this.setState(() {
        limit = 0;
        loading = false;
      });
      return;
    }
    var update = List<Post>.from(posts)..addAll(fresh);
    this.setState(() {
      offset = offset + limit;
      posts = update;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _drawer(context),
      body: CustomScrollView(slivers: <Widget>[
        _appBar(),
        PostListList(
          noPostsView: Text('Start reviewing now and your reviews will show up here!'),
          postListType: PostListType.forProfile,
          posts: posts,
          removeFromList: removeFromList,
        ),
        if (loading == true) LoadingSliver(),
      ], controller: _scrollie),
    );
  }

  Widget _appBar() {
    var user = widget.me;
    return SliverToBoxAdapter(
      child: Column(children: <Widget>[
        Container(
          child: Stack(children: <Widget>[
            Container(height: 200.0),
            Stack(children: <Widget>[
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                  color: Burnt.separator,
                  image: DecorationImage(image: NetworkImage(user.profilePicture), fit: BoxFit.cover),
                ),
              ),
              _menuButton(),
            ]),
            Container(
              margin: EdgeInsets.only(top: 70.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[_profilePicture(user.profilePicture)],
              ),
            )
          ]),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(user.displayName, style: Burnt.titleStyle),
                Container(width: 4.0),
                Text("@${user.username}"),
              ]),
            ],
          ),
        ),
        if (user.tagline != null) _tagline(),
        if (user.profilePicture == defaultProfilePic) _setProfilePictureButton()
      ]),
    );
  }

  Widget _profilePicture(String picture) {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: Burnt.separator,
        borderRadius: BorderRadius.circular(150.0),
        border: Border.all(color: Colors.white, width: 4.0),
        image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(picture)),
      ),
    );
  }

  Widget _tagline() {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0),
      child: Text(widget.me.tagline),
    );
  }

  Widget _setProfilePictureButton() {
    return Builder(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: SmallButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SetPictureScreen())),
          padding: EdgeInsets.only(left: 7.0, right: 12.0, top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add, size: 16.0, color: Colors.white),
              Container(width: 2.0),
              Text('Set Profile Picture', style: TextStyle(fontSize: 16.0, color: Colors.white))
            ],
          ),
        ),
      );
    });
  }

  Widget _menuButton() {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(color: Color(0x55000000)),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Builder(builder: (context) {
              return IconButton(
                icon: Icon(CupertinoIcons.ellipsis),
                color: Colors.white,
                iconSize: 40.0,
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    var user = widget.me;
    return Drawer(
      child: Center(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SetPictureScreen())),
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Burnt.separator,
                borderRadius: BorderRadius.circular(150.0),
                border: Border.all(
                  color: Colors.white,
                  width: 4.0,
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(user.profilePicture),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, top: 12.0, bottom: 20.0),
            child: Column(
              children: <Widget>[
                Text(user.displayName, style: TextStyle(fontSize: 22.0, fontWeight: Burnt.fontBold)),
                Text("@${user.username}")
              ],
            ),
          ),
          ListTile(
            title: Text('Find User', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => FindUserScreen(myId: user.id)));
            },
          ),
          ListTile(
            title: Text('My QR Code', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => MyQrScreen(userId: user.id)));
            },
          ),
          ListTile(
            title: Text('Update Profile', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateProfileScreen()));
            },
          ),
          ListTile(
            title: Text('About', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
            },
          ),
          ListTile(
            title: Text('Log out', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              widget.logout();
              Navigator.popUntil(context, ModalRoute.withName(MainRoutes.root));
            },
          ),
        ]),
      ),
    );
  }
}

class _Props {
  final User me;
  final Function logout;

  _Props({this.me, this.logout});

  static fromStore(Store<AppState> store) {
    return _Props(
      me: store.state.me.user,
      logout: () => store.dispatch(Logout()),
    );
  }
}
