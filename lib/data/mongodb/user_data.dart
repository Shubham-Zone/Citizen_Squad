// import 'package:abondon_vehicle/Mongodb/MongoProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'UsersModel.dart';
//
// class UserData extends StatelessWidget {
//
//   const UserData({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Consumer<MongoProvider>(
//         builder: (context, provider, _) {
//           if (provider.db == null) {
//             provider.connectToMongo();
//             return const Center(child: CircularProgressIndicator());
//           } else {
//             return FutureBuilder<List<User>>(
//               future: provider.getData(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else {
//                   List<User> userList = snapshot.data as List<User>; // Ensure correct type
//                   return ListView.builder(
//                     itemCount: userList.length,
//                     itemBuilder: (context, index) {
//                       User user = userList[index];
//                       return ListTile(
//                         title: Text(user.name),
//                         subtitle: Text(user.email),
//                       );
//                     },
//                   );
//                 }
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
