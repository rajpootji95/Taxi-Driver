import 'package:flutter/material.dart';
import 'package:why_taxi_driver/utils/new_utils/ui.dart';
import 'package:why_taxi_driver/Locale/locale.dart';
import 'package:why_taxi_driver/Locale/strings_enum.dart';
import 'package:why_taxi_driver/utils/Session.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? text;
  final Color? color;
  final textColor;
  final BorderRadius? borderRadius;
  final IconData? icon;

  CustomButton({
    this.onTap,
    this.text,
    this.color,
    this.textColor,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return icon != null
        ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.zero,
                  side: BorderSide.none,
                ),
                backgroundColor: color ?? theme.primaryColor,
              ),
              onPressed: onTap as void Function()? ?? () {},
              icon: Icon(
                icon,
                color: textColor ?? theme.scaffoldBackgroundColor,
              ),
              label: Text(
                text != null
                    ? text!.toUpperCase()
                    : getTranslated(context,Strings.CONTINUE)!.toUpperCase(),
                style: theme.textTheme.button!
                    .copyWith(color: textColor ?? theme.scaffoldBackgroundColor),
              ),
            ),
        )
        : Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
          child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.zero,
                  side: BorderSide.none,
                ),
                backgroundColor: color ?? theme.primaryColor,
              ),
              onPressed: onTap as void Function()? ?? () {},
              child: Text(
                text != null
                    ? text!.toUpperCase()
                    : getTranslated(context,Strings.CONTINUE)!.toUpperCase(),
                style: theme.textTheme.button!
                    .copyWith(color: Colors.white),//?? theme.scaffoldBackgroundColor
              ),
            ),
        );
  }
}
