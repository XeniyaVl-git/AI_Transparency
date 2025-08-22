import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:metrik_viewer_x/viewerapp/bloc/viewer_bloc.dart';
import 'package:metrik_viewer_x/viewerapp/widgets/widgets.dart'
    show MetricsData;
import 'package:syncfusion_flutter_charts/charts.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: BlocConsumer<ViewerBloc, ViewerState>(
          listener: (context, state) {
            if (state.isLoading) {
              context.loaderOverlay.show();
            } else if (!state.isLoading && context.loaderOverlay.visible) {
              context.loaderOverlay.hide();
            }
          },
          builder: (context, state) {
            if (state.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<ViewerBloc>().add(SelectFile());
                      },
                      child: Text(state.fileName ?? "Click to select File..."),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          () => context.read<ViewerBloc>().add(UploadFile()),
                      child: Text("Upload"),
                    ),
                  ],
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).highlightColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<ViewerBloc>().add(SelectFile());
                          },
                          child: Text(state.fileName ?? "Select File..."),
                        ),

                        ElevatedButton(
                          onPressed:
                              () =>
                                  context.read<ViewerBloc>().add(UploadFile()),
                          child: Text("Upload"),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("Contrast sensitivity"),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  MetricsData(label: 'F1', value: "15%"),
                                  SizedBox(width: 10),
                                  MetricsData(label: 'Sup', value: '0.3'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Text(
                        "Dashboard",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      Column(
                        children: [
                          Text("Group Fairness"),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  MetricsData(label: 'F1', value: "15%"),
                                  SizedBox(width: 10),
                                  MetricsData(
                                    onTap: () async {
                                      final selectedIndex =
                                          await showDialog<int>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SimpleDialog(
                                                title: const Text(
                                                  'Select Group Fairness Sup',
                                                ),
                                                children: <Widget>[
                                                  SimpleDialogOption(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          0,
                                                        ),
                                                    child: const Text('0.1'),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          1,
                                                        ),
                                                    child: const Text('0.2'),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          2,
                                                        ),
                                                    child: const Text('0.3'),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          3,
                                                        ),
                                                    child: const Text('0.4'),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          4,
                                                        ),
                                                    child: const Text('0.5'),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          5,
                                                        ),
                                                    child: const Text('0.6'),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          6,
                                                        ),
                                                    child: const Text('0.7'),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          7,
                                                        ),
                                                    child: const Text('0.8'),
                                                  ),
                                                  SimpleDialogOption(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          8,
                                                        ),
                                                    child: const Text('0.9'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                      if (mounted && selectedIndex != null) {
                                        context.read<ViewerBloc>().add(
                                          ChangeGroupFairnessSupIndex(
                                            supIndex: selectedIndex,
                                          ),
                                        );
                                      }
                                    },
                                    label: 'Sup',
                                    value: state
                                        .groupFairnessSup[state
                                            .groupFairnessSupIndex][0]
                                        .toStringAsFixed(1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (state.dashboardData != null)
                  Expanded(child: getDashboard(state.groupFairnessSupIndex)),
                Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: state.showContrast,
                          onChanged:
                              (val) => context.read<ViewerBloc>().add(
                                CheckShowContrastEvent(),
                              ),
                        ),
                        Text("Show Contrast"),
                        Icon(Icons.contrast),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: state.showBorderlineContrast,
                          onChanged:
                              (val) => context.read<ViewerBloc>().add(
                                CheckShowBorderlineContrastEvent(),
                              ),
                        ),
                        Text("Show borderline contrast "),
                        Icon(Icons.contrast),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getDashboard(int supIndex) {
    switch (supIndex) {
      case 0:
        return ScatterDefaultZeroOne();
      case 1:
        return ScatterDefaultZeroTwo();
      case 3:
        return ScatterDefaultZeroFour();
      case 4:
        return ScatterDefaultZeroFive();
      case 5:
        return ScatterDefaultZeroSix();
      case 6:
        return ScatterDefaultZeroSeven();
      case 7:
        return ScatterDefaultZeroEight();
      case 8:
        return ScatterDefaultZeroNine();
      default:
        return ScatterDefault();
    }
  }
}

int favorsId(double xValue, int chartType) {
  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  if (chartType < 0 || chartType > 9) return 1;

  return xValue < transformX(chartType / 10)
      ? 0
      : xValue < transformX(chartType.toDouble())
      ? 1
      : 2;
}

class ScatterDefault extends StatefulWidget {
  const ScatterDefault({super.key}) : super();

