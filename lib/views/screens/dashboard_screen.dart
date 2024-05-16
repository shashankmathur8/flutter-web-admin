
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:web_admin/companyModel.dart';
import 'package:web_admin/companyService.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/theme/theme_extensions/app_color_scheme.dart';
import 'package:web_admin/theme/theme_extensions/app_data_table_theme.dart';
import 'package:web_admin/views/widgets/card_elements.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

import '../../root_app.dart';
import '../../userModel.dart';
import '../../userService.dart';


class DashboardScreen extends StatefulWidget {
   DashboardScreen({super.key});
  List<User>users=[];
   List<Company>companies=[];

   var companiesLength=0.obs;
   var userLength=0.obs;

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  final _dataTableHorizontalScrollController = ScrollController();
  final _dataTableHorizontalScrollController2 = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
    getCompanies();
  }

  getCompanies(){
    CompanyService().fetchAllCompany().then((value) {
      widget.companies = value.toList();
      widget.companiesLength.value=widget.companies.length;
    });
  }
  getUsers(){

    UserService().fetchAllUser().then((value) {
      widget.users = value.toList();
      widget.userLength.value=widget.users.length;
    });

  }
  String dropdownvalue = 'Item 1';
  String dropDownValueUsersFilter= 'username';
  String dropDownValueCompanyFilter= 'username';
  TextEditingController textEditingControlllerUsersSearch=TextEditingController();
  TextEditingController textEditingControlllerCompanySearch=TextEditingController();

  // List of items in our dropdown menu
  var items = [
    const DropdownMenuItem(value: "username",
      child: Text("UserName"),),
    const DropdownMenuItem(value: "email",
      child: Text("Email"),),
    const DropdownMenuItem(value: "companyID",
      child: Text("Company ID"),),
  ];
  List<User> swapList=[];
  List<Company> swapList2=[];

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    final size = MediaQuery.of(context).size;

    final summaryCardCrossAxisCount = (size.width >= kScreenWidthLg ? 4 : 2);

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            lang.dashboard,
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final summaryCardWidth = ((constraints.maxWidth - (kDefaultPadding * (summaryCardCrossAxisCount - 1))) / summaryCardCrossAxisCount);

                return Wrap(
                  direction: Axis.horizontal,
                  spacing: kDefaultPadding,
                  runSpacing: kDefaultPadding,
                  children: [
                    Obx(()=>SummaryCard(
                        title: lang.newUsers(2),
                        value: '${widget.userLength.value}',
                        icon: Icons.group_add_rounded,
                        backgroundColor: appColorScheme.warning,
                        textColor: appColorScheme.buttonTextBlack,
                        iconColor: Colors.black12,
                        width: summaryCardWidth,
                      ),
                    ),
                    Obx(()=>SummaryCard(
                      title: "Companies",
                      value: '${widget.companiesLength.value}',
                      icon: Icons.group_add_rounded,
                      backgroundColor: appColorScheme.warning,
                      textColor: appColorScheme.buttonTextBlack,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardHeader(
                    title: lang.recentOrders(2),
                    showDivider: false,
                  ),Container(
                    child: Row(
                      children: [
                        SizedBox(width: 200,
                          child: TextFormField(
                            controller: textEditingControlllerUsersSearch,
                          ),
                        ),
                        DropdownButton(items: items, value: dropDownValueUsersFilter,onChanged: (value){
                          setState(() {
                            dropDownValueUsersFilter = value!;
                          });

                        }),
                        GestureDetector(
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                            child: Center(child:Text("Search")),
                          ),
                          onTap: (){
                            if(dropDownValueUsersFilter=="username"){
                              swapList=widget.users;
                              widget.users = widget.users.where((element) => element.username == textEditingControlllerUsersSearch.text).toList();
                              widget.userLength.value = widget.users.length;

                            }else if(dropDownValueUsersFilter=="email"){
                              swapList=widget.users;
                              widget.users = widget.users.where((element) => element.email == textEditingControlllerUsersSearch.text).toList();
                              widget.userLength.value = widget.users.length;

                            }else if(dropDownValueUsersFilter=="companyID"){
                              swapList=widget.users;
                              widget.users = widget.users.where((element) => element.companyID == textEditingControlllerUsersSearch.text).toList();
                              widget.userLength.value = widget.users.length;

                            }

                          },
                        ),
                        GestureDetector(
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                            child: Center(child:Text("Clear")),
                          ),
                          onTap: (){
                            textEditingControlllerUsersSearch.text = "";
                            widget.users = swapList;
                            widget.userLength.value=swapList.length;



                          },
                        )

                      ],
                    ),
                  ),



                  /*filterUI(DashboardScreenState,widget,swapList,items,dropDownValueUsersFilter,textEditingControlllerUsersSearch,widget.userLength,"user"),
                  */
                  SizedBox(
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double dataTableWidth = max(kScreenWidthMd, constraints.maxWidth);

                        return Scrollbar(
                          controller: _dataTableHorizontalScrollController,
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _dataTableHorizontalScrollController,
                            child: SizedBox(
                              width: dataTableWidth,
                              child: Theme(
                                data: themeData.copyWith(
                                  cardTheme: appDataTableTheme.cardTheme,
                                  dataTableTheme: appDataTableTheme.dataTableThemeData,
                                ),
                                child: Obx(()=>DataTable(
                                    showCheckboxColumn: widget.userLength.value==0?false:false,
                                    showBottomBorder: true,
                                    columns: const [
                                      DataColumn(label: Text('No.'), numeric: true),
                                      DataColumn(label: Text('Username')),
                                      DataColumn(label: Text('Email')),
                                      DataColumn(label: Text('NAme'), numeric: true),
                                      DataColumn(label: Text("Company"), numeric: true),
                                      DataColumn(label: Text('isEnable'), numeric: true),
                                      DataColumn(label: Text('Action')),
                                    ],
                                    rows: List.generate(widget.users.length, (index) {
                                      return DataRow.byIndex(
                                        index: index,
                                        cells: [
                                          DataCell(Text('#${index + 1}')),
                                          DataCell(Text('${widget.users[index].email}')),
                                          DataCell(Text('${widget.users[index].username}')),
                                          DataCell(Text('${widget.users[index].email}')),
                                          DataCell(Text('${widget.users[index].companyID}')),
                                          DataCell(Text('${widget.users[index].isEnabled}')),
                                          DataCell(IconButton(icon: Icon(Icons.delete_forever), onPressed: () {
                                            deleteUser(widget.users[index]);
                                            widget.users.removeWhere((element) => element.email==widget.users[index].email);
                                            widget.userLength.value=widget.users.length;
                                          },)),

                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardHeader(
                    title: "Companies",
                    showDivider: false,
                  ),
                  /*
                  filterUI(DashboardScreenState,widget,swapList2,items,dropDownValueCompanyFilter,textEditingControlllerCompanySearch,widget.companiesLength,"company"),
                  */
                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 200,
                          child: TextFormField(
                            controller: textEditingControlllerCompanySearch,
                          ),
                        ),
                        DropdownButton(items: items, value: dropDownValueCompanyFilter,onChanged: (value){
                          setState(() {
                            dropDownValueCompanyFilter = value!;
                          });

                        }),
                        GestureDetector(
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                            child: Center(child:Text("Search")),
                          ),
                          onTap: (){
                            if(dropDownValueCompanyFilter=="username"){
                              swapList2=widget.companies;
                              widget.companies = widget.companies.where((element) => element.name == textEditingControlllerCompanySearch.text).toList();
                              widget.companiesLength.value = widget.companies.length;

                            }else if(dropDownValueCompanyFilter=="email"){
                              swapList2=widget.companies;
                              widget.companies = widget.companies.where((element) => element.email == textEditingControlllerCompanySearch.text).toList();
                              widget.companiesLength.value = widget.companies.length;

                            }else if(dropDownValueCompanyFilter=="companyID"){
                              swapList2=widget.companies;
                              widget.companies = widget.companies.where((element) => element.companyID == textEditingControlllerCompanySearch.text).toList();
                              widget.companiesLength.value = widget.companies.length;

                            }

                          },
                        ),
                        GestureDetector(
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.red,
                            child: Center(child:Text("Clear")),
                          ),
                          onTap: (){
                            textEditingControlllerCompanySearch.text = "";
                            widget.companies = swapList2;
                            widget.companiesLength.value=swapList2.length;



                          },
                        )

                      ],
                    ),
                  ),


                  SizedBox(
                    width: double.infinity,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final double dataTableWidth = max(kScreenWidthMd, constraints.maxWidth);

                        return Scrollbar(
                          controller: _dataTableHorizontalScrollController2,
                          thumbVisibility: true,
                          trackVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _dataTableHorizontalScrollController2,
                            child: SizedBox(
                              width: dataTableWidth,
                              child: Theme(
                                data: themeData.copyWith(
                                  cardTheme: appDataTableTheme.cardTheme,
                                  dataTableTheme: appDataTableTheme.dataTableThemeData,
                                ),
                                child: Obx(()=>DataTable(
                                  showCheckboxColumn: widget.companiesLength.value==0?false:false,
                                  showBottomBorder: true,
                                  columns: const [

                                    DataColumn(label: Text('Index.'), ),
                                    DataColumn(label: Text('Name.'), ),
                                    DataColumn(label: Text('Email')),
                                    DataColumn(label: Text('Company ID')),
                                    DataColumn(label: Text('Actions')),
                                  ],
                                  rows: List.generate(widget.companies.length, (index) {
                                    return DataRow.byIndex(
                                      index: index,
                                      cells: [
                                        DataCell(Text('#${index + 1}')),
                                        DataCell(Text('${widget.companies[index].name}')),
                                        DataCell(Text('${widget.companies[index].email}')),
                                        DataCell(Text('${widget.companies[index].companyID}')),
                                        DataCell(IconButton(icon: Icon(Icons.delete_forever), onPressed: () {
                                          deleteCompany(widget.companies[index]);
                                          widget.companies.removeWhere((element) => element.name==widget.companies[index].name);
                                          widget.companiesLength.value=widget.companies.length;
                                        },)),

                                      ],
                                    );
                                  }),
                                ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
deleteUser(User user){
  UserService().deleteUser(user);

}

Widget filterUI(state,widget,swapList,dropDownItems,dropDownValue,TextEditingController textEditingController,listRefreshValue,type){
  return Container(
    child: Row(
      children: [
        SizedBox(width: 200,
          child: TextFormField(
              controller: textEditingController,
          ),
        ),
        DropdownButton(items: dropDownItems, value: dropDownValue,onChanged: (value){
          state.setState(() {
            dropDownValue = value!;
          });

        }),
        GestureDetector(
          child: Container(
            width: 50,
            height: 50,
            color: Colors.red,
            child: Center(child:Text("Search")),
          ),
          onTap: (){
            if(dropDownValue=="username"){
              if(type=="user") {
                swapList=widget.users;
                widget.users = widget.users.where((element) => element.username == textEditingController.text).toList();
                listRefreshValue.value = widget.users.length;
              }else{
                swapList=widget.companies;
              widget.companies = widget.companies.where((element) => element.name == textEditingController.text).toList();
                listRefreshValue.value = widget.companies.length;
              }
            }else if(dropDownValue=="email"){
              if(type=="user") {
                swapList=widget.users;
                widget.users = widget.users.where((element) => element.email == textEditingController.text).toList();
                listRefreshValue.value = widget.users.length;
              }else{
                swapList=widget.companies;
                widget.companies = widget.companies.where((element) => element.email == textEditingController.text).toList();
                listRefreshValue.value = widget.companies.length;
              }
            }else if(dropDownValue=="companyID"){
              if(type=="user") {
                swapList=widget.users;
                widget.users = widget.users.where((element) => element.companyID == textEditingController.text).toList();
                listRefreshValue.value = widget.users.length;
              }else{
                swapList=widget.companies;
                widget.companies = widget.companies.where((element) => element.companyID == textEditingController.text).toList();
                listRefreshValue.value = widget.companies.length;
              }
            }

          },
        ),
        GestureDetector(
          child: Container(
            width: 50,
            height: 50,
            color: Colors.red,
            child: Center(child:Text("Clear")),
          ),
          onTap: (){
            if (type == "user") {
              textEditingController.text = "";
              widget.users = swapList;
              listRefreshValue.value=swapList.length;
            }else{
              textEditingController.text = "";
              widget.companies = swapList;
              listRefreshValue.value=swapList.length;
            }


          },
        )

      ],
    ),
  );
}
deleteCompany(Company company){
  CompanyService().deleteCompany(company);

}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double width;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 120.0,
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: backgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: kDefaultPadding * 0.5,
              right: kDefaultPadding * 0.5,
              child: Icon(
                icon,
                size: 80.0,
                color: iconColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: kDefaultPadding * 0.5),
                    child: Text(
                      value,
                      style: textTheme.headlineMedium!.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: textTheme.labelLarge!.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
