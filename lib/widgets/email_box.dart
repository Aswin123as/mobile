import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:timeago/timeago.dart' as timeago;

class EmailBox extends StatelessWidget {
  final Map data;

  EmailBox(this.data);

  @override
  Widget build(BuildContext context) {
    var time = timeago.format(DateTime.parse(data["creation"]));
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        children: <Widget>[
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(),
            ),
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 5),),
                Icon(
                  Icons.email,
                  size: 18,
                ),
                SizedBox(
                  width: 4,
                ),
                Text('${data["sender_full_name"]} - $time'),
              ],
            ),
          ),
          Container(
            height: 30,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    'Title:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text('${data["subject"]}'),
              ],
            ),
          ),
          Divider(
            thickness: 2,
          ),
          ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 30,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Html(
                    data: data["content"]
                    // maxLines: 1000,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
