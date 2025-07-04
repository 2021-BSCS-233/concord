import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? fieldColor;
  final String fieldLabel;
  final String? fieldHint;
  final TextEditingController controller;
  final double? fieldHeight;
  final double? fieldRadius;
  final double? horizontalMargin;
  final double? verticalMargin;
  final double? contentTopPadding;
  final double? contentBottomPadding;
  final Function? onChange;
  final Function? hideLetters;
  final bool? hidden;
  final List<TextInputFormatter>? inputFormats;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final FocusNode? fieldFocusNode;

  const CustomInputField(
      {super.key,
      required this.fieldLabel,
      required this.controller,
      this.fieldHint,
      this.suffixIcon,
      this.prefixIcon,
      this.fieldColor,
      this.fieldHeight,
      this.onChange,
      this.hideLetters,
      this.hidden,
      this.inputFormats,
      this.fieldRadius,
      this.horizontalMargin,
      this.verticalMargin,
      this.maxLength,
      this.contentTopPadding,
      this.contentBottomPadding,
      this.maxLines,
      this.fieldFocusNode,
      this.minLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin ?? 5, vertical: verticalMargin ?? 0),
      height: fieldHeight,
      child: TextFormField(
        focusNode: fieldFocusNode,
        inputFormatters: inputFormats,
        maxLength: maxLength,
        minLines: minLines ?? 1,
        maxLines: maxLines ?? 1,
        onChanged: (e) {
          onChange != null ? onChange!() : null;
        },
        obscureText: hidden ?? false,
        controller: controller,
        decoration: InputDecoration(
          counterText: '',
          isCollapsed: true,
          contentPadding: EdgeInsets.fromLTRB(prefixIcon != null ? 5.0 : 15,
              contentTopPadding ?? 6.5, 5.0, contentBottomPadding ?? 5.0),
          //made it so if you pass all_inclusive icon it becomes invisible as a
          //temp solution for this field height not working problem
          //PS all_inclusive icon cuz its the least used apparently
          prefixIcon: prefixIcon == Icons.all_inclusive
              ? Icon(
                  prefixIcon,
                  color: Colors.transparent,
                )
              : prefixIcon != null
                  ? Icon(prefixIcon)
                  : null,
          suffixIcon: hideLetters != null
              ? InkWell(
                  onTap: () {
                    hideLetters!();
                  },
                  child: hidden!
                      ? const Icon(CupertinoIcons.eye)
                      : const Icon(CupertinoIcons.eye_slash),
                )
              : suffixIcon == Icons.all_inclusive
                  ? Icon(
                      suffixIcon,
                      color: Colors.transparent,
                    )
                  : suffixIcon != null
                      ? Icon(suffixIcon)
                      : null,
          fillColor: fieldColor ?? const Color(0xFF202020),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(fieldRadius ?? 25)),
            borderSide: BorderSide.none,
          ),
          label: Text(
            fieldLabel,
            overflow: TextOverflow.ellipsis,
          ),
          hintText: fieldHint ?? '',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.grey.shade600),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
