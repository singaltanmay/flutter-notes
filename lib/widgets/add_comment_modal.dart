import 'package:flutter/material.dart';

class AddCommentModal extends StatelessWidget {
  final String parentBody;
  final String username;
  final Function onCommentAdd;

  const AddCommentModal(
      {Key? key,
      required this.parentBody,
      required this.username,
      required this.onCommentAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _commentBodyController =
        TextEditingController();

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 8, right: 8),
                child: Text(
                  "Adding comment under note by @" +
                      username +
                      "\n\n" +
                      parentBody.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: TextFormField(
                    minLines: 1,
                    maxLines: 100,
                    decoration: InputDecoration(
                      labelText: 'Add a comment',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.comment),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.backspace_rounded),
                        onPressed: () {
                          _commentBodyController.clear();
                        },
                      ),
                    ),
                    controller: _commentBodyController),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.only(top: 16, bottom: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xff008FFF),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).backgroundColor,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                          spreadRadius: 0,
                        ),
                      ]),
                  child: FlatButton.icon(
                    hoverColor: Colors.transparent,
                    onPressed: () {
                      onCommentAdd(_commentBodyController.text);
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    label: const Text("Done"),
                    icon: const Icon(Icons.done),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
