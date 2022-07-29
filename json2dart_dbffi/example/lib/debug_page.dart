import 'package:flutter/material.dart';
import 'package:infinity_core/core.dart';

class DebugPage extends StatefulWidget {
  static const String routeName = '/login/DebugPage';

  const DebugPage({Key? key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("调试页面"),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            // margin: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
                _buildCenterLogo(),
                ...Global.languages.mapWidget(
                  (index, t) => TextButton(
                      onPressed: () {
                        LanguageUtil.setLocalModel(t);
                        Navigator.of(context).pop();
                      },
                      child: Text(t.titleId)),
                ),
                _buildConfirmWidget(),
              ],
            ),
          ),
        ));
  }

  _buildConfirmWidget() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const TextButton(
            onPressed: NavigatorUtil.pop,
            child: Text("取消", style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(width: 50.0),
          TextButton(
            child: const Text("确认", style: TextStyle(color: Colors.black)),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  _buildCenterLogo() {
    return const Align(
      alignment: Alignment.topCenter,
      child: Icon(Icons.star, size: 200.0, color: Colors.blue),
    );
  }
}
