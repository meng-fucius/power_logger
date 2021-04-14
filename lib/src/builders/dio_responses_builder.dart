import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:power_logger/src/view/dio_response_view.dart';

/// Dio Response Builder
class DioResponseBuilder extends StatefulWidget {
  final Response data;
  final DateTime date;
  DioResponseBuilder({Key? key, required this.data, required this.date})
      : super(key: key);

  @override
  _DioResponseBuilderState createState() => _DioResponseBuilderState();
}

class _DioResponseBuilderState extends State<DioResponseBuilder> {
  RequestOptions? get _request => widget.data.requestOptions;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: Colors.green[100],
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DioResponseView(data: widget.data),
          ),
        ),
        title: Text(
          _request!.path,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        subtitle: Text(widget.date.toString()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              backgroundColor: Colors.green.withOpacity(0.8),
              label: Text(_request!.method),
            ),
          ],
        ),
      ),
    );
  }
}
