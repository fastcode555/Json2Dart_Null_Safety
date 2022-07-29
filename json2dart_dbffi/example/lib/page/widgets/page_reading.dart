import 'package:book_reader/common/model/reader_theme.dart';
import 'package:book_reader/page/controller/page_reader_controller.dart';
import 'package:book_reader/page/dialog/page_select_font.dart';
import 'package:book_reader/res/index.dart';
import 'package:book_reader/res/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/strings.dart';

class PageReading extends StatelessWidget {
  final _readController = Get.find<ReaderController>();

  Rx<ReaderTheme> get _readTheme => _readController.readerTheme;

  String? get _fontFamily => _readTheme.value.font?.fontFamily;

  Color? get _fontColor => _readTheme.value.fontColor;

  PageReading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          height: 180,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: _handleSelectFont,
                      child: Text(
                        'Aa',
                        style: TextStyle(
                          fontSize: 45,
                          color: _fontColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _handleSelectFont,
                      child: Text(
                        _readTheme.value.font?.title ?? "",
                        style: TextStyle(
                          fontSize: 15,
                          color: _fontColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: _fontFamily,
                        ),
                      ),
                    ),
                    AddOrSubWidget(_fontColor!),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Spacer(),
                                _buildPaddingWidget(PaddingType.small),
                                const Spacer(),
                                _buildLetterHeightWidget(LetterHeightType.small),
                                const Spacer(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Spacer(),
                                _buildPaddingWidget(PaddingType.normal),
                                const Spacer(),
                                _buildLetterHeightWidget(LetterHeightType.normal),
                                const Spacer(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Spacer(),
                                _buildPaddingWidget(PaddingType.large),
                                const Spacer(),
                                _buildLetterHeightWidget(LetterHeightType.large),
                                const Spacer(),
                                //#f5e9d1
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildThemeWidget(ThemeType.light),
                        _buildThemeWidget(ThemeType.ink),
                        _buildThemeWidget(ThemeType.dark),
                        _buildThemeWidget(ThemeType.oldPaper),
                        _buildThemeWidget(ThemeType.green),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (GetPlatform.isMobile) ...[
          const Spacer(),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const PinSvg(R.icSun, size: 50.0),
                const SizedBox(width: 16),
                Text(Ids.auto.tr, style: TextStyles.a3323232Bold12),
              ],
            ),
          ),
          const Spacer()
        ],
      ],
    );
  }

  _buildLetterHeightWidget(double type) {
    String _pic = LetterHeightType.getType(type);
    double height = LetterHeightType.getHeight(type);
    Color? _color = type == _readTheme.value.letterHeight ? _fontColor : _fontColor?.withOpacity(0.6);
    return GestureDetector(
      child: PinSvg(_pic, width: 28.0, color: _color, height: height),
      onTap: () {
        _readTheme.update((val) {
          val!.letterHeight = type;
        });
      },
    );
  }

  _buildThemeWidget(int theme) {
    Color _color = ReaderTheme.getBackGroundColor(theme);
    return GestureDetector(
      child: CBox(
        activeColor: _color,
        iconColor: _color == Colors.white ? Colors.black : Colors.white,
        onChanged: (value) {
          if (value) {
            _readTheme.update((val) {
              ReaderTheme lightTheme = ReaderTheme(theme);
              val!.fontColor = lightTheme.fontColor;
              val.background = lightTheme.background;
              val.type = lightTheme.type;
            });
            if (GetPlatform.isAndroid) {
              Brightness _iconBrightness = _readTheme.value.type == ThemeType.dark ? Brightness.light : Brightness.dark;
              SystemChrome.setSystemUIOverlayStyle(
                  SystemUiOverlayStyle(statusBarColor: _color, statusBarIconBrightness: _iconBrightness));
            }
          }
        },
        value: _readTheme.value.type == theme,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
          border: const Border.fromBorderSide(BorderSide(width: 1.0, color: Colours.black51)),
        ),
      ),
    );
  }

  _buildPaddingWidget(double type) {
    String _pic = PaddingType.getPic(type);
    Color? _color = type == _readTheme.value.paddingType ? _fontColor : _fontColor?.withOpacity(0.6);
    return GestureDetector(
      child: PinSvg(_pic, color: _color, width: 30.0, height: 34.0),
      onTap: () {
        _readTheme.update((val) {
          val!.paddingType = type;
        });
      },
    );
  }

  //选择字体，并更新所选中的字体
  void _handleSelectFont() {
    showDialog(
      context: Get.context!,
      builder: (_) {
        return const PageFontDialog();
      },
    );
  }
}

///字体可控制的加减器
class AddOrSubWidget extends StatelessWidget {
  final _readController = Get.find<ReaderController>();
  final Color fontColor;

  Rx<ReaderTheme> get _readTheme => _readController.readerTheme;

  AddOrSubWidget(this.fontColor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(22.0)),
        border: Border.fromBorderSide(BorderSide(width: 1.0, color: Colours.x3d707070)),
      ),
      alignment: Alignment.center,
      width: 97,
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: 35,
                  color: fontColor,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                if (_readTheme.value.fontSize <= 10) {
                  showToast(Ids.tooSmallFontIsNotGoodForProtectingYourEyes.tr);
                } else {
                  _readTheme.update((val) {
                    val!.fontSize = val.fontSize - 1;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Text(
                '+',
                style: TextStyle(
                  fontSize: 35,
                  color: fontColor,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                if (_readTheme.value.fontSize >= 40) {
                  showToast(Ids.sirTheFontHasReachedItsMaximumValue.tr);
                } else {
                  _readTheme.update(
                    (val) {
                      val!.fontSize = val.fontSize + 1;
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
