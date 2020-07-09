//import 'dart:js';

import 'package:bookstore/base/base_event.dart';
import 'package:bookstore/event/signup_event.dart';
import 'package:bookstore/event/signup_fail_event.dart';
import 'package:bookstore/event/signup_sucess_event.dart';
import 'package:bookstore/module/home/home_page.dart';
import 'package:bookstore/module/signup/signup_bloc.dart';
import 'package:bookstore/shared/widget/bloc_listener.dart';
import 'package:bookstore/shared/widget/loading_task.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/base/base_widget.dart';
import 'package:bookstore/data/remote/user_service.dart';
import 'package:bookstore/data/repo/user_repo.dart';
import 'package:bookstore/event/singin_event.dart';
import 'package:bookstore/module/signin/signin_bloc.dart';
import 'package:bookstore/shared/app_color.dart';
import 'package:bookstore/shared/widget/normal_button.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      bloc: [],
      di: [
        // 2 thang nay luon di cung
        Provider.value(value: UserService()), //1
        ProxyProvider<UserService, UserRepo>(
          update: (context, userService, previous) =>
              UserRepo(userService: userService),
        ),
      ],
      title: 'Sign Up',
      child: SignUpFormWidget(),
    );
  }
}

class SignUpFormWidget extends StatefulWidget {
  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  final TextEditingController _textNameController = TextEditingController();

  final TextEditingController _textPhoneController = TextEditingController();

  final TextEditingController _textPassController = TextEditingController();

  handleEvent(BaseEvent event) {
    if (event is SignUpSuccessEvent) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName('/home'),
      );
      return;
    }

    if (event is SignUpFailEvent) {
      final snackBar = SnackBar(
        content: Text(event.errMessage),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Provider<SignUpBloc>.value(
      value: SignUpBloc(userRepo: Provider.of(context)),
      child: Consumer<SignUpBloc>(
        builder: (context, bloc, child) => BlocListener<SignUpBloc>(
          listener: handleEvent,
          child: LoadingTask(
            bloc: bloc,
            child: Container(
              padding: EdgeInsets.all(25),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildNameField(bloc),
                      _buildPhoneField(bloc),
                      _buildPasswordField(bloc),
                      _buildButtonSignUp(bloc),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.nameStream,
      child: Consumer<String>(
        builder:(context, msg, child)=> Container(
          padding: EdgeInsets.only(bottom: 15),
          child: TextField(
            controller: _textNameController,
            onChanged: (text){
              bloc.nameSink.add(text);
            },
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.account_box,
                  color: AppColor.blue,
                ),
                hintText: 'enter your name',
                labelText: 'Name',
                errorText: msg,
                labelStyle: TextStyle(color: AppColor.blue)),
            maxLength: 50,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.phoneStream,
      child: Consumer<String>(
        builder:(context, msg, child)=> Container(
          padding: EdgeInsets.only(bottom: 15),
          child: TextField(
            controller: _textPhoneController,
            onChanged: (text){
              bloc.phoneSink.add(text);
            },
            cursorColor: Colors.black,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.phone,
                  color: AppColor.blue,
                ),
                hintText: '(+84) 123445678',
                labelText: 'Phone',
                errorText: msg,
                labelStyle: TextStyle(color: AppColor.blue)),
            maxLength: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.passStream,
      child: Consumer<String>(
        builder:(context, mgs, child) => Container(
          padding: EdgeInsets.only(bottom: 25),
          child: TextField(
            controller: _textPassController,
            onChanged: (text){
              bloc.passSink.add(text);
            },
            obscureText: true,
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.vpn_key,
                  color: AppColor.blue,
                ),
                hintText: 'Password',
                labelText: 'Password',
                errorText: mgs,
                labelStyle: TextStyle(color: AppColor.blue)),
            maxLength: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonSignUp(SignUpBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder:(context, enable, child) => NormalButton(
          title: 'Sign Up',
          onPressed: enable?() {
            bloc.event.add(SignUpEvent(
                disPlayName: _textNameController.text,
                phone: _textPhoneController.text,
                pass: _textPassController.text));
          }:null,
        ),
      ),
    );
  }
}
