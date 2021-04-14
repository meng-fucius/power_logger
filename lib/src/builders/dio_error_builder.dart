import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:power_logger/src/view/dio_error_view.dart';

///Dio Error builder
class DioErrorBuilder extends StatefulWidget {
  final DioError data;
  final DateTime date;
  DioErrorBuilder({Key? key, required this.data, required this.date})
      : super(key: key);

  @override
  _DioErrorBuilderState createState() => _DioErrorBuilderState();
}

class _DioErrorBuilderState extends State<DioErrorBuilder> {
  RequestOptions get _request => widget.data.requestOptions;

  String renderErrText(DioErrorType type) {
    switch (type) {
      case DioErrorType.connectTimeout:
        return '连接超时';
      case DioErrorType.sendTimeout:
        return '发送超时';
      case DioErrorType.receiveTimeout:
        return '接收超时';
      case DioErrorType.response:
        return '服务端错误';
      case DioErrorType.cancel:
        return '取消连接';
      case DioErrorType.other:
        return '未知错误';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.red[100],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DioErrorView(data: widget.data),
                ),
              );
            },
            title: Text(
              _request.path,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              '${widget.data.message}\n${widget.date}',
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w300,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  backgroundColor: Colors.green.withOpacity(0.8),
                  label: Text(_request.method),
                ),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(width: 24),
              Text(widget.data.type.toString()),
              Spacer(),
              Chip(
                backgroundColor: Colors.red.withOpacity(0.3),
                label: Text(renderErrText(widget.data.type)),
              ),
              SizedBox(width: 24),
            ],
          ),
        ],
      ),
    );
  }
}
