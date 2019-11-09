import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymusic/theme.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();

  final _mobileController = TextEditingController();

  final _regController = TextEditingController();

  bool _mobileFlag = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(children: <Widget>[
          Expanded(child: Container()),
          Container(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
            child: Column(
              children: <Widget>[
                // form 表单
                Form(
                    key: _loginForm,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            autofocus: false,
                            autovalidate: _mobileFlag,
                            controller: _mobileController,
                            onChanged: (val) {
                              if (val.length > 11) {
                                this.setState(() {
                                  _mobileFlag = true;
                                });
                              }
                              return null;
                            },
                            // 调起数字键盘
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '请输入手机号',
                              contentPadding: const EdgeInsets.all(10.0),
                            ),
                            validator: (value) {
                              RegExp reg = new RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
                              if (!reg.hasMatch(value)) {
                                return '请输入正确手机号';
                              }
                              if (value.isEmpty) {
                                return '请输入手机号';
                              }
                              return null;
                            }),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                    autofocus: false,
                                    controller: _regController,
                                    inputFormatters: [
                                      WhitelistingTextInputFormatter.digitsOnly
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: '验证码',
                                      contentPadding: EdgeInsets.all(10.0),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return '验证码不能为空';
                                      }
                                      return null;
                                    }),
                              ),
                              Container(
                                width: 120.0,
                                height: 36.0,
                                margin:
                                    EdgeInsets.fromLTRB(32.0, 0.0, 0.0, 0.0),
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(36.0))),
                                    child: Text('发送验证码'),
                                    onPressed: () {
                                      print(_mobileController.text);
                                    }),
                              )
                            ])
                      ],
                    )),
                    //登录按钮
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 0.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(36.0))),
                      child: Text('登录'),
                      onPressed: () {
                        if (_loginForm.currentState.validate()) {
                          print('ok');
                        }
                      }),
                )
              ],
            ),
          )),
          Expanded(child: Container())
        ]),
      ),
    );
  }
}