  @override
  _ScatterDefaultState createState() => _ScatterDefaultState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultState extends State<ScatterDefault> {
  _ScatterDefaultState();

  final List<ChartSampleData> _chartData = [];
  List<String> _highlightProfessions = [];
  List<double> _selectedGroupFairnessSupGroup = [];

  @override
  void initState() {
    super.initState();
  }

  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        _chartData.clear();
        _highlightProfessions = state.highlightProfessions;
        for (var data in state.dashboardData!.entries) {
          _chartData.add(
            ChartSampleData(
              x: transformX(
                data.value['count_male'] / data.value['count_female'],
              ),
              y: data.value['f1_score_difference'],
              text: data.key,
              realX: data.value['count_male'] / data.value['count_female'],
            ),
          );
        }
        return _buildCartesianChart();
      },
    );
  }

  /// Return the Cartesian Chart with Scatter series.
  Widget _buildCartesianChart() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(-.9, -.95),
          child: Text(
            "Favors women",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.8, -.95),
          child: Text(
            "Favors men",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.2, -.95),
          child: Text(
            "Gender-balanced",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            name: "Support Ratio (male/female)",
            title: AxisTitle(text: "Support Ratio (male/female)"),
            minimum: 0,
            maximum: 3,
            interval: .5,
            axisLabelFormatter: (args) {
              switch (args.value.toString()) {
                case "0":
                  return ChartAxisLabel("0", TextStyle());
                case "0.5":
                  return ChartAxisLabel("0.165", TextStyle());
                case "1":
                  return ChartAxisLabel('0.33', TextStyle());
                case "1.5":
                  return ChartAxisLabel("1", TextStyle());
                case "2":
                  return ChartAxisLabel('3', TextStyle());
                case "2.5":
                  return ChartAxisLabel("6.5", TextStyle());
                case "3":
                  return ChartAxisLabel('10', TextStyle());
                default:
                  return ChartAxisLabel('', TextStyle());
              }
            },
          ),
          primaryYAxis: const NumericAxis(
            minimum: 0,
            initialVisibleMaximum: 0.5,
            maximum: 1,
            name: "Absolute F1 Difference",
            title: AxisTitle(text: "Absolute F1 Difference"),
          ),
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: "Imbalanced \nparameters"),
            borderColor: Colors.black12,

            legendItemBuilder: (name, series, point, index) {
              late Widget iconWidget;
              if (name == "Both") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 1)),
                    Text("Both"),
                  ],
                );
              } else if (name == "Support") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.arrow_drop_up, color: Colors.yellow, size: 27),
                    Text("Support"),
                  ],
                );
              } else if (name == "F1") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.square, color: Colors.blue),
                    Text("F1"),
                  ],
                );
              } else {
                iconWidget = Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Icon(Icons.square, color: Colors.green, size: 20),
                    ),
                    Text(" Neither"),
                  ],
                );
              }

              return SizedBox(height: 30, width: 80, child: iconWidget);
            },
          ),
          tooltipBehavior: TooltipBehavior(
            duration: 1000,
            enable: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'X: ${(data as ChartSampleData).realX}\nY: ${data.y}\n\nProfession: ${data.text}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          series: _buildScatterSeries(),
        ),
      ],
    );
  }

  Widget chartPointLabel(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<ScatterSeries<ChartSampleData, double>> _getPoints() {
    final List<ChartSampleData> bothData = [];
    final List<ChartSampleData> support = [];
    final List<ChartSampleData> f1 = [];
    final List<ChartSampleData> neither = [];

    for (final chartData in _chartData) {
      if ((chartData.realX <= 0.33 || chartData.realX >= 3) &&
          chartData.y! >= 0.15) {
        bothData.add(chartData);
      } else if ((chartData.realX > 0.33 || chartData.realX < 3) &&
          chartData.y! >= 0.15) {
        f1.add(chartData);
      } else if ((chartData.realX <= 0.33 || chartData.realX >= 3) &&
          chartData.y! < 0.15) {
        support.add(chartData);
      } else {
        neither.add(chartData);
      }
    }

    return [
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: bothData,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
          labelIntersectAction: LabelIntersectAction.none,
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: bothData[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                3,
              ),
              categoryId: 0,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Both',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Color.fromARGB(255, 255, 0, 1),
          borderColor: Colors.black,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: support,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: support[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                3,
              ),
              categoryId: 1,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Support',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.yellow,
          borderColor: Colors.black,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: f1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: f1[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                3,
              ),
              categoryId: 2,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'F1',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.blue,
          borderColor: Colors.black,
          shape: DataMarkerType.rectangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: neither,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: neither[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                3,
              ),
              categoryId: 3,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Neither',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.green,
          borderColor: Colors.black,
          shape: DataMarkerType.diamond,
        ),
      ),
    ];
  }

  /// Returns the list of Cartesian Scatter series.
  List<CartesianSeries<ChartSampleData, double>> _buildScatterSeries() {
    return <CartesianSeries<ChartSampleData, double>>[
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (data, _) => transformX(0.33),
        yValueMapper: (data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, _) => transformX(3),
        yValueMapper: (ChartSampleData data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, ind) => 0 + 1.0 * ind,
        yValueMapper: (ChartSampleData data, ind) => 0.15,
      ),
      ..._getPoints(),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ScatterDefaultZeroOne extends StatefulWidget {
  const ScatterDefaultZeroOne({super.key}) : super();

  @override
  _ScatterDefaultZeroOneState createState() => _ScatterDefaultZeroOneState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultZeroOneState extends State<ScatterDefaultZeroOne> {
  _ScatterDefaultZeroOneState();

  final List<ChartSampleData> _chartData = [];
  List<String> _highlightProfessions = [];

  @override
  void initState() {
    super.initState();
  }

  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        _chartData.clear();
        _highlightProfessions = state.highlightProfessions;
        for (var data in state.dashboardData!.entries) {
          _chartData.add(
            ChartSampleData(
              x: transformX(
                data.value['count_male'] / data.value['count_female'],
              ),
              y: data.value['f1_score_difference'],
              text: data.key,
              realX: data.value['count_male'] / data.value['count_female'],
            ),
          );
        }
        return _buildCartesianChart();
      },
    );
  }

  /// Return the Cartesian Chart with Scatter series.
  Widget _buildCartesianChart() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(-.9, -.95),
          child: Text(
            "Favors women",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.8, -.95),
          child: Text(
            "Favors men",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.2, -.95),
          child: Text(
            "Gender-balanced",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 3,
            interval: .5,
            axisLabelFormatter: (args) {
              switch (args.value.toString()) {
                case "0":
                  return ChartAxisLabel("0", TextStyle());
                case "0.5":
                  return ChartAxisLabel("0.165", TextStyle());
                case "1":
                  return ChartAxisLabel('0.33', TextStyle());
                case "1.5":
                  return ChartAxisLabel("1", TextStyle());
                case "2":
                  return ChartAxisLabel('3', TextStyle());
                case "2.5":
                  return ChartAxisLabel("6.5", TextStyle());
                case "3":
                  return ChartAxisLabel('10', TextStyle());
                default:
                  return ChartAxisLabel('', TextStyle());
              }
            },
          ),
          primaryYAxis: const NumericAxis(minimum: 0, maximum: 0.5),
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: "Imbalanced \nparameters"),
            borderColor: Colors.black12,

            legendItemBuilder: (name, series, point, index) {
              late Widget iconWidget;
              if (name == "Both") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 1)),
                    Text("Both"),
                  ],
                );
              } else if (name == "Support") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.arrow_drop_up, color: Colors.yellow, size: 27),
                    Text("Support"),
                  ],
                );
              } else if (name == "F1") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.square, color: Colors.blue),
                    Text("F1"),
                  ],
                );
              } else {
                iconWidget = Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Icon(Icons.square, color: Colors.green, size: 20),
                    ),
                    Text(" Neither"),
                  ],
                );
              }

              return SizedBox(height: 30, width: 80, child: iconWidget);
            },
          ),
          tooltipBehavior: TooltipBehavior(
            duration: 1000,
            enable: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'X: ${(data as ChartSampleData).realX}\nY: ${data.y}\n\nProfession: ${data.text}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          series: _buildScatterSeries(),
        ),
      ],
    );
  }

  Widget chartPointLabel(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<ScatterSeries<ChartSampleData, double>> _getPoints() {
    final List<ChartSampleData> bothData = [];
    final List<ChartSampleData> support = [];
    final List<ChartSampleData> f1 = [];
    final List<ChartSampleData> neither = [];

    for (final chartData in _chartData) {
      if ((chartData.realX <= 0.1 || chartData.realX >= 1) &&
          chartData.y! >= 0.15) {
        bothData.add(chartData);
      } else if ((chartData.realX > 0.1 || chartData.realX < 1) &&
          chartData.y! >= 0.15) {
        f1.add(chartData);
      } else if ((chartData.realX <= 0.1 || chartData.realX >= 1) &&
          chartData.y! < 0.15) {
        support.add(chartData);
      } else {
        neither.add(chartData);
      }
    }

    return [
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: bothData,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
          labelIntersectAction: LabelIntersectAction.none,
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: bothData[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                1,
              ),
              categoryId: 0,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Both',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Color.fromARGB(255, 255, 0, 1),
          borderColor: Colors.black,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: support,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: support[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                1,
              ),
              categoryId: 1,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Support',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.yellow,
          borderColor: Colors.black,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: f1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: f1[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                1,
              ),
              categoryId: 2,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'F1',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.blue,
          borderColor: Colors.black,
          shape: DataMarkerType.rectangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: neither,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: neither[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                1,
              ),
              categoryId: 3,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Neither',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.green,
          borderColor: Colors.black,
          shape: DataMarkerType.diamond,
        ),
      ),
    ];
  }

  /// Returns the list of Cartesian Scatter series.
  List<CartesianSeries<ChartSampleData, double>> _buildScatterSeries() {
    return <CartesianSeries<ChartSampleData, double>>[
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (data, _) => transformX(0.1),
        yValueMapper: (data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, _) => transformX(1),
        yValueMapper: (ChartSampleData data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, ind) => 0 + 1.0 * ind,
        yValueMapper: (ChartSampleData data, ind) => 0.15,
      ),
      ..._getPoints(),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ScatterDefaultZeroTwo extends StatefulWidget {
  const ScatterDefaultZeroTwo({super.key}) : super();

  @override
  _ScatterDefaultZeroTwoState createState() => _ScatterDefaultZeroTwoState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultZeroTwoState extends State<ScatterDefaultZeroTwo> {
  _ScatterDefaultZeroTwoState();

  final List<ChartSampleData> _chartData = [];
  List<String> _highlightProfessions = [];

  @override
  void initState() {
    super.initState();
  }

  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        _chartData.clear();
        _highlightProfessions = state.highlightProfessions;
        for (var data in state.dashboardData!.entries) {
          _chartData.add(
            ChartSampleData(
              x: transformX(
                data.value['count_male'] / data.value['count_female'],
              ),
              y: data.value['f1_score_difference'],
              text: data.key,
              realX: data.value['count_male'] / data.value['count_female'],
            ),
          );
        }
        return _buildCartesianChart();
      },
    );
  }

  /// Return the Cartesian Chart with Scatter series.
  Widget _buildCartesianChart() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(-.9, -.95),
          child: Text(
            "Favors women",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.8, -.95),
          child: Text(
            "Favors men",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.2, -.95),
          child: Text(
            "Gender-balanced",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 3,
            interval: .5,
            axisLabelFormatter: (args) {
              switch (args.value.toString()) {
                case "0":
                  return ChartAxisLabel("0", TextStyle());
                case "0.5":
                  return ChartAxisLabel("0.165", TextStyle());
                case "1":
                  return ChartAxisLabel('0.33', TextStyle());
                case "1.5":
                  return ChartAxisLabel("1", TextStyle());
                case "2":
                  return ChartAxisLabel('3', TextStyle());
                case "2.5":
                  return ChartAxisLabel("6.5", TextStyle());
                case "3":
                  return ChartAxisLabel('10', TextStyle());
                default:
                  return ChartAxisLabel('', TextStyle());
              }
            },
          ),
          primaryYAxis: const NumericAxis(minimum: 0, maximum: 0.5),
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: "Imbalanced \nparameters"),
            borderColor: Colors.black12,

            legendItemBuilder: (name, series, point, index) {
              late Widget iconWidget;
              if (name == "Both") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 1)),
                    Text("Both"),
                  ],
                );
              } else if (name == "Support") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.arrow_drop_up, color: Colors.yellow, size: 27),
                    Text("Support"),
                  ],
                );
              } else if (name == "F1") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.square, color: Colors.blue),
                    Text("F1"),
                  ],
                );
              } else {
                iconWidget = Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Icon(Icons.square, color: Colors.green, size: 20),
                    ),
                    Text(" Neither"),
                  ],
                );
              }

              return SizedBox(height: 30, width: 80, child: iconWidget);
            },
          ),
          tooltipBehavior: TooltipBehavior(
            duration: 1000,
            enable: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'X: ${(data as ChartSampleData).realX}\nY: ${data.y}\n\nProfession: ${data.text}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          series: _buildScatterSeries(),
        ),
      ],
    );
  }

  Widget chartPointLabel(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<ScatterSeries<ChartSampleData, double>> _getPoints() {
    final List<ChartSampleData> bothData = [];
    final List<ChartSampleData> support = [];
    final List<ChartSampleData> f1 = [];
    final List<ChartSampleData> neither = [];

    for (final chartData in _chartData) {
      if ((chartData.realX <= 0.2 || chartData.realX >= 2) &&
          chartData.y! >= 0.15) {
        bothData.add(chartData);
      } else if ((chartData.realX > 0.2 || chartData.realX < 2) &&
          chartData.y! >= 0.15) {
        f1.add(chartData);
      } else if ((chartData.realX <= 0.2 || chartData.realX >= 2) &&
          chartData.y! < 0.15) {
        support.add(chartData);
      } else {
        neither.add(chartData);
      }
    }

    return [
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: bothData,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
          labelIntersectAction: LabelIntersectAction.none,
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: bothData[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                2,
              ),
              categoryId: 0,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Both',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Color.fromARGB(255, 255, 0, 1),
          borderColor: Colors.black,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: support,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: support[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                2,
              ),
              categoryId: 1,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Support',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.yellow,
          borderColor: Colors.black,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: f1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: f1[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                2,
              ),
              categoryId: 2,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'F1',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.blue,
          borderColor: Colors.black,
          shape: DataMarkerType.rectangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: neither,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: neither[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                2,
              ),
              categoryId: 3,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Neither',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.green,
          borderColor: Colors.black,
          shape: DataMarkerType.diamond,
        ),
      ),
    ];
  }

  /// Returns the list of Cartesian Scatter series.
  List<CartesianSeries<ChartSampleData, double>> _buildScatterSeries() {
    return <CartesianSeries<ChartSampleData, double>>[
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (data, _) => transformX(0.2),
        yValueMapper: (data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, _) => transformX(2),
        yValueMapper: (ChartSampleData data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, ind) => 0 + 1.0 * ind,
        yValueMapper: (ChartSampleData data, ind) => 0.15,
      ),
      ..._getPoints(),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ScatterDefaultZeroFour extends StatefulWidget {
  const ScatterDefaultZeroFour({super.key}) : super();

  @override
  _ScatterDefaultZeroFourState createState() => _ScatterDefaultZeroFourState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultZeroFourState extends State<ScatterDefaultZeroFour> {
  _ScatterDefaultZeroFourState();

  final List<ChartSampleData> _chartData = [];
  List<String> _highlightProfessions = [];

  @override
  void initState() {
    super.initState();
  }

  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        _chartData.clear();
        _highlightProfessions = state.highlightProfessions;
        for (var data in state.dashboardData!.entries) {
          _chartData.add(
            ChartSampleData(
              x: transformX(
                data.value['count_male'] / data.value['count_female'],
              ),
              y: data.value['f1_score_difference'],
              text: data.key,
              realX: data.value['count_male'] / data.value['count_female'],
            ),
          );
        }
        return _buildCartesianChart();
      },
    );
  }

  /// Return the Cartesian Chart with Scatter series.
  Widget _buildCartesianChart() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(-.9, -.95),
          child: Text(
            "Favors women",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.8, -.95),
          child: Text(
            "Favors men",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.2, -.95),
          child: Text(
            "Gender-balanced",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 3,
            interval: .5,
            axisLabelFormatter: (args) {
              switch (args.value.toString()) {
                case "0":
                  return ChartAxisLabel("0", TextStyle());
                case "0.5":
                  return ChartAxisLabel("0.165", TextStyle());
                case "1":
                  return ChartAxisLabel('0.33', TextStyle());
                case "1.5":
                  return ChartAxisLabel("1", TextStyle());
                case "2":
                  return ChartAxisLabel('3', TextStyle());
                case "2.5":
                  return ChartAxisLabel("6.5", TextStyle());
                case "3":
                  return ChartAxisLabel('10', TextStyle());
                default:
                  return ChartAxisLabel('', TextStyle());
              }
            },
          ),
          primaryYAxis: const NumericAxis(minimum: 0, maximum: 0.5),
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: "Imbalanced \nparameters"),
            borderColor: Colors.black12,

            legendItemBuilder: (name, series, point, index) {
              late Widget iconWidget;
              if (name == "Both") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 1)),
                    Text("Both"),
                  ],
                );
              } else if (name == "Support") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.arrow_drop_up, color: Colors.yellow, size: 27),
                    Text("Support"),
                  ],
                );
              } else if (name == "F1") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.square, color: Colors.blue),
                    Text("F1"),
                  ],
                );
              } else {
                iconWidget = Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Icon(Icons.square, color: Colors.green, size: 20),
                    ),
                    Text(" Neither"),
                  ],
                );
              }

              return SizedBox(height: 30, width: 80, child: iconWidget);
            },
          ),
          tooltipBehavior: TooltipBehavior(
            duration: 1000,
            enable: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'X: ${(data as ChartSampleData).realX}\nY: ${data.y}\n\nProfession: ${data.text}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          series: _buildScatterSeries(),
        ),
      ],
    );
  }

  Widget chartPointLabel(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<ScatterSeries<ChartSampleData, double>> _getPoints() {
    final List<ChartSampleData> bothData = [];
    final List<ChartSampleData> support = [];
    final List<ChartSampleData> f1 = [];
    final List<ChartSampleData> neither = [];

    for (final chartData in _chartData) {
      if ((chartData.realX <= 0.4 || chartData.realX >= 4) &&
          chartData.y! >= 0.15) {
        bothData.add(chartData);
      } else if ((chartData.realX > 0.4 || chartData.realX < 4) &&
          chartData.y! >= 0.15) {
        f1.add(chartData);
      } else if ((chartData.realX <= 0.4 || chartData.realX >= 4) &&
          chartData.y! < 0.15) {
        support.add(chartData);
      } else {
        neither.add(chartData);
      }
    }

    return [
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: bothData,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
          labelIntersectAction: LabelIntersectAction.none,
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: bothData[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                4,
              ),
              categoryId: 0,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Both',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Color.fromARGB(255, 255, 0, 1),
          borderColor: Colors.black,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: support,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: support[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                4,
              ),
              categoryId: 1,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Support',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.yellow,
          borderColor: Colors.black,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: f1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: f1[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                4,
              ),
              categoryId: 2,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'F1',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.blue,
          borderColor: Colors.black,
          shape: DataMarkerType.rectangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: neither,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: neither[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                4,
              ),
              categoryId: 3,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Neither',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.green,
          borderColor: Colors.black,
          shape: DataMarkerType.diamond,
        ),
      ),
    ];
  }

  /// Returns the list of Cartesian Scatter series.
  List<CartesianSeries<ChartSampleData, double>> _buildScatterSeries() {
    return <CartesianSeries<ChartSampleData, double>>[
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (data, _) => transformX(0.4),
        yValueMapper: (data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, _) => transformX(4),
        yValueMapper: (ChartSampleData data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, ind) => 0 + 1.0 * ind,
        yValueMapper: (ChartSampleData data, ind) => 0.15,
      ),
      ..._getPoints(),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ScatterDefaultZeroFive extends StatefulWidget {
  const ScatterDefaultZeroFive({super.key}) : super();

  @override
  _ScatterDefaultZeroFiveState createState() => _ScatterDefaultZeroFiveState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultZeroFiveState extends State<ScatterDefaultZeroFive> {
  _ScatterDefaultZeroFiveState();

  final List<ChartSampleData> _chartData = [];
  List<String> _highlightProfessions = [];

  @override
  void initState() {
    super.initState();
  }

  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        _chartData.clear();
        _highlightProfessions = state.highlightProfessions;
        for (var data in state.dashboardData!.entries) {
          _chartData.add(
            ChartSampleData(
              x: transformX(
                data.value['count_male'] / data.value['count_female'],
              ),
              y: data.value['f1_score_difference'],
              text: data.key,
              realX: data.value['count_male'] / data.value['count_female'],
            ),
          );
        }
        return _buildCartesianChart();
      },
    );
  }

  /// Return the Cartesian Chart with Scatter series.
  Widget _buildCartesianChart() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(-.9, -.95),
          child: Text(
            "Favors women",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.8, -.95),
          child: Text(
            "Favors men",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.2, -.95),
          child: Text(
            "Gender-balanced",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 3,
            interval: .5,
            axisLabelFormatter: (args) {
              switch (args.value.toString()) {
                case "0":
                  return ChartAxisLabel("0", TextStyle());
                case "0.5":
                  return ChartAxisLabel("0.165", TextStyle());
                case "1":
                  return ChartAxisLabel('0.33', TextStyle());
                case "1.5":
                  return ChartAxisLabel("1", TextStyle());
                case "2":
                  return ChartAxisLabel('3', TextStyle());
                case "2.5":
                  return ChartAxisLabel("6.5", TextStyle());
                case "3":
                  return ChartAxisLabel('10', TextStyle());
                default:
                  return ChartAxisLabel('', TextStyle());
              }
            },
          ),
          primaryYAxis: const NumericAxis(minimum: 0, maximum: 0.5),
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: "Imbalanced \nparameters"),
            borderColor: Colors.black12,

            legendItemBuilder: (name, series, point, index) {
              late Widget iconWidget;
              if (name == "Both") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 1)),
                    Text("Both"),
                  ],
                );
              } else if (name == "Support") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.arrow_drop_up, color: Colors.yellow, size: 27),
                    Text("Support"),
                  ],
                );
              } else if (name == "F1") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.square, color: Colors.blue),
                    Text("F1"),
                  ],
                );
              } else {
                iconWidget = Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Icon(Icons.square, color: Colors.green, size: 20),
                    ),
                    Text(" Neither"),
                  ],
                );
              }

              return SizedBox(height: 30, width: 80, child: iconWidget);
            },
          ),
          tooltipBehavior: TooltipBehavior(
            duration: 1000,
            enable: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'X: ${(data as ChartSampleData).realX}\nY: ${data.y}\n\nProfession: ${data.text}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          series: _buildScatterSeries(),
        ),
      ],
    );
  }

  Widget chartPointLabel(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<ScatterSeries<ChartSampleData, double>> _getPoints() {
    final List<ChartSampleData> bothData = [];
    final List<ChartSampleData> support = [];
    final List<ChartSampleData> f1 = [];
    final List<ChartSampleData> neither = [];

    for (final chartData in _chartData) {
      if ((chartData.realX <= 0.5 || chartData.realX >= 5) &&
          chartData.y! >= 0.15) {
        bothData.add(chartData);
      } else if ((chartData.realX > 0.5 || chartData.realX < 5) &&
          chartData.y! >= 0.15) {
        f1.add(chartData);
      } else if ((chartData.realX <= 0.5 || chartData.realX >= 5) &&
          chartData.y! < 0.15) {
        support.add(chartData);
      } else {
        neither.add(chartData);
      }
    }

    return [
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: bothData,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
          labelIntersectAction: LabelIntersectAction.none,
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: bothData[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                5,
              ),
              categoryId: 0,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Both',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Color.fromARGB(255, 255, 0, 1),
          borderColor: Colors.black,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: support,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: support[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                5,
              ),
              categoryId: 1,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Support',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.yellow,
          borderColor: Colors.black,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: f1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: f1[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                5,
              ),
              categoryId: 2,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'F1',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.blue,
          borderColor: Colors.black,
          shape: DataMarkerType.rectangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: neither,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: neither[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                5,
              ),
              categoryId: 3,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Neither',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.green,
          borderColor: Colors.black,
          shape: DataMarkerType.diamond,
        ),
      ),
    ];
  }

  /// Returns the list of Cartesian Scatter series.
  List<CartesianSeries<ChartSampleData, double>> _buildScatterSeries() {
    return <CartesianSeries<ChartSampleData, double>>[
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (data, _) => transformX(0.5),
        yValueMapper: (data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, _) => transformX(5),
        yValueMapper: (ChartSampleData data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, ind) => 0 + 1.0 * ind,
        yValueMapper: (ChartSampleData data, ind) => 0.15,
      ),
      ..._getPoints(),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ScatterDefaultZeroSix extends StatefulWidget {
  const ScatterDefaultZeroSix({super.key}) : super();

  @override
  _ScatterDefaultZeroSixState createState() => _ScatterDefaultZeroSixState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultZeroSixState extends State<ScatterDefaultZeroSix> {
  _ScatterDefaultZeroSixState();

  final List<ChartSampleData> _chartData = [];
  List<String> _highlightProfessions = [];

  @override
  void initState() {
    super.initState();
  }

  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        _chartData.clear();
        _highlightProfessions = state.highlightProfessions;
        for (var data in state.dashboardData!.entries) {
          _chartData.add(
            ChartSampleData(
              x: transformX(
                data.value['count_male'] / data.value['count_female'],
              ),
              y: data.value['f1_score_difference'],
              text: data.key,
              realX: data.value['count_male'] / data.value['count_female'],
            ),
          );
        }
        return _buildCartesianChart();
      },
    );
  }

  /// Return the Cartesian Chart with Scatter series.
  Widget _buildCartesianChart() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(-.9, -.95),
          child: Text(
            "Favors women",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.8, -.95),
          child: Text(
            "Favors men",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.2, -.95),
          child: Text(
            "Gender-balanced",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 3,
            interval: .5,
            axisLabelFormatter: (args) {
              switch (args.value.toString()) {
                case "0":
                  return ChartAxisLabel("0", TextStyle());
                case "0.5":
                  return ChartAxisLabel("0.165", TextStyle());
                case "1":
                  return ChartAxisLabel('0.33', TextStyle());
                case "1.5":
                  return ChartAxisLabel("1", TextStyle());
                case "2":
                  return ChartAxisLabel('3', TextStyle());
                case "2.5":
                  return ChartAxisLabel("6.5", TextStyle());
                case "3":
                  return ChartAxisLabel('10', TextStyle());
                default:
                  return ChartAxisLabel('', TextStyle());
              }
            },
          ),
          primaryYAxis: const NumericAxis(minimum: 0, maximum: 0.5),
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: "Imbalanced \nparameters"),
            borderColor: Colors.black12,

            legendItemBuilder: (name, series, point, index) {
              late Widget iconWidget;
              if (name == "Both") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 1)),
                    Text("Both"),
                  ],
                );
              } else if (name == "Support") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.arrow_drop_up, color: Colors.yellow, size: 27),
                    Text("Support"),
                  ],
                );
              } else if (name == "F1") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.square, color: Colors.blue),
                    Text("F1"),
                  ],
                );
              } else {
                iconWidget = Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Icon(Icons.square, color: Colors.green, size: 20),
                    ),
                    Text(" Neither"),
                  ],
                );
              }

              return SizedBox(height: 30, width: 80, child: iconWidget);
            },
          ),
          tooltipBehavior: TooltipBehavior(
            duration: 1000,
            enable: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'X: ${(data as ChartSampleData).realX}\nY: ${data.y}\n\nProfession: ${data.text}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          series: _buildScatterSeries(),
        ),
      ],
    );
  }

  Widget chartPointLabel(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<ScatterSeries<ChartSampleData, double>> _getPoints() {
    final List<ChartSampleData> bothData = [];
    final List<ChartSampleData> support = [];
    final List<ChartSampleData> f1 = [];
    final List<ChartSampleData> neither = [];

    for (final chartData in _chartData) {
      if ((chartData.realX <= 0.6 || chartData.realX >= 6) &&
          chartData.y! >= 0.15) {
        bothData.add(chartData);
      } else if ((chartData.realX > 0.6 || chartData.realX < 6) &&
          chartData.y! >= 0.15) {
        f1.add(chartData);
      } else if ((chartData.realX <= 0.6 || chartData.realX >= 6) &&
          chartData.y! < 0.15) {
        support.add(chartData);
      } else {
        neither.add(chartData);
      }
    }

    return [
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: bothData,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
          labelIntersectAction: LabelIntersectAction.none,
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: bothData[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                6,
              ),
              categoryId: 0,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Both',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Color.fromARGB(255, 255, 0, 1),
          borderColor: Colors.black,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: support,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: support[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                6,
              ),
              categoryId: 1,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Support',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.yellow,
          borderColor: Colors.black,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: f1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: f1[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                6,
              ),
              categoryId: 2,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'F1',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.blue,
          borderColor: Colors.black,
          shape: DataMarkerType.rectangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: neither,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: neither[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                6,
              ),
              categoryId: 3,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Neither',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.green,
          borderColor: Colors.black,
          shape: DataMarkerType.diamond,
        ),
      ),
    ];
  }

  /// Returns the list of Cartesian Scatter series.
  List<CartesianSeries<ChartSampleData, double>> _buildScatterSeries() {
    return <CartesianSeries<ChartSampleData, double>>[
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (data, _) => transformX(0.6),
        yValueMapper: (data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, _) => transformX(6),
        yValueMapper: (ChartSampleData data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, ind) => 0 + 1.0 * ind,
        yValueMapper: (ChartSampleData data, ind) => 0.15,
      ),
      ..._getPoints(),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ScatterDefaultZeroSeven extends StatefulWidget {
  const ScatterDefaultZeroSeven({super.key}) : super();

  @override
  _ScatterDefaultZeroSevenState createState() =>
      _ScatterDefaultZeroSevenState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultZeroSevenState extends State<ScatterDefaultZeroSeven> {
  _ScatterDefaultZeroSevenState();

  final List<ChartSampleData> _chartData = [];
  List<String> _highlightProfessions = [];

  @override
  void initState() {
    super.initState();
  }

  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        _chartData.clear();
        _highlightProfessions = state.highlightProfessions;
        for (var data in state.dashboardData!.entries) {
          _chartData.add(
            ChartSampleData(
              x: transformX(
                data.value['count_male'] / data.value['count_female'],
              ),
              y: data.value['f1_score_difference'],
              text: data.key,
              realX: data.value['count_male'] / data.value['count_female'],
            ),
          );
        }
        return _buildCartesianChart();
      },
    );
  }

  /// Return the Cartesian Chart with Scatter series.
  Widget _buildCartesianChart() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(-.9, -.95),
          child: Text(
            "Favors women",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.8, -.95),
          child: Text(
            "Favors men",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.2, -.95),
          child: Text(
            "Gender-balanced",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 3,
            interval: .5,
            axisLabelFormatter: (args) {
              switch (args.value.toString()) {
                case "0":
                  return ChartAxisLabel("0", TextStyle());
                case "0.5":
                  return ChartAxisLabel("0.165", TextStyle());
                case "1":
                  return ChartAxisLabel('0.33', TextStyle());
                case "1.5":
                  return ChartAxisLabel("1", TextStyle());
                case "2":
                  return ChartAxisLabel('3', TextStyle());
                case "2.5":
                  return ChartAxisLabel("6.5", TextStyle());
                case "3":
                  return ChartAxisLabel('10', TextStyle());
                default:
                  return ChartAxisLabel('', TextStyle());
              }
            },
          ),
          primaryYAxis: const NumericAxis(minimum: 0, maximum: 0.5),
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: "Imbalanced \nparameters"),
            borderColor: Colors.black12,

            legendItemBuilder: (name, series, point, index) {
              late Widget iconWidget;
              if (name == "Both") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 1)),
                    Text("Both"),
                  ],
                );
              } else if (name == "Support") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.arrow_drop_up, color: Colors.yellow, size: 27),
                    Text("Support"),
                  ],
                );
              } else if (name == "F1") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.square, color: Colors.blue),
                    Text("F1"),
                  ],
                );
              } else {
                iconWidget = Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Icon(Icons.square, color: Colors.green, size: 20),
                    ),
                    Text(" Neither"),
                  ],
                );
              }

              return SizedBox(height: 30, width: 80, child: iconWidget);
            },
          ),
          tooltipBehavior: TooltipBehavior(
            duration: 1000,
            enable: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'X: ${(data as ChartSampleData).realX}\nY: ${data.y}\n\nProfession: ${data.text}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          series: _buildScatterSeries(),
        ),
      ],
    );
  }

  Widget chartPointLabel(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<ScatterSeries<ChartSampleData, double>> _getPoints() {
    final List<ChartSampleData> bothData = [];
    final List<ChartSampleData> support = [];
    final List<ChartSampleData> f1 = [];
    final List<ChartSampleData> neither = [];

    for (final chartData in _chartData) {
      if ((chartData.realX <= 0.7 || chartData.realX >= 7) &&
          chartData.y! >= 0.15) {
        bothData.add(chartData);
      } else if ((chartData.realX > 0.7 || chartData.realX < 7) &&
          chartData.y! >= 0.15) {
        f1.add(chartData);
      } else if ((chartData.realX <= 0.7 || chartData.realX >= 7) &&
          chartData.y! < 0.15) {
        support.add(chartData);
      } else {
        neither.add(chartData);
      }
    }

    return [
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: bothData,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
          labelIntersectAction: LabelIntersectAction.none,
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: bothData[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                7,
              ),
              categoryId: 0,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Both',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Color.fromARGB(255, 255, 0, 1),
          borderColor: Colors.black,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: support,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: support[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                7,
              ),
              categoryId: 1,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Support',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.yellow,
          borderColor: Colors.black,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: f1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: f1[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                7,
              ),
              categoryId: 2,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'F1',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.blue,
          borderColor: Colors.black,
          shape: DataMarkerType.rectangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: neither,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: neither[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                7,
              ),
              categoryId: 3,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Neither',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.green,
          borderColor: Colors.black,
          shape: DataMarkerType.diamond,
        ),
      ),
    ];
  }

  /// Returns the list of Cartesian Scatter series.
  List<CartesianSeries<ChartSampleData, double>> _buildScatterSeries() {
    return <CartesianSeries<ChartSampleData, double>>[
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (data, _) => transformX(0.7),
        yValueMapper: (data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, _) => transformX(7),
        yValueMapper: (ChartSampleData data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, ind) => 0 + 1.0 * ind,
        yValueMapper: (ChartSampleData data, ind) => 0.15,
      ),
      ..._getPoints(),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ScatterDefaultZeroEight extends StatefulWidget {
  const ScatterDefaultZeroEight({super.key}) : super();

  @override
  _ScatterDefaultZeroEightState createState() =>
      _ScatterDefaultZeroEightState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultZeroEightState extends State<ScatterDefaultZeroEight> {
  _ScatterDefaultZeroEightState();

  final List<ChartSampleData> _chartData = [];
  List<String> _highlightProfessions = [];

  @override
  void initState() {
    super.initState();
  }

  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        _chartData.clear();
        _highlightProfessions = state.highlightProfessions;
        for (var data in state.dashboardData!.entries) {
          _chartData.add(
            ChartSampleData(
              x: transformX(
                data.value['count_male'] / data.value['count_female'],
              ),
              y: data.value['f1_score_difference'],
              text: data.key,
              realX: data.value['count_male'] / data.value['count_female'],
            ),
          );
        }
        return _buildCartesianChart();
      },
    );
  }

  /// Return the Cartesian Chart with Scatter series.
  Widget _buildCartesianChart() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(-.9, -.95),
          child: Text(
            "Favors women",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.8, -.95),
          child: Text(
            "Favors men",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.2, -.95),
          child: Text(
            "Gender-balanced",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 3,
            interval: .5,
            axisLabelFormatter: (args) {
              switch (args.value.toString()) {
                case "0":
                  return ChartAxisLabel("0", TextStyle());
                case "0.5":
                  return ChartAxisLabel("0.165", TextStyle());
                case "1":
                  return ChartAxisLabel('0.33', TextStyle());
                case "1.5":
                  return ChartAxisLabel("1", TextStyle());
                case "2":
                  return ChartAxisLabel('3', TextStyle());
                case "2.5":
                  return ChartAxisLabel("6.5", TextStyle());
                case "3":
                  return ChartAxisLabel('10', TextStyle());
                default:
                  return ChartAxisLabel('', TextStyle());
              }
            },
          ),
          primaryYAxis: const NumericAxis(minimum: 0, maximum: 0.5),
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: "Imbalanced \nparameters"),
            borderColor: Colors.black12,

            legendItemBuilder: (name, series, point, index) {
              late Widget iconWidget;
              if (name == "Both") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 1)),
                    Text("Both"),
                  ],
                );
              } else if (name == "Support") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.arrow_drop_up, color: Colors.yellow, size: 27),
                    Text("Support"),
                  ],
                );
              } else if (name == "F1") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.square, color: Colors.blue),
                    Text("F1"),
                  ],
                );
              } else {
                iconWidget = Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Icon(Icons.square, color: Colors.green, size: 20),
                    ),
                    Text(" Neither"),
                  ],
                );
              }

              return SizedBox(height: 30, width: 80, child: iconWidget);
            },
          ),
          tooltipBehavior: TooltipBehavior(
            duration: 1000,
            enable: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'X: ${(data as ChartSampleData).realX}\nY: ${data.y}\n\nProfession: ${data.text}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          series: _buildScatterSeries(),
        ),
      ],
    );
  }

  Widget chartPointLabel(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<ScatterSeries<ChartSampleData, double>> _getPoints() {
    final List<ChartSampleData> bothData = [];
    final List<ChartSampleData> support = [];
    final List<ChartSampleData> f1 = [];
    final List<ChartSampleData> neither = [];

    for (final chartData in _chartData) {
      if ((chartData.realX <= 0.8 || chartData.realX >= 8) &&
          chartData.y! >= 0.15) {
        bothData.add(chartData);
      } else if ((chartData.realX > 0.8 || chartData.realX < 8) &&
          chartData.y! >= 0.15) {
        f1.add(chartData);
      } else if ((chartData.realX <= 0.8 || chartData.realX >= 8) &&
          chartData.y! < 0.15) {
        support.add(chartData);
      } else {
        neither.add(chartData);
      }
    }

    return [
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: bothData,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
          labelIntersectAction: LabelIntersectAction.none,
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: bothData[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                8,
              ),
              categoryId: 0,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Both',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Color.fromARGB(255, 255, 0, 1),
          borderColor: Colors.black,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: support,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: support[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                8,
              ),
              categoryId: 1,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Support',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.yellow,
          borderColor: Colors.black,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: f1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: f1[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                8,
              ),
              categoryId: 2,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'F1',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.blue,
          borderColor: Colors.black,
          shape: DataMarkerType.rectangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: neither,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: neither[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                8,
              ),
              categoryId: 3,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Neither',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.green,
          borderColor: Colors.black,
          shape: DataMarkerType.diamond,
        ),
      ),
    ];
  }

  /// Returns the list of Cartesian Scatter series.
  List<CartesianSeries<ChartSampleData, double>> _buildScatterSeries() {
    return <CartesianSeries<ChartSampleData, double>>[
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (data, _) => transformX(0.8),
        yValueMapper: (data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, _) => transformX(8),
        yValueMapper: (ChartSampleData data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, ind) => 0 + 1.0 * ind,
        yValueMapper: (ChartSampleData data, ind) => 0.15,
      ),
      ..._getPoints(),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ScatterDefaultZeroNine extends StatefulWidget {
  const ScatterDefaultZeroNine({super.key}) : super();

  @override
  _ScatterDefaultZeroNineState createState() => _ScatterDefaultZeroNineState();
}

/// State class of default Scatter Chart sample.
class _ScatterDefaultZeroNineState extends State<ScatterDefaultZeroNine> {
  _ScatterDefaultZeroNineState();

  final List<ChartSampleData> _chartData = [];
  List<String> _highlightProfessions = [];

  @override
  void initState() {
    super.initState();
  }

  double transformX(double x) {
    if (x <= 0.33) {
      // 0 → 0.33 → 0 → 1
      return (x / 0.33) * 1.0;
    } else if (x <= 1.0) {
      // 0.33 → 1.0 → 1.0 → 1.5
      return 1.0 + ((x - 0.33) / (1.0 - 0.33)) * 0.5;
    } else if (x <= 3.0) {
      // 1.0 → 3.0 → 1.5 → 2.0
      return 1.5 + ((x - 1.0) / (3.0 - 1.0)) * 0.5;
    } else if (x <= 10.0) {
      // 3.0 → 10.0 → 2.0 → 3.0
      return 2.0 + ((x - 3.0) / (10.0 - 3.0)) * 1.0;
    } else {
      // экстраполяция
      return 3.0 + ((x - 10.0) / (10.0 - 3.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewerBloc, ViewerState>(
      builder: (context, state) {
        _chartData.clear();
        _highlightProfessions = state.highlightProfessions;
        for (var data in state.dashboardData!.entries) {
          _chartData.add(
            ChartSampleData(
              x: transformX(
                data.value['count_male'] / data.value['count_female'],
              ),
              y: data.value['f1_score_difference'],
              text: data.key,
              realX: data.value['count_male'] / data.value['count_female'],
            ),
          );
        }
        return _buildCartesianChart();
      },
    );
  }

  /// Return the Cartesian Chart with Scatter series.
  Widget _buildCartesianChart() {
    return Stack(
      children: [
        Align(
          alignment: Alignment(-.9, -.95),
          child: Text(
            "Favors women",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.8, -.95),
          child: Text(
            "Favors men",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment(.2, -.95),
          child: Text(
            "Gender-balanced",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: NumericAxis(
            minimum: 0,
            maximum: 3,
            interval: .5,
            axisLabelFormatter: (args) {
              switch (args.value.toString()) {
                case "0":
                  return ChartAxisLabel("0", TextStyle());
                case "0.5":
                  return ChartAxisLabel("0.165", TextStyle());
                case "1":
                  return ChartAxisLabel('0.33', TextStyle());
                case "1.5":
                  return ChartAxisLabel("1", TextStyle());
                case "2":
                  return ChartAxisLabel('3', TextStyle());
                case "2.5":
                  return ChartAxisLabel("6.5", TextStyle());
                case "3":
                  return ChartAxisLabel('10', TextStyle());
                default:
                  return ChartAxisLabel('', TextStyle());
              }
            },
          ),
          primaryYAxis: const NumericAxis(minimum: 0, maximum: 0.5),
          legend: Legend(
            isVisible: true,
            title: LegendTitle(text: "Imbalanced \nparameters"),
            borderColor: Colors.black12,

            legendItemBuilder: (name, series, point, index) {
              late Widget iconWidget;
              if (name == "Both") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.circle, color: Color.fromARGB(255, 255, 0, 1)),
                    Text("Both"),
                  ],
                );
              } else if (name == "Support") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.arrow_drop_up, color: Colors.yellow, size: 27),
                    Text("Support"),
                  ],
                );
              } else if (name == "F1") {
                iconWidget = Row(
                  children: <Widget>[
                    Icon(Icons.square, color: Colors.blue),
                    Text("F1"),
                  ],
                );
              } else {
                iconWidget = Row(
                  children: <Widget>[
                    Transform.rotate(
                      angle: 45 * math.pi / 180,
                      child: Icon(Icons.square, color: Colors.green, size: 20),
                    ),
                    Text(" Neither"),
                  ],
                );
              }

              return SizedBox(height: 30, width: 80, child: iconWidget);
            },
          ),
          tooltipBehavior: TooltipBehavior(
            duration: 1000,
            enable: true,
            builder: (data, point, series, pointIndex, seriesIndex) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'X: ${(data as ChartSampleData).realX}\nY: ${data.y}\n\nProfession: ${data.text}',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          series: _buildScatterSeries(),
        ),
      ],
    );
  }

  Widget chartPointLabel(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  List<ScatterSeries<ChartSampleData, double>> _getPoints() {
    final List<ChartSampleData> bothData = [];
    final List<ChartSampleData> support = [];
    final List<ChartSampleData> f1 = [];
    final List<ChartSampleData> neither = [];

    for (final chartData in _chartData) {
      if ((chartData.realX <= 0.9 || chartData.realX >= 9) &&
          chartData.y! >= 0.15) {
        bothData.add(chartData);
      } else if ((chartData.realX > 0.9 || chartData.realX < 9) &&
          chartData.y! >= 0.15) {
        f1.add(chartData);
      } else if ((chartData.realX <= 0.9 || chartData.realX >= 9) &&
          chartData.y! < 0.15) {
        support.add(chartData);
      } else {
        neither.add(chartData);
      }
    }

    return [
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: bothData,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
          labelIntersectAction: LabelIntersectAction.none,
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: bothData[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                9,
              ),
              categoryId: 0,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Both',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Color.fromARGB(255, 255, 0, 1),
          borderColor: Colors.black,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: support,
        xValueMapper: (data, index) => data.x,
        yValueMapper: (data, index) => data.y,
        dataLabelMapper: (data, index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: support[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                9,
              ),
              categoryId: 1,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Support',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.yellow,
          borderColor: Colors.black,
          shape: DataMarkerType.triangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: f1,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: f1[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                9,
              ),
              categoryId: 2,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'F1',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.blue,
          borderColor: Colors.black,
          shape: DataMarkerType.rectangle,
        ),
      ),
      ScatterSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: neither,
        xValueMapper: (ChartSampleData data, int index) => data.x,
        yValueMapper: (ChartSampleData data, int index) => data.y,
        dataLabelMapper: (ChartSampleData data, int index) => data.text,
        dataLabelSettings: DataLabelSettings(
          // Renders the data label
          isVisible: true,
          labelIntersectAction: LabelIntersectAction.none,
          builder:
              (data, point, series, pointIndex, seriesIndex) =>
                  _highlightProfessions.contains(
                        (data as ChartSampleData).text ?? "",
                      )
                      ? chartPointLabel(data.text ?? "")
                      : Text(data.text ?? ""),
        ),
        onPointTap: (pointDetails) {
          context.read<ViewerBloc>().add(
            SelectProfessionEvent(
              profession: neither[pointDetails.pointIndex!].text!,
              favorsId: favorsId(
                pointDetails.dataPoints?[pointDetails.pointIndex ?? 0].xValue,
                9,
              ),
              categoryId: 3,
            ),
          );
          context.goNamed("detail_view");
        },
        opacity: 0.7,
        name: 'Neither',
        markerSettings: const MarkerSettings(
          isVisible: true,
          height: 15,
          width: 15,
          color: Colors.green,
          borderColor: Colors.black,
          shape: DataMarkerType.diamond,
        ),
      ),
    ];
  }

  /// Returns the list of Cartesian Scatter series.
  List<CartesianSeries<ChartSampleData, double>> _buildScatterSeries() {
    return <CartesianSeries<ChartSampleData, double>>[
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (data, _) => transformX(0.9),
        yValueMapper: (data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, _) => transformX(9),
        yValueMapper: (ChartSampleData data, ind) => 0 + 0.1 * ind,
      ),
      LineSeries<ChartSampleData, double>(
        animationDelay: 0,
        animationDuration: 0,
        dataSource: _chartData,
        enableTooltip: false,
        enableTrackball: false,
        initialIsVisible: true,
        isVisibleInLegend: false,
        color: Colors.blueGrey.withAlpha(150),
        // Dash values for line
        dashArray: <double>[5, 5],
        xValueMapper: (ChartSampleData data, ind) => 0 + 1.0 * ind,
        yValueMapper: (ChartSampleData data, ind) => 0.15,
      ),
      ..._getPoints(),
    ];
  }

  @override
  void dispose() {
    _chartData.clear();
    super.dispose();
  }
}

class ChartSampleData {
  ChartSampleData({this.x, this.y, this.text, required this.realX});

  final double realX; // для отображения в tooltip или подписи
  final dynamic x;
  final num? y;
  final String? text;
}
