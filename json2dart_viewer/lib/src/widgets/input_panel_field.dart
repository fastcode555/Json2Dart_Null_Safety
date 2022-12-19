import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPanelField extends StatefulWidget {
  final String? text;
  final String? hintText;
  final bool obscureText;
  final int maxLines;
  final double height;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Color? normalColor;
  final Color? focusColor;
  final TextEditingController? controller;
  final BoxDecoration? decoration;
  final bool leftIconEnable;
  final FocusNode? focusNode;
  final Widget? leftWidget;
  final Color? backGroundColor;
  final bool nonDecoration;
  final double contentPadding;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? cancelCallBack;
  final VoidCallback? onEditingComplete;
  final FocusScopeNode? scopeNode; //全局焦点处理
  final int? maxLength; //输入框最多输入字符
  final bool enable;
  final Color? cursorColor;
  final EdgeInsetsGeometry? padding;

  InputPanelField.search({
    Key? key,
    this.text,
    this.obscureText = false,
    this.decoration,
    this.maxLines = 1,
    this.height = 38,
    this.textInputAction = TextInputAction.search,
    this.normalColor,
    this.focusColor = Colors.transparent,
    this.onSubmitted,
    this.controller,
    this.hintText,
    this.focusNode,
    this.leftWidget,
    this.leftIconEnable = true,
    this.nonDecoration = false,
    this.backGroundColor,
    this.keyboardType = TextInputType.text,
    this.onEditingComplete,
    this.contentPadding = 18,
    this.inputFormatters,
    this.maxLength,
    this.cancelCallBack,
    this.scopeNode,
    this.enable = true,
    this.cursorColor,
    this.padding,
  }) : super(key: key);

  InputPanelField({
    Key? key,
    this.text,
    this.obscureText = false,
    this.decoration,
    this.maxLines = 1,
    this.height = 38,
    this.textInputAction = TextInputAction.done,
    this.normalColor,
    this.focusColor = Colors.transparent,
    this.onSubmitted,
    this.controller,
    this.hintText,
    this.focusNode,
    this.leftWidget,
    this.backGroundColor,
    this.leftIconEnable = false,
    this.nonDecoration = false,
    this.contentPadding = 12,
    this.inputFormatters,
    this.onEditingComplete,
    this.cancelCallBack,
    this.scopeNode,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.enable = true,
    this.cursorColor,
    this.padding,
  }) : super(key: key);

  InputPanelField.noneDecoration({
    Key? key,
    this.text,
    this.obscureText = false,
    this.decoration,
    this.maxLines = 1,
    this.height = 38,
    this.textInputAction = TextInputAction.next,
    this.normalColor,
    this.focusColor = Colors.transparent,
    this.onSubmitted,
    this.controller,
    this.hintText,
    this.focusNode,
    this.leftWidget,
    this.backGroundColor,
    this.leftIconEnable = false,
    this.nonDecoration = true,
    this.keyboardType = TextInputType.text,
    this.contentPadding = 12,
    this.onEditingComplete,
    this.inputFormatters,
    this.cancelCallBack,
    this.maxLength,
    this.scopeNode,
    this.enable = true,
    this.cursorColor,
    this.padding,
  }) : super(key: key);

  @override
  _InputPanelFieldState createState() => _InputPanelFieldState();
}

class _InputPanelFieldState extends State<InputPanelField> {
  late FocusNode _focusNode;

  late TextEditingController _controller;
  bool _isShowClean = false;
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_focusNodeListener);
    _controller = widget.controller ?? TextEditingController();
    _showHint = _isEmpty(_controller.text);
    _controller.addListener(() {
      //自己实现限制输入长度
      if (widget.maxLength != null && widget.maxLength! > 0) {
        if (_controller.text.length > widget.maxLength!) {
          _controller.text = _controller.text.substring(0, widget.maxLength);
          //移动角标到最后位置
          _controller.selection = TextSelection.fromPosition(
            TextPosition(
                affinity: TextAffinity.downstream,
                offset: _controller.text.length),
          );
        }
      }
      //为解决柬埔寨语错位问题
      if (_isEmpty(_controller.text) != _showHint) {
        setState(() {
          _showHint = _isEmpty(_controller.text);
        });
      }
    });
  }

  bool _isEmpty(String? text) {
    return text == null || text.isEmpty;
  }

  Future<Null> _focusNodeListener() async {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      setState(() {
        _isShowClean = true;
      });
    } else {
      setState(() {
        _isShowClean = false;
      });
    }
  }

  @override
  void didUpdateWidget(InputPanelField oldWidget) {
    if (_focusNode.hasFocus && _controller.text.isNotEmpty) {
      _isShowClean = true;
    } else {
      _isShowClean = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.padding != null
        ? Padding(child: _buildTextField(), padding: widget.padding!)
        : _buildTextField();
  }

  _buildTextField() {
    return Container(
        height: widget.height,
        padding: EdgeInsets.symmetric(horizontal: widget.contentPadding),
        decoration: widget.nonDecoration ? null : _itemDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.leftIconEnable)
              widget.leftWidget ??
                  Icon(Icons.search, size: 16, color: _iconColor),
            if (widget.leftIconEnable) SizedBox(width: 5),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                textAlign: TextAlign.start,
                onEditingComplete: widget.onEditingComplete ??
                    (widget.scopeNode != null
                        ? () => widget.scopeNode!.nextFocus()
                        : null),
                controller: _controller,
                //双击或长按报错
                //enableInteractiveSelection: false,
                maxLines: widget.maxLines,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                //maxLength: widget.maxLength,自带的带有计数器
                cursorColor: widget.cursorColor,
                enabled: widget.enable,
                textInputAction: widget.textInputAction,
                style: TextStyle(color: Colors.white),
                //关闭自动联想功能,特别是输入密码的时候
                autocorrect: Platform.isIOS ? false : true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 5),
                  focusColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: !_showHint ? '' : (widget.hintText ?? ''),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                onChanged: (character) {
                  setState(() => _isShowClean = character.isNotEmpty);
                },
                inputFormatters: widget.inputFormatters,
                onSubmitted: (v) {
                  setState(() => _isShowClean = false);
                  widget.onSubmitted?.call(v);
                },
              ),
            ),
            _buildCancelButton(),
          ],
        ));
  }

  _buildCancelButton() {
    return _isShowClean
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              alignment: Alignment.center,
              child: Icon(Icons.cancel, size: 16, color: _iconColor),
            ),
            onTap: () {
              // 保证在组件build的第一帧时才去触发取消清空内
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _controller.clear());
              widget.cancelCallBack?.call();
              setState(() {
                _isShowClean = false;
              });
            },
          )
        : SizedBox();
  }

  get _iconColor => Colors.white;

  BoxDecoration get _itemDecoration {
    return widget.decoration ??
        (widget.textInputAction == TextInputAction.search
            ? BoxDecoration(
                color: _focusNode.hasFocus
                    ? widget.focusColor
                    : (widget.normalColor ??
                        widget.focusColor!.withOpacity(0.5)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              )
            : BoxDecoration(
                color: widget.backGroundColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1),
              ));
  }
}
