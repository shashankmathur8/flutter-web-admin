import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_admin/utils/styles.dart';

import '../../constants/dimens.dart';
import '../../generated/l10n.dart';
import '../../providers/user_data_provider.dart';
import '../../theme/theme_extensions/app_color_scheme.dart';
import '../widgets/card_elements.dart';
import '../widgets/portal_master_layout/portal_master_layout.dart';
import '../widgets/public_master_layout/public_master_layout.dart';
import 'dashboard_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:excel/excel.dart';


class ErrorScreen extends StatefulWidget  {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> with SingleTickerProviderStateMixin{
  late TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.read<UserDataProvider>();

    if (userDataProvider.isUserLoggedIn()) {
      return PortalMasterLayout(
        body: _content(context,tabController),
      );
    } else {
      return PublicMasterLayout(
        body: _content(context,tabController),
      );
    }
  }
  }
Widget _content(BuildContext context,TabController tabController) {
  final lang = Lang.of(context);
  final themeData = Theme.of(context);
  final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;

  return ListView(
    padding: const EdgeInsets.all(kDefaultPadding),
    children: [
      TabBar(labelStyle:AppStyles.t22BPrimary,controller: tabController, tabs: [
        Tab(
          text: "Monthly",
        ),
        Tab(
            text: "Yearly",
        ),
      ]),
      Container(
        constraints: BoxConstraints(maxWidth: 500,maxHeight: 600),
        child: TabBarView(controller: tabController, children: [
          MonthlyScreen(
            tabController: tabController,
          ),
          YearlyScreen(
            tabController: tabController,
          ),
        ]),
      )
    ],
  );


}
Widget MonthlyScreen({required tabController}){
  final summaryCardWidth = (500);

  return Container(
    color: Colors.white,
    child: Column(mainAxisAlignment: MainAxisAlignment.start,
      children: [
      Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text(
                "Monthly Reports",
                style: AppStyles.t22BPrimary,
              ),
              Spacer(),
              ElevatedButton(onPressed: () {
                exportExcel();
              }, child: Text("Download Report")),
            ],
          ),
        ),
        Spacer(),
        Row(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SummaryCard(
                    title: "Positive Leads",
                    value: '200',
                    icon: Icons.group_add_rounded,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    iconColor: Colors.black12,
                    width: 400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SummaryCard(
                    title: "Negative Leads",
                    value: '120',
                    icon: Icons.group_add_rounded,
                    backgroundColor: Colors.white,
                    textColor: Colors.black87,
                    iconColor: Colors.black12,
                    width: 400,
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStackedArea100Chart(),
                    Legends()
                  ],
                ),
              ),
            )
          ],),
          Column(
            children: [
              Container(

                color: Colors.white,
                child: _buildDefaultRadialBarChart(),
              )
            ],
          )
        ],
      )
    ],),
  );

}
exportExcel(){
  var excel = Excel.createExcel();
  Sheet sheetObject = excel['SheetName'];

  CellStyle cellStyle = CellStyle(fontFamily :getFontFamily(FontFamily.Calibri));

  cellStyle.underline = Underline.Single; // or Underline.Double


  var cell = sheetObject.cell(CellIndex.indexByString('A1'));
  cell.value = TextCellValue('Some Text');
  cell.cellStyle = cellStyle;
  var fileBytes = excel.save(fileName: 'My_Excel_File_Name.xlsx');
}
Widget YearlyScreen({required tabController}){
  final summaryCardWidth = (500);

  return Container(
    color: Colors.white,
    child: Column(mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text(
                "Monthly Reports",
                style: AppStyles.t22BPrimary,
              ),
              Spacer(),
              ElevatedButton(onPressed: () {}, child: Text("Download Report")),
            ],
          ),
        ),
        Spacer(),
        Row(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SummaryCard(
                        title: "Monthly Leads",
                        value: '200',
                        icon: Icons.group_add_rounded,
                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                        iconColor: Colors.black12,
                        width: 400,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SummaryCard(
                        title: "Positive Leads",
                        value: '120',
                        icon: Icons.group_add_rounded,
                        backgroundColor: Colors.white,
                        textColor: Colors.black87,
                        iconColor: Colors.black12,
                        width: 400,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStackedArea100Chart(),
                        Legends()
                      ],
                    ),
                  ),
                )
              ],),
            Column(
              children: [
                Container(

                  color: Colors.white,
                  child: _buildDefaultRadialBarChart(),
                )
              ],
            )
          ],
        )
      ],),
  );

}

