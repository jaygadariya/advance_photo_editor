import 'package:advance_photo_editor/emoji_list.dart';
import 'package:flutter/material.dart';

class AddEmojiScreen extends StatelessWidget {
  AddEmojiScreen({Key? key}) : super(key: key);

  List emojis = [];

  @override
  Widget build(BuildContext context) {
    emojis = getAllEmojis();
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: Column(
        children: [
          Container(
            height: 5.0,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.only(bottom: 16.0),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  ...emojis.map((emoji) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, {
                          'name': emoji,
                          'color': Colors.white,
                          'size': 35.0,
                          'align': TextAlign.center,
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 35),
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
