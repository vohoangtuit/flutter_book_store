import 'dart:async';

import 'package:bookstore/event/signup_fail_event.dart';
import 'package:bookstore/event/signup_sucess_event.dart';
import 'package:bookstore/shared/validation.dart';
import 'package:flutter/widgets.dart';
import 'package:bookstore/base/base_bloc.dart';
import 'package:bookstore/base/base_event.dart';
import 'package:bookstore/data/repo/user_repo.dart';
import 'package:bookstore/data/spref/spref.dart';
import 'package:bookstore/event/signup_event.dart';
import 'package:bookstore/event/singin_event.dart';
import 'package:bookstore/shared/constant.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends BaseBloc {

  final _nameSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  UserRepo _userRepo;

  SignUpBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  } // contractor
  var nameValidate  = StreamTransformer<String, String>.fromHandlers(
      handleData:(name, sink) {
        if(Validation.isDisplayName(name)){
          sink.add(null);
          return;
        }
        sink.add('Your name invalid');
      }
  );
  var phoneValidate  = StreamTransformer<String, String>.fromHandlers(
      handleData:(phone, sink) {
        if(Validation.isPhoneValid(phone)){
          sink.add(null);
          return;
        }
        sink.add('The phone invalid');
      }
  );

  var passValidate  = StreamTransformer<String, String>.fromHandlers(
      handleData:(pass, sink) {
        if(Validation.isPassValid(pass)){
          sink.add(null);
          return;
        }
        sink.add('The password invalid');
      }
  );

  Stream<String> get nameStream => _nameSubject.stream.transform(nameValidate);
  Sink<String> get nameSink => _nameSubject.sink;

  Stream<String> get phoneStream => _phoneSubject.stream.transform(phoneValidate);
  Sink<String> get phoneSink => _phoneSubject.sink;

  Stream<String> get passStream => _passSubject.stream.transform(passValidate);
  Sink<String> get passSink => _passSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  validateForm() {
    Observable.combineLatest3(_nameSubject,_phoneSubject, _passSubject, (name,phone, pass)  {
      return Validation.isDisplayName(name) && Validation.isPhoneValid(phone) && Validation.isPassValid(pass);
    },
    ).listen((enable) {
      btnSink.add(enable);

    }
      ,);
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SignUpEvent:
        handleSignUp(event);
        break;
    }
  }

  handleSignUp(BaseEvent event) {
    btnSink.add(false);
    loadingSink.add(true); // show loading

    Future.delayed(Duration(seconds: 6), () {
      SignUpEvent e = event as SignUpEvent;
      _userRepo.signUp(e.disPlayName, e.phone, e.pass).then(
            (userData) {
          processEventSink.add(SignUpSuccessEvent(userData));
        },
        onError: (e) {
          btnSink.add(true);
          loadingSink.add(false);
          processEventSink.add(SignUpFailEvent(e.toString()));
        },
      );
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameSubject.close();
    _phoneSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }
}
