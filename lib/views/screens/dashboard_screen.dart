
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
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

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }
  getUsers(){

    UserService().getUsers().then((value) {
      widget.users = value.toList();
      userLength.value=widget.users.length;
    });

  }

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();

    super.dispose();
  }
  var userLength=0.obs;

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
                    SummaryCard(
                      title: "Profit",
                      value: '150',
                      icon: Icons.shopping_cart_rounded,
                      backgroundColor: appColorScheme.info,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: "Today Bets%",
                      value: '+12%',
                      icon: Icons.ssid_chart_rounded,
                      backgroundColor: appColorScheme.success,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    Obx(()=>SummaryCard(
                        title: lang.newUsers(2),
                        value: '${userLength.value}',
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
                  ),
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
                                    showCheckboxColumn: userLength.value==0?false:false,
                                    showBottomBorder: true,
                                    columns: const [
                                      DataColumn(label: Text('No.'), numeric: true),
                                      DataColumn(label: Text('Email')),
                                      DataColumn(label: Text('WalletID')),
                                      DataColumn(label: Text('BetID'), numeric: true),
                                      DataColumn(label: Text('WBets%'), numeric: true),
                                      DataColumn(label: Text('LBets%'), numeric: true),
                                      DataColumn(label: Text('Action')),
                                    ],
                                    rows: List.generate(widget.users.length, (index) {
                                      return DataRow.byIndex(
                                        index: index,
                                        cells: [
                                          DataCell(Text('#${index + 1}')),
                                          DataCell(Text('${widget.users[index].userEmail}')),
                                          DataCell(Text('${widget.users[index].walletID}')),
                                          DataCell(Text('${widget.users[index].betID}')),
                                          DataCell(Text('${widget.users[index].winingBets}')),
                                          DataCell(Text('${widget.users[index].losingBets}')),
                                          DataCell(IconButton(icon: Icon(Icons.delete_forever), onPressed: () {
                                            deleteUser(widget.users[index]);
                                            widget.users.removeWhere((element) => element.userEmail==widget.users[index].userEmail);
                                            userLength.value=widget.users.length;
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
