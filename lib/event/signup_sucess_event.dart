
import 'package:bookstore/base/base_event.dart';
import 'package:bookstore/model/user_data.dart';

class SignUpSuccessEvent extends BaseEvent {
  final UserData userData;
  SignUpSuccessEvent(this.userData);
}
