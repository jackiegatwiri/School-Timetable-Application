import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as CalenderEvent;
import 'package:intl/intl.dart';

class DetailsCard extends StatefulWidget {
  final CalenderEvent.Event event;
  final String day, month, year;

  const DetailsCard({Key key, this.event, this.day, this.month, this.year})
      : super(key: key);
  @override
  _DetailsCardState createState() => _DetailsCardState();
}

class _DetailsCardState extends State<DetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.only(left: 24),
          height: 100,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('kk:mm:a').format(
                          widget.event.start.dateTime.add(Duration(hours: 3))),
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 2,
                      width: 10,
                      decoration: BoxDecoration(color: Colors.grey[300]),
                    ),
                    Container(
                      height: 2,
                      width: 32,
                      decoration: BoxDecoration(color: Colors.grey[300]),
                    ),
                    Container(
                      height: 2,
                      width: 10,
                      decoration: BoxDecoration(color: Colors.grey[300]),
                    ),
                    Text(
                      DateFormat('kk:mm:a').format(
                          widget.event.end.dateTime.add(Duration(hours: 3))),
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.only(left: 24, top: 5, bottom: 0),
                  margin: EdgeInsets.only(top: 7),
                  decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${DateFormat('kk:mm').format(widget.event.start.dateTime.add(Duration(hours: 3)))} - ${DateFormat('kk:mm').format(widget.event.end.dateTime.add(Duration(hours: 3)))}",
                        overflow: TextOverflow.fade,
                        style: TextStyle(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${widget.event.summary}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.add_location,
                            color: Colors.grey,
                            size: 12,
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Text(
                              "${widget.event.location ?? 'Location not added'}",
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
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
