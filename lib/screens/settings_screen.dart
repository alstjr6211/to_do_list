import 'package:flutter/material.dart';
import 'package:to_do_list/application_version.dart';
import 'package:to_do_list/constant/bottomNavigationBar.dart';
import 'package:to_do_list/constant/color.dart';
import 'package:to_do_list/constant/widget/settingsLine.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {

    final _screenwidth = MediaQuery.of(context).size.width;
    final _screenheight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          width: _screenwidth,
          height: _screenheight,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: [
                Settingsline(menuText: '카테고리', screenwidth: _screenwidth,),

                Settingsline(menuText: '알림', screenwidth: _screenwidth,),
                //SwitchListTile(value: , onChanged: onChanged)
                Settingsline(menuText: '잠금화면', screenwidth: _screenwidth,),
                //SwitchListTile(value: value, onChanged: onChanged)
                Settingsline(menuText: '앱 정보', screenwidth: _screenwidth,),
                ListTile(
                  title: Text('어플리케이션 버전 : $application_version'),
                ),
                Divider(color: gray, thickness: 0.6,),
                ListTile(
                  title: Text('이용약관'),
                  onTap: (){
                    //TODO 이용약관 노션 링크로 이동
                  },
                ),
                Divider(color: gray, thickness: 0.6,),
                ListTile(
                  title: Text('개인정보 처리방침'),
                  onTap: (){
                    //TODO 개인정보처리방침 페이지 이동
                  },
                ),
                Divider(color: gray, thickness: 0.6,),
                ListTile(
                  title: Text('사용한 라이센스'),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'ToDoList',
                      applicationVersion: '$application_version',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ToDoListBottomBar(selectedPageIndex: 2,),
      ),
    );
  }
}
