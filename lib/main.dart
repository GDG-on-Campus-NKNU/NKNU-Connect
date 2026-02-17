import 'package:flutter/material.dart';
import 'package:nknu_connect/nknu_core_ffi.dart';

void main() {
  runApp(const MyApp());
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

    var r = NknuCoreFfi.getSessionInfo();
    var sessionId = r["data"]["aspNETSessionId"];
    var viewState = r["data"]["viewState"];

    var loginResult = NknuCoreFfi.login(sessionId, viewState, acc, pwd);
    debugPrint(loginResult.toString());

    var mailResult = NknuCoreFfi.getMailServiceAccount(sessionId);
    debugPrint(mailResult.toString());

    try {
      return [
        mailResult["data"]["google"]["account"],
        mailResult["data"]["google"]["password"],
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
