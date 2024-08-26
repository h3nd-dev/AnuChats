import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showActionDialog({
  required BuildContext context,
  required void Function()? onBlock,
  required void Function()? onUnBlock,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.block),
              title: Text('Block'),
              onTap: () {
                Navigator.of(context).pop();
                _showConfirmationDialog(
                    context: context,
                    action: "unblock",
                    onBlock: onBlock,
                    onUnBlock: onUnBlock);
              },
            ),
            ListTile(
              leading: Icon(Icons.block_flipped),
              title: Text('Unblock'),
              onTap: () {
                Navigator.of(context).pop();
                _showConfirmationDialog(
                    context: context,
                    action: "unblock",
                    onBlock: onBlock,
                    onUnBlock: onUnBlock);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

void _showConfirmationDialog({
  required BuildContext context,
  required String action,
  required void Function()? onBlock,
  required void Function()? onUnBlock,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you really want to $action this user?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              if (action == "block") {
                onBlock!();
              } else {
                onUnBlock!();
              }
              Navigator.of(context).pop();
              // Handle block or unblock action
            },
            child: Text('Yes'),
          ),
        ],
      );
    },
  );
}

void showReportForm(
    {required BuildContext context,
    required TextEditingController reportController,
    required void Function()? onPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Report User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reportController,
              maxLines: 4, // Allows the text field to be multiline
              decoration: const InputDecoration(
                hintText: 'Enter the reason for reporting this user',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onPressed!();

              Navigator.of(context).pop();
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}
