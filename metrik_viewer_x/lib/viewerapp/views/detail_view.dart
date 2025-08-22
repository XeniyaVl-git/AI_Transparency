import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:metrik_viewer_x/viewerapp/bloc/viewer_bloc.dart';
import 'package:metrik_viewer_x/viewerapp/widgets/widgets.dart'
    show MetricsData;
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late TabController _tabBarController;
  final ScrollController _lowScrollController = ScrollController();
  final ScrollController _avgScrollController = ScrollController();
  final ScrollController _highScrollController = ScrollController();

  @override
  void initState() {
    _tabBarController = TabController(length: 3, vsync: this);
    super.initState();
  }

  Widget _navigatorRow(
    BuildContext context,
    int index,
    ViewerState state,
    int listIndex,
  ) {
    return GestureDetector(
      onTap: () {
        if (state.currentIndex !=
            state.navigatorTextList[listIndex].keys.toList()[index]) {
          context.read<ViewerBloc>().add(
            SelectPage(
              selectedPage:
                  state.navigatorTextList[listIndex].keys.toList()[index] + 1,
            ),
          );
        }
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "${index + 1}. ${state.navigatorTextList[listIndex].values.toList()[index]}",
              style:
                  state.currentIndex ==
                          state.navigatorTextList[listIndex].keys
                              .toList()[index]
                      ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                      )
                      : Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  String _favorsText(int? value) {
    switch (value) {
      case 0:
        return "Favours women";
      case 2:
        return "Favours men";
      default:
        return "Fair";
    }
  }

  Widget _builder(BuildContext context, ViewerState state) {
    if (state.data == null) return Container();
    if (state.navigatorTextList[0].keys.isEmpty) {
      if (state.navigatorTextList[1].keys.isNotEmpty &&
          _tabBarController.index == 0) {
        _tabBarController.animateTo(1);
      } else if (state.navigatorTextList[1].keys.isEmpty &&
          _tabBarController.index == 0) {
        _tabBarController.animateTo(2);
      }
    }

    String categoryText = "";
    Color categoryColor = Colors.black;
    Color? backgroundColor = null;
    switch (state.selectedProfessionMetadata?['category_id'] ?? 99) {
      case 0:
        categoryText = "Accuracy and data imbalance";
        categoryColor = Colors.red;
        backgroundColor = Colors.red;
      case 1:
        categoryText = "Data imbalance";
        categoryColor = Colors.orangeAccent;
        backgroundColor = Colors.yellow;
      case 2:
        categoryText = "Accuracy imbalance";
        categoryColor = Colors.blue;
        backgroundColor = Colors.blue;
      case 3:
        categoryText = "Fair";
        categoryColor = Colors.green;
        backgroundColor = Colors.green;
    }
    _controller.text =
        (state.navigatorTextList[_tabBarController.index].keys.toList().indexOf(
                  state.currentIndex,
                ) +
                1)
            .toString();
    return Column(
      mainAxisSize: MainAxisSize.min,
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
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back),
                ),

                GestureDetector(
                  onTap: () {
                    context.read<ViewerBloc>().add(SelectFile());
                  },
                  child: Text(state.fileName ?? "Select File..."),
                ),

                ElevatedButton(
                  onPressed: () => context.read<ViewerBloc>().add(UploadFile()),
                  child: Text("Upload"),
                ),
              ],
            ),
          ),
        ),

        if (state.data != null)
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Class",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: MetricsData(
                                              label: 'Profession Name',
                                              value:
                                                  state
                                                      .data?[state.currentIndex]
                                                      .professionName
                                                      .toString() ??
                                                  "",
                                              textColor: categoryColor,
                                              backgroundColor: backgroundColor,
                                            ),
                                          ),
                                        ),
                                        Flexible(child: Container()),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: MetricsData(
                                              label: 'Category',
                                              value: categoryText,
                                              textColor: categoryColor,
                                              backgroundColor: backgroundColor,
                                            ),
                                          ),
                                        ),
                                        Flexible(child: Container()),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: MetricsData(
                                              label: 'Favors',
                                              value: _favorsText(
                                                state
                                                    .selectedProfessionMetadata?['favors'],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(child: Container()),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      right: 10,
                                      bottom: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //     right: 10,
                                  //     top: 10,
                                  //   ),
                                  //   child: Divider(thickness: 3),
                                  // ),
                                  Text(
                                    "Metrics",
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: MetricsData(
                                            label: 'Gender',
                                            value:
                                                state
                                                    .data?[state.currentIndex]
                                                    .genderId
                                                    .toString() ??
                                                "",
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Flexible(
                                          child: MetricsData(
                                            label: 'Contrast',
                                            value:
                                                state
                                                    .data?[state.currentIndex]
                                                    .contrast
                                                    .toString() ??
                                                "",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: MetricsData(
                                            label: 'pValue',
                                            value:
                                                state
                                                    .data?[state.currentIndex]
                                                    .pvalue
                                                    .toStringAsFixed(15) ??
                                                "",
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Flexible(
                                          child: MetricsData(
                                            label: 'Statistic',
                                            value:
                                                state
                                                    .data?[state.currentIndex]
                                                    .statistic
                                                    .toString() ??
                                                "",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: MetricsData(
                                            label: 'Pred',
                                            value:
                                                state
                                                    .data?[state.currentIndex]
                                                    .pred
                                                    .toString() ??
                                                "",
                                          ),
                                        ),

                                        SizedBox(width: 15),
                                        Flexible(
                                          child: MetricsData(
                                            label: 'ProfessionId',
                                            value:
                                                state
                                                    .data?[state.currentIndex]
                                                    .professionId
                                                    .toString() ??
                                                "",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(flex: 1, child: Container()),

                            Flexible(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                  bottom: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Text navigator",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                    ),
                                    TabBar(
                                      onTap: (index) {
                                        if (state.navigatorTextList[index].keys
                                            .toList()
                                            .isNotEmpty) {
                                          context.read<ViewerBloc>().add(
                                            SelectPage(
                                              selectedPage:
                                                  state
                                                      .navigatorTextList[index]
                                                      .keys
                                                      .toList()[0] +
                                                  1,
                                            ),
                                          );
                                        }
                                      },
                                      controller: _tabBarController,
                                      labelPadding: EdgeInsets.zero,
                                      indicatorWeight: 3,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      tabs: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          color: Colors.red.withAlpha(20),
                                          width: double.infinity,
                                          child: Text(
                                            "Low",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.red),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          color: Colors.orange.withAlpha(20),
                                          width: double.infinity,
                                          child: Text(
                                            "Average",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.orange),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          color: Colors.green.withAlpha(20),
                                          width: double.infinity,
                                          child: Text(
                                            "High",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(color: Colors.green),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      // width: 400,
                                      height: 435,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                          right: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                          bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: TabBarView(
                                        controller: _tabBarController,
                                        children: [
                                          Scrollbar(
                                            controller: _lowScrollController,
                                            thumbVisibility: true,
                                            trackVisibility: true,
                                            child: ListView.builder(
                                              controller: _lowScrollController,
                                              itemBuilder:
                                                  (context, index) =>
                                                      _navigatorRow(
                                                        context,
                                                        index,
                                                        state,
                                                        0,
                                                      ),
                                              itemCount:
                                                  state
                                                      .navigatorTextList[0]
                                                      .length,
                                            ),
                                          ),
                                          Scrollbar(
                                            controller: _avgScrollController,
                                            thumbVisibility: true,
                                            trackVisibility: true,
                                            child: ListView.builder(
                                              controller: _avgScrollController,
                                              itemBuilder:
                                                  (context, index) =>
                                                      _navigatorRow(
                                                        context,
                                                        index,
                                                        state,
                                                        1,
                                                      ),
                                              itemCount:
                                                  state
                                                      .navigatorTextList[1]
                                                      .length,
                                            ),
                                          ),
                                          Scrollbar(
                                            controller: _highScrollController,
                                            thumbVisibility: true,
                                            trackVisibility: true,
                                            child: ListView.builder(
                                              controller: _highScrollController,
                                              itemBuilder:
                                                  (context, index) =>
                                                      _navigatorRow(
                                                        context,
                                                        index,
                                                        state,
                                                        2,
                                                      ),
                                              itemCount:
                                                  state
                                                      .navigatorTextList[2]
                                                      .length,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hard Text",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SelectableText(
                            state.data?[state.currentIndex].hardText ?? "",
                            style: Theme.of(context).textTheme.titleLarge,
                            // softWrap: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 25,
                          bottom: 25,
                          right: 30,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            //  backgroundBlendMode: BlendMode.hardLight,
                            gradient: LinearGradient(
                              colors: [Colors.red, Colors.lightGreen],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          child: SizedBox(height: double.infinity, width: 100),
                        ),
                      ),
                      SfSliderTheme(
                        data: SfSliderThemeData(
                          inactiveTrackColor: Colors.transparent,
                          activeTrackColor: Colors.transparent,
                          thumbColor: Colors.transparent,
                          tickOffset: const Offset(0, 0),
                          overlayColor: Colors.transparent,
                          tooltipBackgroundColor: Colors.white,
                          tooltipTextStyle:
                              Theme.of(context).textTheme.titleMedium,
                          activeDividerColor: Colors.black,
                          inactiveDividerColor: Colors.black,
                          labelOffset: const Offset(-160, 0),
                          activeLabelStyle:
                              Theme.of(context).textTheme.titleSmall,
                          inactiveLabelStyle:
                              Theme.of(context).textTheme.titleSmall,
                          activeDividerRadius: 2.0,
                          inactiveDividerRadius: 2.0,
                          trackCornerRadius: 5,
                        ),
                        child: SfSlider.vertical(
                          max: 1,
                          value: state.data?[state.currentIndex].contrast ?? 0,
                          showTicks: true,
                          showLabels: true,
                          onChanged: (dynamic values) {},
                          interval: 0.1,
                          tickShape: _SfTickShape(),
                          enableTooltip: true,
                          shouldAlwaysShowTooltip: true,
                          tooltipTextFormatterCallback: (
                            actualValue,
                            formattedText,
                          ) {
                            return actualValue.toString();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (state.data != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    var nextIndex = 0;
                    bool findFlag = false;
                    for (
                      var i =
                          state
                              .navigatorTextList[_tabBarController.index]
                              .length -
                          1;
                      i >= 0;
                      i--
                    ) {
                      if (findFlag) {
                        nextIndex =
                            state
                                .navigatorTextList[_tabBarController.index]
                                .keys
                                .toList()[i];
                        break;
                      }
                      if (state.navigatorTextList[_tabBarController.index].keys
                                  .toList()[i] ==
                              state.currentIndex &&
                          i > 0) {
                        findFlag = true;
                      }
                    }
                    if (!findFlag &&
                        state.navigatorTextList[_tabBarController.index].keys
                            .toList()
                            .isNotEmpty) {
                      nextIndex =
                          state.navigatorTextList[_tabBarController.index].keys
                              .toList()
                              .last;
                    }
                    context.read<ViewerBloc>().add(
                      SelectPage(selectedPage: nextIndex + 1),
                    );
                  },
                  icon: Icon(Icons.arrow_back, size: 30),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    _controller.text,

                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    " of ",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    state.navigatorTextList[_tabBarController.index].length
                        .toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    var nextIndex = 0;
                    bool findFlag = false;
                    for (
                      var i = 0;
                      i <
                          state
                              .navigatorTextList[_tabBarController.index]
                              .length;
                      i++
                    ) {
                      if (findFlag) {
                        nextIndex =
                            state
                                .navigatorTextList[_tabBarController.index]
                                .keys
                                .toList()[i];
                        break;
                      }
                      if (state.navigatorTextList[_tabBarController.index].keys
                                  .toList()[i] ==
                              state.currentIndex &&
                          i <
                              state
                                      .navigatorTextList[_tabBarController
                                          .index]
                                      .length -
                                  1) {
                        findFlag = true;
                      }
                    }
                    if (!findFlag &&
                        state.navigatorTextList[_tabBarController.index].keys
                            .toList()
                            .isNotEmpty) {
                      nextIndex =
                          state.navigatorTextList[_tabBarController.index].keys
                              .toList()[0];
                    }
                    context.read<ViewerBloc>().add(
                      SelectPage(selectedPage: nextIndex + 1),
                    );
                  },
                  icon: Icon(Icons.arrow_forward, size: 30),
                ),
              ],
            ),
          ),
        if (state.data == null)
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Please Select and Upload file to read!",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
      ],
    );
  }

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
            _controller.text = (state.currentIndex + 1).toString();
          },
          builder: _builder,
        ),
      ),
    );
  }
}

class _RectThumbShape extends SfThumbShape {
  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required RenderBox? child,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required SfThumb? thumb,
  }) {
    super.paint(
      context,
      center,
      parentBox: parentBox,
      child: child,
      themeData: themeData,
      currentValue: currentValue,
      paint: paint,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumb: thumb,
    );

    final Path path = Path();

    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx + 20, center.dy - 15);
    path.lineTo(center.dx + 20, center.dy + 55);
    path.close();
    context.canvas.drawPath(
      path,
      Paint()
        ..color = themeData.activeTrackColor!
        ..style = PaintingStyle.fill
        ..strokeWidth = 2,
    );
  }
}

class _SfTickShape extends SfTickShape {
  /// Enables subclasses to provide constant constructors.
  const _SfTickShape();

  /// Returns the size based on the values passed to it.
  Size getPreferredSize(SfSliderThemeData themeData) {
    return Size.copy(themeData.tickSize!);
  }

  /// Paints the major ticks based on the values passed to it.
  void paint(
    PaintingContext context,
    Offset offset,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
  }) {
    final Paint paint =
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = 2
          ..color = Colors.black;

    for (int i = 0; i < 8; i++) {
      context.canvas.drawLine(
        Offset(offset.dx - (125 - (i * 15)), offset.dy),
        Offset(offset.dx - (115 - (i * 15)), offset.dy),
        paint,
      );
    }
  }
}
