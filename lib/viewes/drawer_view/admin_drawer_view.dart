import 'package:flutter/material.dart';
import 'package:gym_app/viewes/admin_view/exercise_list.dart';
import 'package:gym_app/viewes/course_view/AddCourseView.dart';
import 'package:gym_app/viewes/course_view/course_list_view.dart';

import 'package:gym_app/viewes/instructor_view/instructor_list_view.dart';
import 'package:gym_app/viewes/instructor_view/instructor_register_view.dart';
import 'package:gym_app/viewes/login/login.dart';
import 'package:gym_app/viewes/member_view/member_list_view.dart';
import 'package:gym_app/viewes/member_view/member_registration_view.dart';

class AdminDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Admin"),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image(
                  image: AssetImage('assets/avat.png'),
                  fit: BoxFit.cover,
                  //    width: 90,
                  //   height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              // image: DecorationImage(
              //  fit: BoxFit.fill,
              //       image: NetworkImage(
              //         'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list_alt_rounded),
            title: Text('Exercise List'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ExerciseListView()));
            },
          ),

          ListTile(
            leading: Icon(Icons.list),
            title: Text('instructor list'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InstructorListView()));
            },
          ),

          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Member List'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MemberListView()));
            },
          ),

          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Cource List'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CourseListView()));
            },
          ), ListTile(
            leading: Icon(Icons.logout_sharp),
            title: Text('Log out'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
              );
            },
          ),

          /*
          ListTile(
            leading: Icon(Icons.update),
            title: Text('گۆرانکاری وەصڵ'),
            onTap: () {  ShearData.checkIsInvoice_AddOrUpdate=true;
              Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => WholeSellNavBar()));}
        ,
          ),

     /*   ListTile(
            leading: Icon(Icons.update),
            title: Text('Tablet'),
            onTap: () {
              ShearData.checkIsInvoice_AddOrUpdate=false;
              Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => WholeSell_StockList3WithGridList()));}
        ,
          ),
*/
          ListTile(
            leading: Icon(Icons.update),
            title: Text('لێستی واصڵنەکراو'),
            onTap: () {
              PaymentShearData.checkIsInvoice_AddOrUpdate=false;
              Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => WholeSellPaymentNavBar()));}
        ,
          ),
         ListTile(
            leading: Icon(Icons.update),
            title: Text('ئاڵوگۆڕی مەخزەن'),
            onTap: () {
              ShearData2.checkIsInvoice_AddOrUpdate=false;
              Navigator.of(context).pop();
          //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NavBarWholeSell_MandubExchange()));}
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NavBarWholeSell_MandubExchange()));}
        ,
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('مەخزەنیی مەندووب'),
            onTap: () { Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => StockListMandub()));}
            ,
          ),
        /*  ListTile(
            leading: Icon(Icons.update),
            title: Text('ggg'),
            onTap: () {
              //ShearData.checkIsInvoice_AddOrUpdate=true;
          // Navigator.of(context).pop();
           // Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestScroll()));
            }
            ,
          ),*/
*/
          Divider(),
        ],
      ),
    );
  }
}
