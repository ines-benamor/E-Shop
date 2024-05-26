// import 'package:e_shop/ui/search_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:e_shop/ui/add-product-screen.dart';
// import 'package:e_shop/ui/home-screen.dart';
// import 'package:e_shop/ui/like_product_screen.dart';
// import 'package:e_shop/ui/notification_screen.dart';
// import 'package:e_shop/ui/profile-screen.dart';

// import '../widgets/bottomnavbar.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int currentIndex = 0;

//   final List<Widget> pages = [
//     HomeScreen(),
//     //CategoriesScreen(),
//     LikeProductScreen(),
//     AddProductScreen(),
//     NotificationScreen(),
//     ProfileScreen(
//       uid: FirebaseAuth.instance.currentUsers!.uid,
//     ),
//     //ProfileGeneral(uid:,),
//   ];

//   final TextEditingController searchEditingController = TextEditingController();
//   bool isShowUsers = false;

//   @override
//   void dispose() {
//     super.dispose();
//     searchEditingController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context);
//     final double height = screenSize.size.height;
//     final double width = screenSize.size.width;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.grey.shade50,
//         title: Row(
//           children: [
//             TextField(
//               controller: searchEditingController,
//               style: TextStyle(fontSize: 13.0),
//               readOnly: true,
//               decoration: InputDecoration(
//                 hintText: 'Recherche',
//                 contentPadding: EdgeInsets.only(top: 5, bottom: 5),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   size: 25.0,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               onSubmitted: (_) {
//                 setState(() {
//                   isShowUsers = true;
//                 });
//               },
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SearchScreen(),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(
//               height: height / 20,
//               width: width / 10,
//               child: IconButton(
//                 onPressed: () {},
//                 icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: IndexedStack(
//         index: currentIndex,
//         children: pages,
//       ),
//       bottomNavigationBar: BottomNavigationBarWidget(
//         currentIndex: currentIndex,
//         onTap: (int index) {
//           setState(() {
//             currentIndex = index;
//             isShowUsers = false;
//           });
//         },
//       ),
//     );
//   }
// }
