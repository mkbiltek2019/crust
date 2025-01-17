import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_service.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SetUsernameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: _Props.fromStore,
      builder: (context, props) {
        return _Presenter(myId: props.myId, username: props.username, setUsername: props.setUsername);
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final int myId;
  final String username;
  final Function setUsername;

  _Presenter({Key key, this.myId, this.username, this.setUsername}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  TextEditingController _nameCtrl = TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.username != null) _nameCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.username));
  }

  @override
  dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) async {
    var name = _nameCtrl.text;
    var error = Utils.validateUsername(name);
    if (error != null) {
      snack(context, error);
      return;
    }
    var result = await MeService.setUsername(userId: widget.myId, name: name);
    if (result == true) {
      widget.setUsername(name);
      Navigator.pop(context);
    } else {
      snack(context, 'Oops! Something went wrong, please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(),
      _form(),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Stack(
              children: <Widget>[
                Container(width: 50.0, height: 60.0),
                Positioned(left: -12.0, child: BackArrow(color: Burnt.lightGrey)),
              ],
            ),
            Text('SET USERNAME', style: Burnt.appBarTitleStyle)
          ]),
        ),
      ),
    );
  }

  Widget _form() {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 300.0,
            padding: EdgeInsets.only(bottom: 30.0),
            child: TextField(
              autofocus: true,
              controller: _nameCtrl,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Burnt.hintTextColor),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Burnt.lightGrey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Burnt.primaryLight, width: 1.0)),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buttons(),
          Container(height: 50.0),
        ],
      ),
    );
  }

  Widget _buttons() {
    return Builder(builder: (context) {
      return Container(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Burnt.primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(2.0)),
                padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
                child: Text('CANCEL', style: TextStyle(fontSize: 16.0, color: Burnt.primary, letterSpacing: 3.0)),
              ),
            ),
            Container(width: 8.0),
            InkWell(
              onTap: () => _submit(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0, 0.6, 1.0],
                      colors: [Color(0xFFFFAB40), Color(0xFFFFAB40), Color(0xFFFFC86B)],
                    )),
                child: Text('SUBMIT', style: TextStyle(fontSize: 16.0, color: Colors.white, letterSpacing: 3.0)),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _Props {
  final int myId;
  final String username;
  final Function setUsername;

  _Props({this.myId, this.username, this.setUsername});

  static fromStore(Store<AppState> store) {
    return _Props(
      myId: store.state.me.user?.id,
      username: store.state.me.user?.username,
      setUsername: (name) => store.dispatch(SetMyUsername(name)),
    );
  }
}
