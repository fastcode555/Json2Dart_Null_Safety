import 'package:flutter/material.dart';

/// @date 18/10/22
/// describe:
class CustomScaffold extends StatelessWidget {
  final String? lable;
  final Widget? leading;
  final List<Widget>? actions;
  final bool resizeToAvoidBottomInset;
  final Widget? body;
  final bool showAppBar;
  final Color? bgColor;
  final bool automaticallyImplyLeading;
  final bool? centerTitle;
  final Widget? title;

  const CustomScaffold({
    Key? key,
    this.lable,
    this.leading,
    this.actions,
    this.showAppBar = true,
    this.resizeToAvoidBottomInset = false,
    this.body,
    this.automaticallyImplyLeading = true,
    this.bgColor,
    this.centerTitle = true,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: showAppBar
          ? AppBar(
              actions: [
                if (actions != null) ...actions!,
                const SizedBox(width: 50),
              ],
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: automaticallyImplyLeading,
              leading: _buildLeading(context),
              elevation: 0.0,
              centerTitle: centerTitle,
              title: title ?? Text(lable ?? ''),
            )
          : null,
      body: body,
    );
  }

  _buildLeading(BuildContext context) => automaticallyImplyLeading
      ? (leading ??
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back_ios),
          ))
      : null;
}
