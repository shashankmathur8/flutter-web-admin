import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/providers/user_data_provider.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/userModel.dart';
import 'package:web_admin/userService.dart';
import 'package:web_admin/utils/app_focus_helper.dart';
import 'package:web_admin/views/widgets/public_master_layout/public_master_layout.dart';

import '../../companyModel.dart';
import '../../companyService.dart';
import '../../localStorage.dart';

class RegisterScreen extends StatefulWidget {
  List<Company>companies=[];

  var companiesLength=0.obs;
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _passwordTextEditingController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();

  var _isFormLoading = false;

  @override
  initState() {
    print("initState Called");
    getCompanies();
  }

  Future<void> _doRegisterAsync({
    required UserDataProvider userDataProvider,
    required void Function(String message) onSuccess,
    required void Function(String message) onError,
  }) async {
    AppFocusHelper.instance.requestUnfocus();

    if (_formKey.currentState?.validate() ?? false) {
      // Validation passed.
      _formKey.currentState!.save();

      setState(() => _isFormLoading = true);

      Future.delayed(const Duration(seconds: 1), () async {
        if (_formData.username == 'admin') {
          onError.call('This username is already taken.');
        } else {
          await userDataProvider.setUserDataAsync(
            username: 'Admin ABC',
            userProfileImageUrl: 'https://picsum.photos/id/1005/300/300',
          );

          onSuccess.call('Your account has been successfully created.');
        }

        setState(() => _isFormLoading = false);
      });
    }
  }

  void _onRegisterSuccess(BuildContext context, String message) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      desc: message,
      width: kDialogWidth,
      btnOkText: Lang.of(context).loginNow,
      btnOkOnPress: () => GoRouter.of(context).go(RouteUri.home),
    );

    dialog.show();
  }

  void _onRegisterError(BuildContext context, String message) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      desc: message,
      width: kDialogWidth,
      btnOkText: 'OK',
      btnOkOnPress: () {},
    );

    dialog.show();
  }

  @override
  void dispose() {
    _passwordTextEditingController.dispose();

    super.dispose();
  }
  getCompanies() async{
    await  CompanyService().fetchAllCompany().then((value) {
      widget.companies = value.toList();
    });
    if(widget.companies.isNotEmpty){
      dropdownvalue=widget.companies.first.name.toString();
    }
    items.clear();
    for(Company company in widget.companies){
      items.add(company.name.toString());
    }
    widget.companiesLength.value=widget.companies.length;

  }
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);

    return PublicMasterLayout(
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.only(top: kDefaultPadding * 5.0),
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        height: 80.0,
                      ),
                    ),
                    Text(
                      lang.appTitle,
                      style: themeData.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                      child: Text(
                        lang.registerANewAccount,
                        style: themeData.textTheme.titleMedium,
                      ),
                    ),
                    FormBuilder(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              name: 'username',
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: lang.username,
                                hintText: lang.username,
                                helperText: '* To test registration fail: admin',
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              validator: FormBuilderValidators.required(),
                              onSaved: (value) => (_formData.username = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              name: 'email',
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: lang.email,
                                hintText: lang.email,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: FormBuilderValidators.required(),
                              onSaved: (value) => (_formData.email = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
                            child: FormBuilderTextField(
                              name: 'password',
                              decoration: InputDecoration(
                                labelText: lang.password,
                                hintText: lang.password,
                                helperText: lang.passwordHelperText,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              obscureText: true,
                              controller: _passwordTextEditingController,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(6),
                                FormBuilderValidators.maxLength(18),
                              ]),
                              onSaved: (value) => (_formData.password = value ?? ''),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                            child: FormBuilderTextField(
                              name: 'retypePassword',
                              decoration: InputDecoration(
                                labelText: lang.retypePassword,
                                hintText: lang.retypePassword,
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              obscureText: true,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                (value) {
                                  if (_formKey.currentState?.fields['password']?.value != value) {
                                    return lang.passwordNotMatch;
                                  }

                                  return null;
                                },
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                            child: Obx(()=>DropdownButton(

                                // Initial Value
                                value: dropdownvalue,
                                isExpanded: widget.companiesLength.value==0?true:true,

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                // Array list of items
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding),
                            child: SizedBox(
                              height: 40.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: themeData.extension<AppButtonTheme>()!.primaryElevated,
                                onPressed: (_isFormLoading
                                    ? null
                                    : ()  {
                                  var company=widget.companies.where((element) => element.name=="${dropdownvalue}").first;
                                  var companyID=company.companyID;
                                  List xyz=[];
                                  xyz.addAll(company.level1Status!.toList());
                                  xyz.addAll(company.level2Status!.toList());
                                  xyz.addAll(company.level3Status!.toList());
                                  String mainAccessToken = LocalStorageHelper().getString("accessToken");
                                  UserService()
                                            .registerUser(context,mainAccessToken, usernameController.text, emailController.text)
                                            .then((onValue) {
                                          if(onValue){
                                            UserService()
                                                .assignUpdateUsageLocation(context,
                                                mainAccessToken, usernameController.text, emailController.text)
                                                .then((onValue) {
                                              if(onValue){
                                                UserService()
                                                    .assignLicenseToUser(context,
                                                    mainAccessToken, usernameController.text, emailController.text)
                                                    .then((onValue) {
                                                  //assignLicenseToUser
                                                  if(onValue){
                                                    UserService()
                                                        .createUser(User(
                                                      country: "United States",
                                                      name: usernameController.text,
                                                      username: usernameController.text,
                                                      state: "",
                                                      email: emailController.text,
                                                      password: "123456",
                                                      isEnabled: true,
                                                      companyID: companyID,
                                                      accessLevel: "1",
                                                    ),xyz)
                                                        .then((value) {
                                                      if (value) {
                                                        GoRouter.of(context).go(RouteUri.dashboard);
                                                      } else {}
                                                    });
                                                  }else{
                                                    var snackBar = SnackBar(
                                                      content: Text('Error Creating User'),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    //Navigator.pop(context);
                                                  }
                                                });
                                              } else {
                                                var snackBar = SnackBar(
                                                  content: Text('Error Creating User'),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                               // Navigator.pop(context);
                                              }
                                            });
                                          }else {
                                            var snackBar = SnackBar(
                                              content: Text('Error Creating User'),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                           // Navigator.pop(context);
                                          }
                                        });
                                      }),
                                child: Text(lang.register),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                            width: double.infinity,
                            child: OutlinedButton(
                              style: themeData.extension<AppButtonTheme>()!.secondaryOutlined,
                              onPressed: () => GoRouter.of(context).go(RouteUri.dashboard),
                              child: Text("Back to Dashboard"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormData {
  String username = '';
  String email = '';
  String password = '';
}
