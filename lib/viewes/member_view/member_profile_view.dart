import 'package:flutter/material.dart';
import 'package:gym_app/controllers/member_controller.dart';
import 'package:gym_app/modules/member_model.dart';
import 'package:gym_app/viewes/login/login.dart';

class MemberProfileView extends StatefulWidget {
  @override
  _MemberProfileViewState createState() => _MemberProfileViewState();
}

class _MemberProfileViewState extends State<MemberProfileView> {
  final MemberController _memberController = MemberController();
  late Member _member;

  @override
  void initState() {
    super.initState();
    _fetchMember();
  }

  Future<void> _fetchMember() async {
    Member? member = await _memberController.getMemberByUid(LoginPageState.logidUserID);
    if (member != null) {
      setState(() {
        _member = member;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _member != null ? _buildMemberInfo() : _buildLoading(),
    );
  }

  Widget _buildMemberInfo() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    _member.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Theme.of(context).primaryColor.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16.0,
                child: Text(
                 "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          _buildInfoContainer('Name', _member.name),
          _buildInfoContainer('Address', _member.address),
          _buildInfoContainer('Phone', _member.phone),
          _buildInfoContainer('Email', _member.email),
          _buildInfoContainer('Weight', _member.weight.toString()),
          _buildInfoContainer('Height', _member.height.toString()),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
