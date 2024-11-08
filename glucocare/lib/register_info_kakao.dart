import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glucocare/main.dart';
import 'package:glucocare/services/kakao_login_service.dart';
import 'package:logger/logger.dart';

class RegisterPageForKakao extends StatelessWidget {
  const RegisterPageForKakao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입', style: TextStyle(color: Colors.white),),
      ),
      body: const RegisterFormForKakao(),
    );
  }
}

class RegisterFormForKakao extends StatefulWidget {
  const RegisterFormForKakao({super.key});

  @override
  State<RegisterFormForKakao> createState() => _RegisterFormStateForKakao();
}

class _RegisterFormStateForKakao extends State<RegisterFormForKakao> {
  Logger logger = Logger();

  static final TextEditingController _nameController = TextEditingController();
  static String _birthYear = '2024';
  static String _birthMonth = '1';
  static String _birthDay = '1';
  static String _dropdownValue = '남';

  void _kakaoRegister() {
    String name = _nameController.text;
    Timestamp birthDate = Timestamp.fromDate(
        DateTime(int.parse(_birthYear), int.parse(_birthMonth), int.parse(_birthDay))
    );
    String gen = _dropdownValue;

    // 회원 등록

    // 카카오 로그인
    bool loginResult = KakaoLogin.login() as bool;
    if(loginResult) {
      User? user = FirebaseAuth.instance.currentUser;
      logger.d('glucocare_log user: $user');
      if(user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('GLUCOCARE', style: TextStyle(fontSize: 40),),
            const SizedBox(height: 40,),
            Container(
              width: 300,
              height: 50,
              child: TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    label: Text('이름'),
                    labelStyle: TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color:  Colors.red,
                        )
                    )
                ),
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: 300,
              height: 50,
              child: DropdownButtonFormField(
                value: _dropdownValue,
                hint: const Text('성별'),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    )
                ),
                items: ['남', '여'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 15, color: Colors.black54),),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _dropdownValue = newValue!;
                  });
                },
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              width: 300,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '생년월일',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(width: 30,),
                  DropdownButton(
                    value: _birthYear,
                    hint: Text('2024'),
                    onChanged: (newValue) {
                      setState(() {
                        _birthYear = newValue!;
                      });
                    },
                    items: [
                      for(int i = 2024; i > 1900; i--)
                        DropdownMenuItem<String>(
                          value: '$i',
                          child: Text('$i'),
                        )
                    ],
                  ),
                  SizedBox(width: 20,),
                  DropdownButton(
                    value: _birthMonth,
                    hint: Text('1'),
                    onChanged: (newValue) {
                      setState(() {
                        _birthMonth = newValue!;
                      });
                    },
                    items: [
                      for(int i = 1; i < 13; i++)
                        DropdownMenuItem<String>(
                          value: '$i',
                          child: Text('$i'),
                        )
                    ],
                  ),
                  SizedBox(width: 20,),
                  DropdownButton(
                    value: _birthDay,
                    hint: Text('01'),
                    onChanged: (newValue) {
                      setState(() {
                        _birthDay = newValue!;
                      });
                    },
                    items: [
                      for(int i = 1; i < 32; i++)
                        DropdownMenuItem(
                          value: '$i',
                          child: Text('$i'),
                        )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Container(
              width: 300,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                onPressed: _kakaoRegister,
                child: const Text(
                  '다음',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        )
    );
  }
}
