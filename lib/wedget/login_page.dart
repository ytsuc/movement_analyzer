import 'package:flutter/material.dart';
import 'package:movement_analyzer/bloc/login_user.dart';
import 'package:movement_analyzer/database/database_manager.dart';
import 'package:movement_analyzer/wedget/infomation_page.dart';
import 'package:provider/provider.dart';

@immutable
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したユーザー名・パスワード
  String _id = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseManager>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // メールアドレス入力
              TextFormField(
                decoration: const InputDecoration(labelText: 'ユーザー名'),
                onChanged: (String value) {
                  setState(() {
                    _id = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              SizedBox(
                width: double.infinity,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  child: const Text('ログイン'),
                  onPressed: () async {
                    final userId = await database.login(_id, _password);
                    if (userId == "") {
                      setState(() {
                        infoText = "ログインに失敗しました";
                      });
                    } else {
                      setState(() {
                        infoText = "ログインに成功しました";
                      });
                      final loginUser =
                          Provider.of<LoginUser>(context, listen: false);
                      loginUser.id = userId;

                      // Provider(MultiProvider)を再度Pushすべし
                      /*
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const InfomationPage()),
                      );
                      */
                      final dbManager =
                          Provider.of<DatabaseManager>(context, listen: false);
                      final user =
                          Provider.of<LoginUser>(context, listen: false);
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return MultiProvider(
                            providers: [
                              Provider<DatabaseManager>(
                                  create: (context) => dbManager),
                              Provider<LoginUser>(create: (context) => user)
                            ],
                            child: const InfomationPage(),
                          );
                        }),
                      );
                    }
                    /*
                    try {
                      // メール/パスワードでユーザー登録
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ユーザー登録に成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return ChatPage();
                        }),
                      );
                    } catch (e) {
                      // ユーザー登録に失敗した場合
                      setState(() {
                        infoText = "登録に失敗しました：${e.toString()}";
                      });
                    }
                    */
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
