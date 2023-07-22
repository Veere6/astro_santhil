import 'package:astro_santhil_app/commonpackage/future_search_filter_options_widget.dart';
import 'package:astro_santhil_app/commonpackage/helper_classes.dart';
import 'package:astro_santhil_app/commonpackage/prepare_widget.dart';
import 'package:astro_santhil_app/commonpackage/title_validator_output_widget.dart';
import 'package:flutter/material.dart';

import 'future_search_order_options_widget.dart';

/// Widget displayed above the search bar.
class TitleBar extends StatelessWidget {
  /// See SearchChoices class.
  final bool multipleSelection;

  /// See SearchChoices class.
  final dynamic doneButton;

  /// See SearchChoices class.
  final dynamic selectedResult;

  /// See SearchChoices class.
  final Function updateParentWithOptionalPop;

  /// See SearchChoices class.
  final bool valid;

  /// See SearchChoices class.
  final Function pop;

  /// See SearchChoices class.
  final StateSetter setState;

  /// See SearchChoices class.
  final bool rightToLeft;

  /// See SearchChoices class.
  final PointerThisPlease<int>? currentPage;

  /// See SearchChoices class.
  final PointerThisPlease<String?> orderBy;

  /// See SearchChoices class.
  final PointerThisPlease<bool?> orderAsc;

  /// See SearchChoices class.
  final Widget Function({
  required bool filter,
  required BuildContext context,
  required Function onPressed,
  int? nbFilters,
  bool? orderAsc,
  String? orderBy,
  })? buildFutureFilterOrOrderButton;

  /// See SearchChoices class.
  final Map<String, Map<String, dynamic>>? futureSearchOrderOptions;

  /// See SearchChoices class.
  final Map<String, Map<String, Object>>? futureSearchFilterOptions;

  /// See SearchChoices class.
  final PointerThisPlease<List<Tuple2<String, String>>?> filters;

  /// See SearchChoices class.
  final bool dialogBox;

  /// See SearchChoices class.
  final Widget? hint;

  /// See SearchChoices class.
  final String? validResult;

  TitleBar({
    Key? key,
    required this.multipleSelection,
    required this.doneButton,
    required this.selectedResult,
    required this.updateParentWithOptionalPop,
    required this.valid,
    required this.pop,
    required this.setState,
    required this.rightToLeft,
    required this.currentPage,
    required this.buildFutureFilterOrOrderButton,
    required this.futureSearchOrderOptions,
    required this.futureSearchFilterOptions,
    required this.dialogBox,
    required this.hint,
    required this.validResult,
    required this.filters,
    required this.orderBy,
    required this.orderAsc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? doneButtonWidget = multipleSelection || doneButton != null
        ? prepareWidget(doneButton,
        parameter: selectedResult,
        context: context,
        updateParent: updateParentWithOptionalPop,
        stringToWidgetFunction: (string) {
          return (TextButton.icon(
              onPressed: !valid
                  ? null
                  : () {
                pop();
                setState(() {});
              },
              icon: Icon(Icons.close),
              label: Text(
                string,
                textDirection:
                rightToLeft ? TextDirection.rtl : TextDirection.ltr,
              )));
        })
        : SizedBox.shrink();
    Widget futureOrderAndFilterButtons = Row(
      children: <Widget>[
        futureSearchOrderOptions == null
            ? SizedBox.shrink()
            : FutureSearchOrderOptionsWidget(
          futureSearchOrderOptions: futureSearchOrderOptions,
          currentPage: currentPage,
          orderAsc: orderAsc,
          orderBy: orderBy,
          setState: setState,
          rightToLeft: rightToLeft,
          updateParentWithOptionalPop: updateParentWithOptionalPop,
          buildFutureFilterOrOrderButton: buildFutureFilterOrOrderButton,
        ),
        futureSearchOrderOptions != null && futureSearchFilterOptions != null
            ? SizedBox(
          width: 10,
        )
            : SizedBox.shrink(),
        futureSearchFilterOptions == null
            ? SizedBox.shrink()
            : FutureSearchFilterOptionsWidget(
          futureSearchFilterOptions: futureSearchFilterOptions,
          filters: filters,
          updateParentWithOptionalPop: updateParentWithOptionalPop,
          rightToLeft: rightToLeft,
          currentPage: currentPage,
          dialogBox: dialogBox,
          setState: setState,
          buildFutureFilterOrOrderButton: buildFutureFilterOrOrderButton,
        ),
      ],
    );
    return (hint != null ||
        futureSearchOrderOptions != null ||
        futureSearchFilterOptions != null)
        ? Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
          textDirection:
          rightToLeft ? TextDirection.rtl : TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            prepareWidget(hint) ?? SizedBox.shrink(),
            futureOrderAndFilterButtons,
            Column(
              children: <Widget>[
                doneButtonWidget ?? SizedBox.shrink(),
                TitleValidatorOutputWidget(
                    dialogBox: dialogBox,
                    rightToLeft: rightToLeft,
                    validResult: validResult),
              ],
            ),
          ]),
    )
        : Container(
      child: Column(
        children: <Widget>[
          doneButtonWidget ?? SizedBox.shrink(),
          TitleValidatorOutputWidget(
              dialogBox: dialogBox,
              rightToLeft: rightToLeft,
              validResult: validResult),
        ],
      ),
    );
  }
}
