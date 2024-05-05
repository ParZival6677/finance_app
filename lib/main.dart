import 'package:flutter/material.dart';

import 'PlanningPage.dart';
import 'Notifications.dart';
import 'ProfilePage.dart';
import 'RegistrationPage1.dart';
import 'RegistrationPage2.dart';
import 'PinCodeScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance Management',
      theme: ThemeData(
        primaryColor: Color(0xFF10B981),
        scaffoldBackgroundColor: Color(0xFFF2F2F2),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: HomePage(),
      home: RegistrationPage1(),
      // home: RegistrationPage2(),
      // home: PinCodeScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isSavingsExpanded = false;
  bool _isLoansExpanded = false;
  bool _isBalanceVisible = true;

  int _totalBalance = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2F2F2),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _isBalanceVisible ? '${_totalBalance.toString()} \u20B8' : '*******', // Show *** if balance is hidden
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                      ),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                      icon: Image.asset(
                        _isBalanceVisible ? 'assets/icons/eye.png' : 'assets/icons/eye-off.png',
                        width: 32.0,
                        height: 32.0,
                        scale: 0.9,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Общий баланс',
                  style: TextStyle(
                    color: Color(0xFF7F7F7F),
                    fontSize: 18.0,
                  ),
                ),
                SizedBox( height: 10),
              ],
            ),
            IconButton( // IconButton для уведомлений
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
              icon: Container(
                margin: EdgeInsets.only(bottom: 25),
                child: Image.asset(
                  'assets/icons/notifications.png',
                  width: 32.0,
                  height: 32.0,
                  scale: 0.9,
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Мои счета',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Посмотреть все',
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 17,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(109, 20)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              width: double.infinity,
                              height: 2.0,
                              color: Color(0xFFF2F2F2),
                            ),
                            Row(
                              children: [
                                Image.asset('assets/icons/Thumbnail.png', width: 60.0, height: 60.0),
                                SizedBox(width: 10.0),
                                Text(
                                  'Наличные',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Аналитика',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Подробнее',
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 17,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(109, 20)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              width: double.infinity,
                              height: 2.0,
                              color: Color(0xFFF2F2F2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildExpandableContainer(
              title: 'Накопления',
              iconPath: 'assets/icons/fin-pod.png',
              isExpanded: _isSavingsExpanded,
              onPressed: () {
                setState(() {
                  _isSavingsExpanded = !_isSavingsExpanded;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      '+ Добавить накопления',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 20,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      minimumSize: MaterialStateProperty.all(Size(200, 30)),
                      elevation: MaterialStateProperty.all(0),
                      shadowColor: MaterialStateProperty.all(Colors.white),
                      textStyle: MaterialStateProperty.all(TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 18,
                      )),
                    ),
                  ),
                ],
              ),
            ),
            _buildExpandableContainer(
              title: 'Кредиты',
              iconPath: '',
              isExpanded: _isLoansExpanded,
              onPressed: () {
                setState(() {
                  _isLoansExpanded = !_isLoansExpanded;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      '+ Добавить кредиты',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 20,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      minimumSize: MaterialStateProperty.all(Size(200, 30)),
                      elevation: MaterialStateProperty.all(0),
                      shadowColor: MaterialStateProperty.all(Colors.white),
                      textStyle: MaterialStateProperty.all(TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 18,
                      )),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            switch (index) {
              case 0:
              // Navigate to Home Page
                break;
              case 1:
              // Navigate to Operations Page
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => OperationsPage()),
              //   );
                break;
              case 2:
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlanningPage()),
                );
                break;
              case 4:
              // Navigate to Profile Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                break;
            }
          });
        },
        iconSize: 32.0,
        selectedItemColor: Color(0xFF10B981),
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? Image.asset('assets/icons/active-home.png', width: 60.0, height: 60.0, scale: 0.8,)
                : Image.asset('assets/icons/home.png', width: 60.0, height: 60.0, scale: 0.8,),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? Image.asset('assets/icons/active-wallet.png', width: 60.0, height: 60.0, scale: 0.8,)
                : Image.asset('assets/icons/wallet.png', width: 60.0, height: 60.0, scale: 0.8,),
            label: 'Операции',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 72.0,
              height: 72.0,
              child: Transform.translate(
                offset: Offset(0.0, 8.0),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Color(0xFF10B981),
                  child: Icon(Icons.add, color: Colors.white, size: 32.0),
                  shape: CircleBorder(),
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? Image.asset('assets/icons/active-clipboard.png', width: 60.0, height: 60.0, scale: 0.8,)
                : Image.asset('assets/icons/clipboard.png', width: 60.0, height: 60.0, scale: 0.8,),
            label: 'Планы',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 4
                ? Image.asset('assets/icons/active-person.png', width: 60.0, height: 60.0, scale: 0.8,)
                : Image.asset('assets/icons/person.png', width: 60.0, height: 60.0, scale: 0.8,),
            label: 'Профиль',
          ),
        ],
      ),

    );
  }

  Widget _buildExpandableContainer({
    required String title,
    required String iconPath,
    required bool isExpanded,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: onPressed,
                          icon: Image.asset(
                            isExpanded ? 'assets/icons/caret-up-outline.png' : 'assets/icons/caret-down.png',
                            width: 24.0,
                            height: 24.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: double.infinity,
                      height: 2.0,
                      color: Color(0xFFF2F2F2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: isExpanded ? null : 0,
            child: isExpanded ? child : null,
          ),
        ],
      ),
    );
  }

}

