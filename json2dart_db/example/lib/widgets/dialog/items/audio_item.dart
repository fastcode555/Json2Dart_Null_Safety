import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gesound/common/model/audio_model.dart';
import 'package:gesound/res/index.dart';

/// @date 6/6/22
/// describe:
class AudioItem extends StatefulWidget {
  final List<AudioModel> selectModels;
  final AudioModel model;
  final int index;
  final VoidCallback? refreshCallback;

  const AudioItem(
    this.selectModels,
    this.index,
    this.model, {
    this.refreshCallback,
    Key? key,
  }) : super(key: key);

  @override
  _AudioItemState createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  @override
  Widget build(BuildContext context) {
    return PinButton(
      onPressed: () {
        if (widget.selectModels.contains(widget.model)) {
          widget.selectModels.remove(widget.model);
        } else {
          widget.selectModels.add(widget.model);
        }
        setState(() {});
        widget.refreshCallback?.call();
      },
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            const SizedBox(width: 18),
            SizedBox(
              height: 17.0,
              width: 20.0,
              child: CBox(
                decoration: ResDecor.radioDecor,
                iconSize: 17.0,
                value: widget.selectModels.contains(widget.model),
                iconColor: Colours.ff103434,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 25,
                      child: AutoSizeText(
                        '${widget.index + 1}.',
                        style: TextStyles.whiteW50014,
                        minFontSize: 10,
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.model.songName ?? '',
                        style: TextStyles.white14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 60.0,
              child: Text(
                widget.model.finalFormat,
                style: TextStyles.white14,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
