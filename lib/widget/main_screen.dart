// import 'package:flutter/material.dart';
// import 'package:laqeene/pages/map.dart';

// import '../pages/chats.dart';
// import '../pages/location_page.dart';
// import '../pages/notification.dart';
// import '../pages/profile.dart';
// import '../pages/settings.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int index = 0;
//   //The PageStorage widget is used to store the state of the pages in the PageStorageBucket so that the state 
//   //is preserved when the user navigates between pages. 
//   final PageStorageBucket _bucket = PageStorageBucket();
//   Widget currentScreen = LocationPage();

//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: WillPopScope(
//         onWillPop: (){
//           return Future.value(false);
//         },
//         child: ScrollConfiguration(
//           behavior: const ScrollBehavior(),
//           child: GlowingOverscrollIndicator(
//             axisDirection: AxisDirection.down,
//             color: Color(0xff675492),
//             child: PageStorage(
//               bucket: _bucket,
//               child: currentScreen,
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         elevation: 0,
//         color: Colors.grey.shade100,
//         shape: CircularNotchedRectangle(),
//         notchMargin: 6,
//         child: SizedBox(
//           height: 65,
//           width: MediaQuery.of(context).size.width,
//           child: Padding(
//             padding: EdgeInsets.only(left: 2,right: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: MaterialButton(onPressed: ()
//                   {
//                   setState(() {
//                     index = 0;
//                     currentScreen = const LocationPage();
//                   });
//                 },
//                   child: index  == 0?Image.asset('assets/images/map.png',color: Colors.grey.shade800,height: 25,):
//                   Image.asset('assets/images/map2.png',height: 25,color: Colors.grey.shade800,),
//                 ),
//                 flex:1
//                 ),
//                 Expanded(
//                   child:  MaterialButton(onPressed: (){
//                   setState(() {
//                     index = 1;
//                     currentScreen = const chatsPage();
//                   });
//                 },
//                   child: index  == 1?Image.asset('assets/images/chats.png',color: Colors.grey.shade800,height: 25,):
//                   Image.asset('assets/images/chats2.png',height: 25,color: Colors.grey.shade800,),
//                 ),
//                 flex:1
//                 ),
//                   Expanded(
//                   child:  MaterialButton(onPressed: (){
//                   setState(() {
//                     index = 2;
//                     currentScreen = const notificationsPage();
//                   });
//                 },
//                   child: index  == 2?Image.asset('assets/images/notification.png',color: Colors.grey.shade800,height: 25,):
//                   Image.asset('assets/images/notification2.png',height: 25,color: Colors.grey.shade800,),
//                 ),
//                 flex:1
//                 ),
           
//                  Expanded(
//                   child:     MaterialButton(onPressed: (){
//                   setState(() {
//                     index = 4;
//                     currentScreen =  settingsPage();
//                   });
//                 },
//                   child: index  == 4?Image.asset('assets/images/settings-2.png',color: Colors.grey.shade800,height: 25,):
//                   Image.asset('assets/images/settings.png',height: 25,color: Colors.grey.shade800,),
//                 ),
//                 flex:1
//                 ),
             
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:laqeene/pages/contacts_page.dart';
import 'package:laqeene/pages/pages.dart';
// import 'package:chatter/screens/screens.dart';
import 'package:laqeene/theme.dart';
// import 'package:chatter/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laqeene/app.dart';
import 'package:laqeene/widget/glowing_action_button.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  final ValueNotifier<String> title = ValueNotifier('Messages');

  final pages = const [
    LocationPage(),
    chatsPage(),
    notificationsPage(),
    settingsPage(),
    
  ];

  final pageTitles = const [
    'LAQEENE',
    'MESSAGES',
    'Notifications',
    '\t\t\t\t\t',
  ];

  void _onNavigationItemSelected(index) {
    title.value = pageTitles[index];
    pageIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   iconTheme: Theme.of(context).iconTheme,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: ValueListenableBuilder(
      //     valueListenable: title,
      //     builder: (BuildContext context, String value, _) {
      //       return Text(
      //         value,
      //         style: const TextStyle(
      //           fontWeight: FontWeight.bold,
      //           fontSize: 17,
      //         ),
      //       );
      //     },
      //   ),
      //   leadingWidth: 54,
      //   // leading: Align(
      //   //   alignment: Alignment.centerRight,
      //   //   child: IconBackground(
      //   //     icon: Icons.search,
      //   //     onTap: () {
      //   //       print('TODO search');
      //   //     },
      //   //   ),
      //   // ),
      //   // actions: [
      //   //   Padding(
      //   //     padding: const EdgeInsets.only(right: 24.0),
      //   //     child: Hero(
      //   //       tag: 'hero-profile-picture',
      //   //       child: Avatar.small(
      //   //         url: context.currentUserImage,
      //   //         onTap: () {
      //   //           Navigator.of(context).push(ProfileScreen.route);
      //   //         },
      //   //       ),
      //   //     ),
      //   //   ),
      //   // ],
      // ),
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, _) {
          return pages[value];
        },
      ),
      bottomNavigationBar: _BottomNavigationBar(
        onItemSelected: _onNavigationItemSelected,
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  const _BottomNavigationBar({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  final ValueChanged<int> onItemSelected;

  @override
  __BottomNavigationBarState createState() => __BottomNavigationBarState();
}

class __BottomNavigationBarState extends State<_BottomNavigationBar> {
  var selectedIndex = 0;

  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Card(
      color: (brightness == Brightness.light) ? Colors.transparent : null,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 8, right: 8,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationBarItem(
                index: 0,
                lable: 'Map',
                icon: CupertinoIcons.map,
                isSelected: (selectedIndex == 0),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 1,
                lable: 'Chats',
                icon: CupertinoIcons.bubble_left_bubble_right_fill,
                isSelected: (selectedIndex == 1),
                onTap: handleItemSelected,
              ),
                 Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GlowingActionButton(
                  color: Color.fromARGB(255, 102, 154, 196),
                  icon: CupertinoIcons.add,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const Dialog(
                        child: AspectRatio(
                          aspectRatio: 8 / 7,
                          child: ContactsPage(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _NavigationBarItem(
                index: 2,
                lable: 'Notifications',
                icon: CupertinoIcons.bell_solid,
                isSelected: (selectedIndex == 2),
                onTap: handleItemSelected,
              ),
              _NavigationBarItem(
                index: 3,
                lable: 'Settings',
                icon: CupertinoIcons.settings,
                isSelected: (selectedIndex == 3),
                onTap: handleItemSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  const _NavigationBarItem({
    Key? key,
    required this.index,
    required this.lable,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final int index;
  final String lable;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppColors.secondary : null,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              lable,
              style: isSelected
                  ? const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    )
                  : const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}