import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs/generic_dialogs.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empty note',
    optionBuilder: () => {
      "OK": null,
    },
  );
}