/// Returns the circular chart with radial series.
Widget _buildDefaultRadialBarChart() {
  return Column(
    children: [
      title(),
      SfCircularChart(
        key: GlobalKey(),
        series: _getRadialBarDefaultSeries(),
      ),
      Legends(),
    ],
  );
}
Widget title(){
  return Container(
    child: Text("Analytics",style: AppStyles.t22BPrimary,),
  );
}
Widget Legends(){
  return Container(
    child: Column(
      children: [
        Row(
          children: [
            textWithLegend(Colors.lightGreen,"Positive Leads"),textWithLegend(Colors.red,"Negative Leads")
          ],
        ),
        Row(
          children: [
            textWithLegend(Colors.lightBlueAccent,"DR Approved"),textWithLegend(Colors.orangeAccent,"DR Rejected")
          ],
        )
      ],
    ),
  );
}
textWithLegend(color,text){
  return Row(
    children: [Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text,style: TextStyle(
        fontSize: 14,color: color
      ),),
    ),Icon(Icons.circle,color: color,size: 12,)],
  );
}

/// Returns default radial series.
List<RadialBarSeries<ChartSampleData, String>> _getRadialBarDefaultSeries() {
  return <RadialBarSeries<ChartSampleData, String>>[
    RadialBarSeries<ChartSampleData, String>(

        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10.0)),
        dataSource: <ChartSampleData>[
          ChartSampleData(
              x: 'John',
              y: 10,
              text: '100%',
              pointColor: const Color.fromRGBO(248, 177, 149, 1.0)),
          ChartSampleData(
              x: 'Almaida',
              y: 11,
              text: '100%',
              pointColor: const Color.fromRGBO(246, 114, 128, 1.0)),
          ChartSampleData(
              x: 'Don',
              y: 12,
              text: '100%',
              pointColor: const Color.fromRGBO(61, 205, 171, 1.0)),
          ChartSampleData(
              x: 'Tom',
              y: 13,
              text: '100%',
              pointColor: const Color.fromRGBO(1, 174, 190, 1.0)),
        ],
        cornerStyle: CornerStyle.bothCurve,
        gap: '10%',
        radius: '90%',
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,
        pointRadiusMapper: (ChartSampleData data, _) => data.text,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, _) => data.x as String)
  ];
}

class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
        this.y,
        this.xValue,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue,
        this.pointColor,
        this.size,
        this.text,
        this.open,
        this.close,
        this.low,
        this.high,
        this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color? color;

  /// Date time value of the data point
  final DateTime? date;
}
/// Returns the stacked area 100 chart.
SfCartesianChart _buildStackedArea100Chart() {
  return SfCartesianChart(
    plotAreaBorderWidth: 0,
    title: ChartTitle(
        text: 'Leads comparision in Companies'),
    legend: Legend(
        isVisible: false, overflowMode: LegendItemOverflowMode.wrap),
    primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0),
        intervalType: DateTimeIntervalType.years,
        dateFormat: DateFormat.y()),
    primaryYAxis: const NumericAxis(
        rangePadding: ChartRangePadding.none,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0)),
    series: _getStackedAreaSeries(),
  );
}

/// Returns the list of chart series
/// which need to render on the stacked area 100 chart.
List<CartesianSeries<_ChartData, DateTime>> _getStackedAreaSeries() {
  var chartData = <_ChartData>[
    _ChartData(DateTime(2000), 0.61, 0.03, 0.48, 0.23),
    _ChartData(DateTime(2001), 0.81, 0.05, 0.53, 0.17),
    _ChartData(DateTime(2002), 0.91, 0.06, 0.57, 0.17),
    _ChartData(DateTime(2003), 1.00, 0.09, 0.61, 0.20),
    _ChartData(DateTime(2004), 1.19, 0.14, 0.63, 0.23),
    _ChartData(DateTime(2005), 1.47, 0.20, 0.64, 0.36),
    _ChartData(DateTime(2006), 1.74, 0.29, 0.66, 0.43),
    _ChartData(DateTime(2007), 1.98, 0.46, 0.76, 0.52),
    _ChartData(DateTime(2008), 1.99, 0.64, 0.77, 0.72),
    _ChartData(DateTime(2009), 1.70, 0.75, 0.55, 1.29),
    _ChartData(DateTime(2010), 1.48, 1.06, 0.54, 1.38),
    _ChartData(DateTime(2011), 1.38, 1.25, 0.57, 1.82),
    _ChartData(DateTime(2012), 1.66, 1.55, 0.61, 2.16),
    _ChartData(DateTime(2013), 1.66, 1.55, 0.67, 2.51),
    _ChartData(DateTime(2014), 1.67, 1.65, 0.67, 2.61),
    _ChartData(DateTime(2015), 1.98, 1.96, 0.98, 2.93),
  ];
  return <CartesianSeries<_ChartData, DateTime>>[
    StackedArea100Series<_ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.organic,
        name: 'Apple'),
    StackedArea100Series<_ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.fairTrade,
        name: 'Orange'),
    StackedArea100Series<_ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.veg,
        name: 'Pears'),
    StackedArea100Series<_ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (_ChartData sales, _) => sales.x,
        yValueMapper: (_ChartData sales, _) => sales.others,
        name: 'Others')
  ];
}

/// Private calss for storing the stacked area 100 series data points.
class _ChartData {
  _ChartData(this.x, this.organic, this.fairTrade, this.veg, this.others);
  final DateTime x;
  final num organic;
  final num fairTrade;
  final num veg;
  final num others;
}

