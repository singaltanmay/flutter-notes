import 'package:app/model/resource_uri.dart';
import 'package:app/widgets/no_connection_modal.dart';
import 'package:flutter/material.dart';

// Custom State class that checks for database connectivity on creation.
// If database cannot be reached then a NoConnectionModal() is displayed
abstract class DbConnectedState<T extends StatefulWidget> extends State<T> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();

  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ResourceUri.isServerHealthy().then((value) => {
            if (!value)
              {
                showModalBottomSheet(
                  builder: (context) {
                    return NoConnectionModal(
                      callback: () {
                        // Close this modal sheet
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  context: context,
                )
              }
          });
    });
  }
}
