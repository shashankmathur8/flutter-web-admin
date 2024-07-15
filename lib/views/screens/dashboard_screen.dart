
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:web_admin/companyModel.dart';
import 'package:web_admin/companyService.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/theme/theme_extensions/app_color_scheme.dart';
import 'package:web_admin/theme/theme_extensions/app_data_table_theme.dart';
import 'package:web_admin/utils/styles.dart';
import 'package:web_admin/views/widgets/card_elements.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

import '../../localStorage.dart';
import '../../root_app.dart';
import '../../userModel.dart';
import '../../userService.dart';
import '../../utils/genericOverlay.dart';


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
  final textEditingController = TextEditingController();
  late StringTagController _stringTagController4 ;
  List<DropdownMenuItem<String>> dropdownList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
    getCompanies();
    dropdownList=[DropdownMenuItem(
      value: "1",
      child: Text("1"),
    ),DropdownMenuItem(
      value: "2",
      child: Text("2"),
    ),DropdownMenuItem(
      value: "3",
      child: Text("3"),
    ),DropdownMenuItem(
      value: "4",
      child: Text("4"),
    ),DropdownMenuItem(
      value: "5",
      child: Text("5"),
    ),DropdownMenuItem(
      value: "6",
      child: Text("6"),
    ),DropdownMenuItem(
      value: "7",
      child: Text("7"),
    ),];
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
  var dropdownvalue = ''.obs;
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
  var valueCheckBox1=false.obs;
  var valueCheckBox2=false.obs;
  var valueCheckBox3=false.obs;


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
                              widget.users = widget.users.where((element) => element.username!.contains(textEditingControlllerUsersSearch.text)).toList();
                              widget.userLength.value = widget.users.length;

                            }else if(dropDownValueUsersFilter=="email"){
                              swapList=widget.users;
                              widget.users = widget.users.where((element) => element.email!.contains(textEditingControlllerUsersSearch.text) ).toList();
                              widget.userLength.value = widget.users.length;

                            }else if(dropDownValueUsersFilter=="companyID"){
                              swapList=widget.users;
                              widget.users = widget.users.where((element) => element.companyID!.contains(textEditingControlllerUsersSearch.text) ).toList();
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
                                      DataColumn(label: Text('Email')),
                                      DataColumn(label: Text('Username')),
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
                                          DataCell(Text('${widget.users[index].username.toString().split("@").first}')),
                                          DataCell(Text('${widget.users[index].companyID}')),
                                          DataCell(Text('${widget.users[index].isEnabled}')),
                                          DataCell(Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.delete_forever),
                                                onPressed: () {
                                                  Navigator.of(context).push(GenericOverlay(
                                                    iconPath: 'assets/images/editPerm.png',
                                                    title: 'Delete',
                                                    positiveButtonText: 'Delete',
                                                    negativeButtonText: 'Cancel',
                                                    messageWidget: Text("Do You Wish to delete the User?"),
                                                    onPositivePressCallback: () {
                                                      String mainAccessToken = LocalStorageHelper().getString("accessToken");
                                                      UserService().deleteUserFromAzure(context, mainAccessToken,
                                                          "usernameController.text", widget.users[index].email.toString()).then((onValue){
                                                            if(onValue){
                                                              deleteUser(widget.users[index]);
                                                              widget.users
                                                                  .removeWhere((element) => element.email == widget.users[index].email);
                                                              widget.userLength.value = widget.users.length;
                                                              Navigator.pop(context);
                                                            }else{
                                                              var snackBar = SnackBar(
                                                                content: Text('Error Deleting User'),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              Navigator.pop(context);
                                                            }
                                                      });
                                                    },
                                                    onNegativePressCallback: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ));
                                                },
                                              ),
                                              IconButton(icon: Icon(Icons.edit), onPressed: () {
                                                dropdownvalue.value=widget.users[index].accessLevel.toString();
                                                List<String> xyz=[];
                                               if(widget.users[index].level3Access!=null) {
                                                 xyz.clear();
                                                    for (var x in widget.users[index].level3Access!) {
                                                      xyz.add(x.toString());
                                                    }
                                                  }
                                               print("value = ${dropdownvalue.value=="6"}");
                                                valueCheckBox1.value=widget.users[index].isLevel1Enabled??false;
                                                valueCheckBox2.value=widget.users[index].isLevel2Enabled??false;
                                                valueCheckBox3.value=widget.users[index].isLevel3Enabled??false;
                                                  Navigator.of(context).push(GenericOverlay(
                                                  iconPath: 'assets/images/editPerm.png',
                                                  title: 'Permissions',
                                                  positiveButtonText: 'Assign',
                                                  negativeButtonText: 'Cancel',
                                                  messageWidget: Center(
                                                    child: Obx(()=>Column(
                                                      children: [
                                                        DropdownButton(
                                                          style: AppStyles.t16NPrimaryColor,
                                                        
                                                            // Initial Value
                                                            value: dropdownvalue.value,
                                                        
                                                            // Down Arrow Icon
                                                            icon: const Icon(Icons.keyboard_arrow_down),
                                                        
                                                            // Array list of items
                                                            items: dropdownList,
                                                            // After selecting the desired option,it will
                                                            // change button value to selected value
                                                            onChanged: (String? newValue) {
                                                              setState(() {
                                                                dropdownvalue.value = newValue!;
                                                              });
                                                            },
                                                          ),
                                                        Visibility(
                                                          visible: dropdownvalue.value=="6",
                                                          child: TextFieldTags<String>(
                                                            textfieldTagsController: _stringTagController4 = StringTagController(),
                                                            initialTags: xyz??[""],
                                                            textSeparators: const [' ', ','],
                                                            letterCase: LetterCase.normal,
                                                            validator: (String tag) {
                                                              if (tag == 'php') {
                                                                return 'No, please just no';
                                                              } else if (_stringTagController4.getTags!.contains(tag)) {
                                                                return 'You\'ve already entered that';
                                                              }
                                                              return null;
                                                            },
                                                            inputFieldBuilder: (context, inputFieldValues) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(20.0),
                                                                child: TextField(
                                                                  onTap: () {
                                                                    _stringTagController4.getFocusNode?.requestFocus();
                                                                  },
                                                                  controller: inputFieldValues.textEditingController,
                                                                  focusNode: inputFieldValues.focusNode,
                                                                  decoration: InputDecoration(
                                                                    isDense: true,
                                                                    errorText: inputFieldValues.error,
                                                                    prefixIcon: inputFieldValues.tags.isNotEmpty
                                                                        ? SingleChildScrollView(
                                                                      controller: inputFieldValues.tagScrollController,
                                                                      scrollDirection: Axis.vertical,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(
                                                                          top: 8,
                                                                          bottom: 8,
                                                                          left: 8,
                                                                        ),
                                                                        child: Wrap(
                                                                            runSpacing: 4.0,
                                                                            spacing: 4.0,
                                                                            children:
                                                                            inputFieldValues.tags.map((String tag) {
                                                                              return Container(
                                                                                decoration: const BoxDecoration(
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(20.0),
                                                                                  ),
                                                                                  color:
                                                                                  Color.fromARGB(255, 74, 137, 92),
                                                                                ),
                                                                                margin: const EdgeInsets.symmetric(
                                                                                    horizontal: 5.0),
                                                                                padding: const EdgeInsets.symmetric(
                                                                                    horizontal: 10.0, vertical: 5.0),
                                                                                child: Row(
                                                                                  mainAxisAlignment:
                                                                                  MainAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      child: Text(
                                                                                        '#$tag',
                                                                                        style: const TextStyle(
                                                                                            color: Colors.white),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        //print("$tag selected");
                                                                                      },
                                                                                    ),
                                                                                    const SizedBox(width: 4.0),
                                                                                    InkWell(
                                                                                      child: const Icon(
                                                                                        Icons.cancel,
                                                                                        size: 14.0,
                                                                                        color: Color.fromARGB(
                                                                                            255, 233, 233, 233),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        inputFieldValues
                                                                                            .onTagRemoved(tag);
                                                                                      },
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }).toList()),
                                                                      ),
                                                                    )
                                                                        : null,
                                                                  ),
                                                                  onChanged: inputFieldValues.onTagChanged,
                                                                  onSubmitted: inputFieldValues.onTagSubmitted,
                                                                ),
                                                              );
                                                            },
                                                          ),),
                                                        Visibility(
                                                          visible: dropdownvalue.value=="6",

                                                            child: InkWell(
                                                          onTap: (){
                                                            _stringTagController4.clearTags();
                                                            List tags=getCompanyTags(widget.users[index].companyID.toString(),widget.companies);
                                                            for(var x in tags){
                                                              _stringTagController4.addTag(x.toString());
                                                            }
                                                          },
                                                          child: Container(
                                                            color: const Color.fromARGB(255, 74, 137, 92),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Text("Reset",style: AppStyles.t16NWhite,),
                                                            ),
                                                          ),
                                                        )),
                                                      Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Obx(()=>Checkbox(value: valueCheckBox1.value, onChanged: (value){
                                                              setState(() {
                                                                this.valueCheckBox1.value = value!;
                                                              });
                                                            }),
                                                            ),
                                                            Text("L1"),
                                                          ],
                                                        ),Column(
                                                          children: [
                                                            Obx(()=>Checkbox(value: valueCheckBox2.value, onChanged: (value){
                                                              setState(() {
                                                                this.valueCheckBox2.value = value!;
                                                              });
                                                            }),
                                                            ),
                                                            Text("L2"),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Obx(()=>Checkbox(value: valueCheckBox3.value, onChanged: (value){
                                                              setState(() {
                                                                print("$value");
                                                                this.valueCheckBox3.value = value!;
                                                              });
                                                            }),
                                                            ),
                                                            Text("L3"),
                                                          ],
                                                        )
                                                      ],)
                                                      ],
                                                    ),
                                                    ),
                                                  ) ,
                                                  onPositivePressCallback: () {
                                                   var list= _stringTagController4.getTags;
                                                    widget.users[index].accessLevel=dropdownvalue.value;
                                                   widget.users[index].level3Access=list;
                                                   widget.users[index].isLevel1Enabled=valueCheckBox1.value;
                                                   widget.users[index].isLevel2Enabled=valueCheckBox2.value;
                                                   widget.users[index].isLevel3Enabled=valueCheckBox3.value;

                                                    changeUserPermission(widget.users[index],dropdownvalue.value,list);
                                                    Navigator.pop(context);
                                                  },
                                                  onNegativePressCallback: () {
                                                    Navigator.pop(context);
                                                  },
                                                ));
                                              },),
                                              IconButton(icon: Icon(Icons.message), onPressed: () {

                                                Navigator.of(context).push(GenericOverlay(
                                                  iconPath: 'assets/images/mail.png',
                                                  title: 'Send Message',
                                                  positiveButtonText: 'Send',
                                                  negativeButtonText: 'Cancel',
                                                  messageWidget: Center(
                                                    child: TextField(
                                                      controller: textEditingController,
                                                    )
                                                  ) ,
                                                  onPositivePressCallback: () {
                                                    print("Before ${widget.users[index].notif}");
                                                    sendMessageToUser(widget.users[index],textEditingController.text);
                                                    textEditingController.text="";
                                                    print("After ${widget.users[index].notif}");
                                                    Navigator.pop(context);
                                                  },
                                                  onNegativePressCallback: () {
                                                    textEditingController.text="";
                                                    Navigator.pop(context);
                                                  },
                                                ));
                                              },)

                                            ],
                                          )),

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
                                          Navigator.of(context).push(GenericOverlay(
                                            iconPath: 'assets/images/editPerm.png',
                                            title: 'Delete',
                                            positiveButtonText: 'Delete',
                                            negativeButtonText: 'Cancel',
                                            messageWidget: Text("Do You Wish to delete the Company?"),
                                            onPositivePressCallback: () {
                                              deleteCompany(widget.companies[index]);
                                              widget.companies.removeWhere((element) => element.name==widget.companies[index].name);
                                              widget.companiesLength.value=widget.companies.length;
                                              Navigator.pop(context);
                                            },
                                            onNegativePressCallback: () {
                                              Navigator.pop(context);
                                            },
                                          ));
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
void changeUserPermission(User user,String value,var list) {
  UserService().updateUserAccess(user,value,list);
}
void sendMessageToUser(User user,String value) {
  UserService().sendUserMessage(user,value);
}
deleteUser(User user){
  UserService().deleteUser(user);

}
getCompanyTags(String companyId,List<Company>companies){
  var company=companies.where((element)=>element.companyID==companyId).first;
  List temp=[];
  for(var x in company.level1Status!){
    temp.add(x);
  }
  for(var x in company.level2Status!){
    temp.add(x);
  }
  for(var x in company.level3Status!){
    temp.add(x);
  }
  return temp;
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
