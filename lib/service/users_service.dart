import 'package:cloud_firestore/cloud_firestore.dart';
 String? userID;
class User {
  String? status;
  String name;
  String email;
  String photo;
  String? id;
  User({
    this.status="fail",
    required this.name,
    required this.email,
    required this.photo,
    // required this.id,
  });

  //veri çekme
  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      // id: data["userId"],
      name: data['username'],
      email: data['email'],
      photo: data["photoUrl"]
    );
  }
}
//veri ekleme
void addUser({name, email, photo}) {
  User user = User(name: name, email: email, photo: photo);

  FirebaseFirestore.instance
      .collection('users')
      .add({
        'username': user.name,
        'email': user.email,
        'photoUrl': user.photo,
      })
      .then((value) {
        userID = value.id;
        user.id=value.id; // Oluşturulan dökümanın IDsini al
        // Oluşturulan dökümana userId değerini güncelleme
        FirebaseFirestore.instance.collection('users').doc(userID).update({
          'userId': userID,
        }).then((value) {
          print('User added successfully!');
        }).catchError((error) {
          print('Failed to update userId: $error');
        });
      })
      .catchError((error) {
        print('Failed to add user: $error');
      });
}

//FİREBASE KULLANICI KONTROLÜ
   Future<String> checkIfUserExists(String email) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (result.docs.isNotEmpty) {
    DocumentSnapshot doc = result.docs.first;
    print("USERID: ${doc.id}");
    return doc.id ; // userId değerini döndür
  } else {
    return "";
  }
}