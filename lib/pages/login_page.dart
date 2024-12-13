import 'package:flutter/material.dart';
import 'package:flutter_wan_android/network/api.dart';
import 'package:flutter_wan_android/network/bean/app_response/app_response.dart';
import 'package:flutter_wan_android/network/bean/user_info/user_info.dart';
import 'package:flutter_wan_android/network/request_util.dart';
import 'package:flutter_wan_android/pages/base_page.dart';
import 'package:flutter_wan_android/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with BasePage<LoginPage> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController pwdTextController = TextEditingController();
  TextEditingController repwdTextController = TextEditingController();

  Key loginBtnKey = GlobalKey();
  Key modeBtnKey = GlobalKey();

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登录/注册", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: nameTextController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  hintText: "用户名",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              obscureText: true,
              controller: pwdTextController,
              decoration: const InputDecoration(
                  focusColor: Colors.greenAccent,
                  prefixIcon: Icon(Icons.lock),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  hintText: "密码",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
            ),
          ),
          if (!isLogin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                obscureText: true,
                controller: repwdTextController,
                decoration: InputDecoration(
                    focusColor: Colors.greenAccent,
                    prefixIcon: const Icon(Icons.person),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    hintText: "确认密码",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4))),
              ),
            ),
          const SizedBox(
            height: 64,
          ),
          Align(
              alignment: Alignment.center,
              key: loginBtnKey,
              child: SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                    onPressed: _onLoginOrRegister,
                    child: Text(isLogin ? "登录" : "注册")),
              )),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: TextButton(
                onPressed: _onChangeMode,
                child: Text(isLogin ? "没有账号？去注册" : "已有账号？去登录")),
          )
        ],
      ),
    );
  }

  void _onChangeMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  _onLoginOrRegister() async {
    FocusScope.of(context).unfocus();
    showLoadingDialog();
    var data = isLogin
        ? {
            "username": nameTextController.text.trim(),
            "password": pwdTextController.text.trim()
          }
        : {
            "username": nameTextController.text.trim(),
            "password": pwdTextController.text.trim(),
            "repassword": repwdTextController.text.trim()
          };
    AppResponse<UserInfo> res = await HttpGo.instance
        .post(isLogin ? Api.login : Api.register, data: data);
    dismissDialog();
    if (res.isSuccessful && res.data != null) {
      User().loginSuccess(res.data!);
      Fluttertoast.showToast(msg: isLogin ? "登录成功" : "注册成功");
      Get.back();
    } else {
      Fluttertoast.showToast(
          msg: isLogin ? "登录失败：${res.errorMsg}" : "注册失败：${res.errorMsg}");
    }
  }
}
