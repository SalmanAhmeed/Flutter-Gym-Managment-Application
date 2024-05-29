import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/controllers/member_controller.dart';
import 'package:gym_app/dialogs/ShearCommonDialogs.dart';
import 'package:gym_app/dialogs/ShearCommonToastDialog.dart';
import 'package:gym_app/modules/member_model.dart';

class MemberListView extends StatefulWidget {
  @override
  _MemberListViewState createState() => _MemberListViewState();
}

class _MemberListViewState extends State<MemberListView> {
  late List<Member> _members;
  MemberController memberController = MemberController();
  @override
  void initState() {
    super.initState();
    _members = [];
    memberController.getMembers().listen((members) {
      setState(() {
        _members = members;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
      ),
      body: _members.isEmpty
          ? Center(
              child: Text('No members yet.'),
            )
          : ListView.builder(
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      // Navigate to Member Information view
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(member.imageUrl),
                        radius: 30,
                      ),
                      title: Text(
                        member.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(member.address),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          deleteMember(member, context);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    /*  floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Member Registration view
        },
        child: Icon(Icons.add),
      ),*/
    );
  }

  Future<void> deleteMember(Member member, BuildContext context) async {
    if (await ShearCommonDialogs.showMessageDialogYesNo(
        context, 'Are you sure to delete the member?', 'Deleting Member')) {
      ShearCommonDialogs.showLoaderDialog2(context);
      try {
        await memberController.deleteMember(member.docId, member.imageUrl);
        Navigator.of(context).pop(); //
      } catch (e) {
        // Handle any errors that might occur during member deletion
        print("Error deleting member: $e");
      }

      ShearCommonToastDialogs.showToastSuccess(context, 'Deleted successfully');
    }
  }
}
