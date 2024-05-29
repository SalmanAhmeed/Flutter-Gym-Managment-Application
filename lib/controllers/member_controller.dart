import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gym_app/modules/member_model.dart';
import 'package:gym_app/viewes/login/login.dart';

class MemberController {
  final CollectionReference _membersCollection =
      FirebaseFirestore.instance.collection('members');

  Future<void> addMember(Member member, File imageFile) async {
    String imageUrl = await _uploadImage(imageFile);
    await _membersCollection.add(member.toMap());
  }

  Future<void> deleteMember(String docId, String imageUrl) async {
    await _membersCollection.doc(docId).delete();
    await _deleteImage(imageUrl);
  }

  Future<void> updateMember(String docId, Member newMember, File? newImageFile,
      String oldImageUrl) async {
    String imageUrl =
        newImageFile != null ? await _uploadImage(newImageFile) : oldImageUrl;
    await _membersCollection.doc(docId).update(newMember.toMap());
    if (newImageFile != null) {
      await _deleteImage(oldImageUrl);
    }
  }

  Stream<List<Member>> getMembers() {
    return _membersCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return Member.fromMap(doc.id, data);
            }).toList());
  }

  Future<String> _uploadImage(File imageFile) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('member_images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.whenComplete(() => null);
    return await storageReference.getDownloadURL();
  }

  Future<void> _deleteImage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    }
  }



  Future<Member?> getMemberByUid(String uid) async {
    try {
      if (uid == null) {
        return null;
      }
      print(uid);

      QuerySnapshot membersSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (membersSnapshot.docs.isNotEmpty) {
        DocumentSnapshot memberDoc = membersSnapshot.docs.first;
        return Member.fromMap(memberDoc.id, memberDoc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      // Handle error
      print('Error fetching member: $e');
      return null;
    }
  }

}
