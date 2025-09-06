import 'package:flutter/material.dart';
import 'package:nknu_connect/models/sso/sso_mail_account.dart';
import 'package:nknu_connect/models/sso/sso_session.dart';
import 'package:nknu_connect/services/native_services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    Provider<NativeServices>.value(
      value: NativeServices.instance,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NKNU App Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SSOLoginTest(),
    );
  }
}

class SSOLoginTest extends StatefulWidget {
  const SSOLoginTest({super.key});

  @override
  State<SSOLoginTest> createState() => _SSOLoginTestState();
}

class _SSOLoginTestState extends State<SSOLoginTest> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  String _accountDisplay = "Account: ";
  String _pwdDisplay = "Password: ";
  String _error = "";

  List<String> getGoogleAccount() {
    String acc = _accountController.text;
    String pwd = _pwdController.text;
    SsoSession session = NativeServices.instance.sso.getSession();
    try {
      NativeServices.instance.sso.login(session, acc, pwd);
      SsoMailServiceAccount mailServiceAccount = NativeServices.instance.sso
          .getMailServiceAccount(session.sessionID);
      _error = "";
      return [
        mailServiceAccount.googleAccount,
        mailServiceAccount.googlePassword,
      ];
    } catch (e) {
      _error = e.toString();
      return ["", ""];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NKNU App Integration Test")),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _accountController,
              decoration: const InputDecoration(labelText: "Account"),
            ),
            TextField(
              controller: _pwdController,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            Container(height: 8),
            ElevatedButton(
              onPressed: () {
                String account = _accountController.text;
                String pwd = _pwdController.text;

                List<String> s = getGoogleAccount();

                setState(() {
                  _accountDisplay = "Account: ${s[0]}";
                  _pwdDisplay = "Password: ${s[1]}";
                });
              },
              child: Text("Get Gmail Account"),
            ),
            Container(height: 8),
            Text(_accountDisplay),
            Text(_pwdDisplay),
            Text(_error),
          ],
        ),
      ),
    );
  }
}
