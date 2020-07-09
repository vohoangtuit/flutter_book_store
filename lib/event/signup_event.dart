import 'package:bookstore/base/base_event.dart';
import 'package:flutter/widgets.dart';

class SignUpEvent extends BaseEvent {
  String disPlayName;
  String phone;
  String pass;

  SignUpEvent({
    @required this.disPlayName,
    @required this.phone,
    @required this.pass,
  });
}
