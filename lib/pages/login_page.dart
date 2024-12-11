import 'package:flutter/material.dart';
import 'package:flutter_wan_android/pages/base_page.dart';

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
                    onPressed: () {}, child: Text(isLogin ? "登录" : "注册")),
              )),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: TextButton(
                onPressed: () {},
                child: Text(isLogin ? "没有账号？去注册" : "已有账号？去登录")),
          )
        ],
      ),
    );
  }
}
