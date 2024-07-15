import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/companyService.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/providers/user_data_provider.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/userModel.dart';
import 'package:web_admin/userService.dart';
import 'package:web_admin/utils/app_focus_helper.dart';
import 'package:web_admin/views/widgets/public_master_layout/public_master_layout.dart';

import '../../companyModel.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  final _passwordTextEditingController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  final _formData = FormData();
  late StringTagController _stringTagController = StringTagController();
  late StringTagController _stringTagController2 = StringTagController();
  late StringTagController _stringTagController3 = StringTagController();
  static const List<String> _initialTags = <String>[
  ];
  static const List<String> _initialTags2 = <String>[
  ];
  static const List<String> _initialTags3 = <String>[
  ];

  var _isFormLoading = false;

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
            constraints: const BoxConstraints(maxWidth: 800.0),
            child: Card(
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
                              name: 'Company Name',
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Company Name',
                                hintText: 'Company Name',
                                helperText: '',
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
                              name: 'Phone No.',
                              controller: phoneNoController,
                              decoration: InputDecoration(
                                labelText: 'Phone No.',
                                hintText: 'Phone No.',
                                helperText: '',
                                border: const OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                              enableSuggestions: false,
                              validator: FormBuilderValidators.integer(),
                              onSaved: (value) => (_formData.phone = value ?? ''),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: Column(children: [
                              TextFieldTags<String>(
                                textfieldTagsController: _stringTagController,
                                initialTags: _initialTags,
                                textSeparators: const [' ', ','],
                                letterCase: LetterCase.normal,
                                validator: (String tag) {
                                  if (tag == 'php') {
                                    return 'No, please just no';
                                  } else if (_stringTagController.getTags!.contains(tag)) {
                                    return 'You\'ve already entered that';
                                  }
                                  return null;
                                },
                                inputFieldBuilder: (context, inputFieldValues) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: TextField(
                                      onTap: () {
                                        _stringTagController.getFocusNode?.requestFocus();
                                      },
                                      controller: inputFieldValues.textEditingController,
                                      focusNode: inputFieldValues.focusNode,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 3.0,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 3.0,
                                          ),
                                        ),
                                        helperText: 'Enter Level 1 Status',
                                        helperStyle: const TextStyle(
                                          color: Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        hintText: inputFieldValues.tags.isNotEmpty
                                            ? ''
                                            : "Enter Status...",
                                        errorText: inputFieldValues.error,
                                        prefixIconConstraints:
                                        BoxConstraints(maxWidth: 200 * 0.8),
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
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 74, 137, 92),
                                  ),
                                ),
                                onPressed: () {
                                  _stringTagController.clearTags();
                                },
                                child: const Text(
                                  'CLEAR TAGS',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: Column(children: [
                              TextFieldTags<String>(
                                textfieldTagsController: _stringTagController2,
                                initialTags: _initialTags2,
                                textSeparators: const [' ', ','],
                                letterCase: LetterCase.normal,
                                validator: (String tag) {
                                  if (tag == 'php') {
                                    return 'No, please just no';
                                  } else if (_stringTagController2.getTags!.contains(tag)) {
                                    return 'You\'ve already entered that';
                                  }
                                  return null;
                                },
                                inputFieldBuilder: (context, inputFieldValues) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: TextField(
                                      onTap: () {
                                        _stringTagController2.getFocusNode?.requestFocus();
                                      },
                                      controller: inputFieldValues.textEditingController,
                                      focusNode: inputFieldValues.focusNode,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 3.0,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 3.0,
                                          ),
                                        ),
                                        helperText: 'Enter Level 2 Status',
                                        helperStyle: const TextStyle(
                                          color: Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        hintText: inputFieldValues.tags.isNotEmpty
                                            ? ''
                                            : "Enter Status...",
                                        errorText: inputFieldValues.error,
                                        prefixIconConstraints:
                                        BoxConstraints(maxWidth: 200 * 0.8),
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
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 74, 137, 92),
                                  ),
                                ),
                                onPressed: () {
                                  _stringTagController2.clearTags();
                                },
                                child: const Text(
                                  'CLEAR TAGS',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            child: Column(children: [
                              TextFieldTags<String>(
                                textfieldTagsController: _stringTagController3,
                                initialTags: _initialTags3,
                                textSeparators: const [' ', ','],
                                letterCase: LetterCase.normal,
                                validator: (String tag) {
                                  if (tag == 'php') {
                                    return 'No, please just no';
                                  } else if (_stringTagController3.getTags!.contains(tag)) {
                                    return 'You\'ve already entered that';
                                  }
                                  return null;
                                },
                                inputFieldBuilder: (context, inputFieldValues) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: TextField(
                                      onTap: () {
                                        _stringTagController3.getFocusNode?.requestFocus();
                                      },
                                      controller: inputFieldValues.textEditingController,
                                      focusNode: inputFieldValues.focusNode,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 3.0,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(255, 74, 137, 92),
                                            width: 3.0,
                                          ),
                                        ),
                                        helperText: 'Enter Level 3 Status',
                                        helperStyle: const TextStyle(
                                          color: Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        hintText: inputFieldValues.tags.isNotEmpty
                                            ? ''
                                            : "Enter Status...",
                                        errorText: inputFieldValues.error,
                                        prefixIconConstraints:
                                        BoxConstraints(maxWidth: 200 * 0.8),
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
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 74, 137, 92),
                                  ),
                                ),
                                onPressed: () {
                                  _stringTagController3.clearTags();
                                },
                                child: const Text(
                                  'CLEAR TAGS',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],),
                          ),
                          SizedBox(height: 10,),
              
                          Padding(
                            padding: const EdgeInsets.only(bottom: kDefaultPadding),
                            child: SizedBox(
                              height: 40.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: themeData.extension<AppButtonTheme>()!.primaryElevated,
                                onPressed: (_isFormLoading
                                    ? null
                                    : () => {
                                          CompanyService().createCompany(
                                              Company(topPerformers: [],name: usernameController.text,
                                                email: emailController.text,
                                                companyID: "C${DateTime.now().millisecondsSinceEpoch}",
                                                level1Status:_stringTagController.getTags,
                                                level2Status: _stringTagController2.getTags,
                                                level3Status: _stringTagController3.getTags,
                                                phone: phoneNoController.text
              
                                          )).then((value) {
                                            if(value){
                                              GoRouter.of(context).go(RouteUri.dashboard);
                                            }else{
              
                                            }
                                          })
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
  String phone="";
}
