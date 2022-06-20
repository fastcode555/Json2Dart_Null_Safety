import 'package:adobe_xd/gradient_xd_transform.dart';
import 'package:flutter/material.dart';
import 'package:gesound/res/index.dart';

class OutlinBtn extends StatelessWidget {
  final String text;
  final GestureTapCallback? onPressed;
  final double? width;
  final double? height;

  const OutlinBtn(
    this.text, {
    Key? key,
    this.width,
    this.height = 40.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinButton(
      width: width,
      height: height,
      decoration: ResDecor.stokeBtnDecor,
      title: text,
      style: TextStyles.RobotoWhiteW50014,
      onPressed: onPressed,
    );
  }
}

class FillButton extends StatelessWidget {
  final String text;
  final GestureTapCallback? onPressed;
  final double? width;
  final double? height;
  final double radius;

  const FillButton(
    this.text, {
    this.onPressed,
    this.width,
    this.height = 40.0,
    this.radius = 4.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(-0.901, -0.889),
                    end: Alignment(0.939, 0.854),
                    colors: [Colours.ff219e9d, Colours.ff1e8887],
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      center: Alignment(-0.427, 0.032),
                      radius: 0.326,
                      colors: [Colours.ff219e9d, Colours.ff1e8887],
                      stops: [0.0, 1.0],
                      transform: GradientXDTransform(1.0, 0.0, 0.0, 1.593, 0.0, -0.297, Alignment(-0.427, 0.032)),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(radius)),
                  ),
                  margin: const EdgeInsets.all(1.0)),
              Center(
                child: Text(
                  text,
                  style: TextStyles.whiteW50014,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
