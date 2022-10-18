import 'package:flutter/material.dart';
import 'package:json2dart_viewerffi/src/widgets/custom_scaffold.dart';

/// @date 18/10/22
/// describe:

class DetailPage extends StatefulWidget {
  static const String routeName = "/src/detail_page";
  final String tableName;

  const DetailPage({super.key, required this.tableName});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      lable: widget.tableName,
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Text("Detail Page");
  }
}
