import 'dart:convert';
import 'dart:async';
import 'package:bookstore/model/user_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:bookstore/data/remote/user_service.dart';
import 'package:bookstore/data/spref/spref.dart';
import 'package:bookstore/shared/constant.dart';

class UserRepo {
  UserService _userService;

  UserRepo({@required UserService userService}): _userService =userService;

  Future<UserData> signIn(String phone, String pass) async{
    var c = Completer<UserData>();
    var response = await _userService.signIn(phone,pass);
    var userData = UserData.fromJson(response.data['data']);

    try{
      if(userData!=null){
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
        c.complete(userData);
      }
    } on DioError catch(e){
      print(e.response.data);
      c.completeError("SignIn failed: ");
    }
    catch(e){
      c.completeError(e.toString());
    }

    return c.future;
  }

  Future<UserData> signUp(String disPlayName,String phone, String pass) async{
    var c = Completer<UserData>();
    var response = await _userService.signUp(disPlayName,phone,pass);
    var userData = UserData.fromJson(response.data['data']);

    try{
      if(userData!=null){
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
        c.complete(userData);
      }
    } on DioError catch(e){
      print(e.response.data);
      c.completeError("SignUp failed: ");
    }
    catch(e){
      c.completeError(e.toString());
    }

    return c.future;
  }
}
