import 'package:flutter/material.dart';

class Stream extends StatefulWidget {
  final bool isBroadcaster;
  final String channelId;

  const Stream({
    Key? key,
    required this.isBroadcaster,
    required this.channelId,
  }) : super(key: key);

  @override
  State<Stream> createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
