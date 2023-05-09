import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialogs.dart';

Future<bool> showDeleteDailog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure want to Delete?',
    optionBuilder: () => {
      'Cancel': false,
      'yes': true,
    },
  ).then((value) => value ?? false);
}
