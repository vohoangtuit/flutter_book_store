//import 'dart:js';

import 'package:bookstore/base/base_event.dart';
import 'package:bookstore/event/signin_fail_event.dart';
import 'package:bookstore/event/signin_sucess_event.dart';
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

class SignInPage extends StatelessWidget {
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
      title: 'Sign In',
      child: SignInFormWidget(),
    );
  }
}

class SignInFormWidget extends StatefulWidget {
  @override
  _SignInFormWidgetState createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  final TextEditingController _textPhoneController = TextEditingController();

  final TextEditingController _textPassController = TextEditingController();
  handleEvent(BaseEvent event) {
    if (event is SignInSuccessEvent) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    if (event is SignInFailEvent) {
      final snackBar = SnackBar(
        content: Text(event.errMessage),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<SignInBloc>.value(
        value: SignInBloc(userRepo: Provider.of(context)),
        child: Consumer<SignInBloc>(
          builder: (context, bloc, child) {
          return BlocListener<SignInBloc>(
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
                      _buildPhoneField(bloc),

                      _buildPasswordField(bloc),

                      _buildButtonSignIn(bloc),

                      _buildTextRegister(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
    }
    ),);
  }

  Widget _buildPhoneField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.phoneStream,
      child: Consumer<String>(
        builder: (context, msg, child) =>
            Container(
              padding: EdgeInsets.only(bottom: 15),
              child: TextField(
                controller: _textPhoneController,
                onChanged: (text) {
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

  Widget _buildPasswordField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.passStream,
      child: Consumer<String>(
        builder: (context, mgs, child) =>
            Container(
              padding: EdgeInsets.only(bottom: 25),
              child: TextField(
                controller: _textPassController,
                onChanged: (text) {
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

  Widget _buildButtonSignIn(SignInBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) =>
            NormalButton(title: 'Sign In',
              onPressed: enable ? () {
                bloc.event.add(
                    SignInEvent(
                    phone: _textPhoneController.text,
                    pass: _textPassController.text));
              } : null,
            ),
      ),
    );
  }

  Widget _buildTextRegister(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      child: FlatButton(
        onPressed: () {
          Navigator.pushNamed(context, '/sign-up');
        },

        child: Text(
          'Register account!',
          style: TextStyle(color: AppColor.blue, fontSize: 17),
        ),
      ),
    );
  }
}
