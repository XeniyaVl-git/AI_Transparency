import 'dart:io' show File;
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart'
    show FilePicker, FilePickerResult, FileType;
import 'package:flutter/foundation.dart';
import 'package:metrik_viewer_x/viewerapp/models/data_row_model.dart';
import '../models/models.dart' show DataFrameModel;

part 'viewer_event.dart';

part 'viewer_state.dart';

class ViewerBloc extends Bloc<ViewerEvent, ViewerState> {
  List<List<dynamic>> rawFullData = [];
  List<DataRowModel> listData = [];
  String? professionName;
  List<dynamic>? professions;

  ViewerBloc()
    : super(
        ViewerState(
          isLoading: false,
          selectFile: false,
          currentIndex: 0,
          highlightProfessions: [],
          navigatorTextList: [],
          showContrast: false,
          groupFairnessSupIndex: 2,
          groupFairnessSelected: [0.33, 0.3],
          showBorderlineContrast: false,
        ),
      ) {
    on<SelectFile>(_onSelectFile);
    on<UploadFile>(_onUploadFile);
    on<NextPage>(_onNextPage);
    on<PrevPage>(_onPrevPage);
    on<SelectPage>(_onSelectPage);
    on<CheckShowBorderlineContrastEvent>(_onCheckShowBorderlineContrastEvent);
    on<CheckShowContrastEvent>(_onCheckShowContrastEvent);
    on<SelectProfessionEvent>(_onSelectProfessionEvent);
    on<NextProfessionEvent>(_onNextProfessionEvent);
    on<ChangeGroupFairnessSupIndex>(_onChangeGroupFairnessSupIndex);
  }

  void _onChangeGroupFairnessSupIndex(
    ChangeGroupFairnessSupIndex event,
    Emitter<ViewerState> emit,
  ) async {
    if (event.supIndex >= 0 && event.supIndex < state.groupFairnessSup.length) {
      emit(
        state.copyWith(
          groupFairnessSupIndex: event.supIndex,
          groupFairnessSelected: state.groupFairnessSup[event.supIndex],
        ),
      );
    }
  }

  void _onNextProfessionEvent(
    NextProfessionEvent event,
    Emitter<ViewerState> emit,
  ) async {
    // if (state.data != null && professions != null) {
    //   dynamic nextProfessionId = state.data!.professionId;
    //   for (int i = 0; i < professions!.length; i++) {
    //     if (professions![i] == state.data!.professionId) {
    //       if (i < professions!.length - 1) {
    //         nextProfessionId = professions![i + 1];
    //       } else {
    //         nextProfessionId = professions![0];
    //       }
    //     }
    //   }

    //   final newListData =
    //       listData.where((e) => e.professionId == nextProfessionId).toList();
    //   professionName = newListData[0].professionName;
    //   List<String> navigatorTextList = [];

    //   for (int i = 0; i < newListData.length; i++) {
    //     navigatorTextList.add(newListData[i].hardText);
    //   }

    //   emit(
    //     state.copyWith(
    //       data: newListData[0],
    //       dataListLength: newListData.length,

    //       navigatorTextList: navigatorTextList,
    //       currentIndex: 0,
    //     ),
    //   );
    // }
  }

  void _onSelectProfessionEvent(
    SelectProfessionEvent event,
    Emitter<ViewerState> emit,
  ) async {
    professionName = event.profession;

    final newListData =
        listData.where((e) => e.professionName == professionName).toList();

    if (newListData.isEmpty) return;
    final navigatorListData = _getNavigatorList(newListData);
    final index =
        navigatorListData[0].keys.isNotEmpty
            ? navigatorListData[0].keys.first
            : navigatorListData[1].keys.isNotEmpty
            ? navigatorListData[1].keys.first
            : navigatorListData[2].keys.first;
    emit(
      state.copyWith(
        data: newListData,
        dataListLength: newListData.length,
        navigatorTextList: navigatorListData,
        currentIndex: index,
        selectedProfessionMetadata: {
          'category_id': event.categoryId,
          'favors': event.favorsId,
        },
      ),
    );
  }

  List<String> _getBorderlineContrastProfessions() {
    final dataList = <String>[];

    for (var data in state.dashboardData!.entries) {
      if ((data.value['pvalue'] > 0.05 &&
              data.value['f1_score_difference'] >= 0.07 &&
              (data.value['count_male'] / data.value['count_female'] >= 3 ||
                  data.value['count_male'] / data.value['count_female'] <=
                      0.33)) ||
          (data.value['pvalue'] > 0.11 &&
              data.value['f1_score_difference'] >= 0.07)) {
        dataList.add(data.key);
      }
    }
    return dataList;
  }

  List<String> _getContrastProfessions() {
    final dataList = <String>[];

    for (var data in state.dashboardData!.entries) {
      if (data.value['pvalue'] < 0.05) {
        dataList.add(data.key);
      }
    }
    return dataList;
  }

  void _onCheckShowBorderlineContrastEvent(
    CheckShowBorderlineContrastEvent event,
    Emitter<ViewerState> emit,
  ) async {
    if (!state.showBorderlineContrast && state.dashboardData != null) {
      emit(
        state.copyWith(
          showBorderlineContrast: true,
          highlightProfessions: [
            ...state.highlightProfessions,
            ..._getBorderlineContrastProfessions(),
          ],
        ),
      );
    } else {
      emit(
        state.copyWith(
          showBorderlineContrast: false,
          highlightProfessions: [
            if (state.showContrast) ..._getContrastProfessions(),
          ],
        ),
      );
    }
  }

  List<List<dynamic>> _getListDataByFilters(
    bool showContrast,
    bool showBorderlineContrast,
  ) {
    final List<List<dynamic>> newRawData = [];
    listData.clear();

    for (int i = 0; i < rawFullData.length; i++) {
      final row = rawFullData[i];

      if (i == 0 ||
          (showContrast && row[8] <= 0.05) ||
          (showBorderlineContrast && row[8] <= 0.1 && row[8] > 0.05) ||
          row[8] > 0.1) {
        newRawData.add(row);

        if (i > 0) {
          listData.add(
            DataRowModel(
              id: i,
              hardText: row[0],
              professionId: row[1],
              genderId: row[2],
              pred: row[3],
              female: row[4],
              male: row[5],
              professionName: row[6],
              contrast: row[7],
              pvalue: row[8],
              statistic: row[9],
              pos: row[10],
              neg: row[11],
            ),
          );
        }
      }
    }
    return newRawData;
  }

  void _onCheckShowContrastEvent(
    CheckShowContrastEvent event,
    Emitter<ViewerState> emit,
  ) async {
    if (!state.showContrast && state.dashboardData != null) {
      emit(
        state.copyWith(
          showContrast: true,
          highlightProfessions: [
            ...state.highlightProfessions,
            ..._getContrastProfessions(),
          ],
        ),
      );
    } else {
      emit(
        state.copyWith(
          showContrast: false,
          highlightProfessions: [
            if (state.showBorderlineContrast)
              ..._getBorderlineContrastProfessions(),
          ],
        ),
      );
    }
  }

  void _onSelectPage(SelectPage event, Emitter<ViewerState> emit) async {
    if (state.data != null &&
        state.data!.isNotEmpty &&
        event.selectedPage - 1 >= 0 &&
        event.selectedPage - 1 < state.data!.length) {
      emit(state.copyWith(currentIndex: event.selectedPage - 1));
    }
  }

  void _onNextPage(NextPage event, Emitter<ViewerState> emit) async {
    if (state.data != null &&
        state.data!.isNotEmpty &&
        state.currentIndex < state.data!.length - 1) {
      final newIndex = state.currentIndex.toInt() + 1;
      emit(state.copyWith(currentIndex: newIndex));
    }
  }

  void _onPrevPage(PrevPage event, Emitter<ViewerState> emit) async {
    if (state.data != null &&
        state.data!.isNotEmpty &&
        state.currentIndex > 0) {
      final newIndex = state.currentIndex.toInt() - 1;
      emit(state.copyWith(currentIndex: newIndex));
    }
  }

  void _onUploadFile(UploadFile event, Emitter<ViewerState> emit) async {
    if (state.filePickerResult == null) {
      return;
    }
    emit(state.copyWith(isLoading: true));
    // File file = File(result.files.single.path!);
    var d = FirstOccurrenceSettingsDetector(
      eols: ['\r\n', '\n'],
      textDelimiters: ['"', "'"],
    );
    // List<List<dynamic>> listData =
    rawFullData = const CsvToListConverter().convert(
      await state.filePickerResult!.files.single.xFile.readAsString(),
      csvSettingsDetector: d,
    );
    final dashboardData = _computeData(rawFullData);
    listData.clear();

    for (int i = 1; i < rawFullData.length; i++) {
      final row = rawFullData[i];
      listData.add(
        DataRowModel(
          id: 0,
          hardText: row[0],
          professionId: row[1],
          genderId: row[2],
          pred: row[3],
          female: row[4],
          male: row[5],
          professionName: row[6],
          contrast: row[7],
          pvalue: row[8],
          statistic: row[9],
          pos: row[10],
          neg: row[11],
        ),
      );
    }

    emit(
      state.copyWith(
        isLoading: false,
        selectFile: false,
        fileName: state.filePickerResult!.files.single.name.toString(),
        data: listData,
        dataListLength: listData.length,
        navigatorTextList: [{}, {}, {}],
        dashboardData: dashboardData,
      ),
    );
  }

  void _onSelectFile(SelectFile event, Emitter<ViewerState> emit) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["csv"],
    );

    if (result != null) {
      return emit(
        state.copyWith(
          selectFile: false,
          fileName: result.files.single.name.toString(),
          filePickerResult: result,
        ),
      );
    }

    return emit(state.copyWith(selectFile: false));
  }

  List<Map<int, String>> _getNavigatorList(List<DataRowModel> newListDatas) {
    List<Map<int, String>> navigatorTextList = [{}, {}, {}];

    double contrastSum = 0;
    if (newListDatas.isEmpty) return navigatorTextList;

    for (int i = 0; i < newListDatas.length; i++) {
      contrastSum += newListDatas[i].contrast;
    }

    final contrastMean = contrastSum / newListDatas.length;

    for (int i = 0; i < newListDatas.length; i++) {
      if (contrastMean + 0.1 < newListDatas[i].contrast) {
        navigatorTextList[2][i] = newListDatas[i].hardText;
      } else if (contrastMean - 0.1 > newListDatas[i].contrast) {
        navigatorTextList[0][i] = newListDatas[i].hardText;
      } else {
        navigatorTextList[1][i] = newListDatas[i].hardText;
      }
    }

    return navigatorTextList;
  }

  double _computeF1(
    List<int> yTrue,
    List<int> yPred,
    String profName,
    int gender,
  ) {
    int tp = 0, fp = 0, fn = 0;
    for (int i = 0; i < yPred.length; i++) {
      if (yTrue[i] == 1 && yPred[i] == 1) {
        tp++;
      } else if (yTrue[i] == 0 && yPred[i] == 1) {
        fp++;
      } else if (yTrue[i] == 1 && yPred[i] == 0) {
        fn++;
      }
    }

    if (tp + fp == 0 || tp + fn == 0) return 0.0;

    double precision = tp / (tp + fp);
    double recall = tp / (tp + fn);

    return (2 * (precision * recall) / (precision + recall));
  }

  Map<String, Map<String, dynamic>> _computeData(List<List<dynamic>> fields) {
    final headers = fields.first.map((e) => e.toString()).toList();
    final data = fields.sublist(1);

    int idxGender = headers.indexOf('gender');
    int idxProfession = headers.indexOf('profession');
    int idxPred = headers.indexOf('pred');
    int idxProfName = headers.indexOf('profession_name');
    int idxPvalue = headers.indexOf('pvalue');

    // Список профессий
    professions = data.map((row) => row[idxProfession]).toSet().toList();
    professions?.sort();

    Map<String, Map<String, dynamic>> results = {};
    if (professions == null) return {};
    for (var profession in professions!) {
      for (var gender in [0, 1]) {
        final filtered =
            data
                .where(
                  (row) =>
                      row[idxGender] == gender &&
                      row[idxProfession] == profession,
                )
                .toList();

        final filtered2 =
            data.where((row) => row[idxGender] == gender).toList();

        List<int> yTrue =
            filtered2
                .map((r) => r[idxProfession] == profession ? 1 : 0)
                .toList();
        List<int> yPred =
            filtered2.map((r) => r[idxPred] == profession ? 1 : 0).toList();

        final f1 = _computeF1(yTrue, yPred, profession.toString(), gender);

        String profName =
            filtered.firstWhere(
              (r) => r[idxProfession] == profession,
              orElse: () => [null],
            )[idxProfName];

        results.putIfAbsent(
          profName,
          () => {
            'count_male': 0,
            'count_female': 0,
            'f1_male': 0.0,
            'f1_female': 0.0,
            'pvalue': 0.0,
          },
        );

        if (gender == 0) {
          results[profName]!['count_male'] = filtered.length;
          results[profName]!['f1_male'] = f1;
        } else {
          results[profName]!['count_female'] = filtered.length;
          results[profName]!['f1_female'] = f1;
        }

        // Один раз p-value
        if (results[profName]!['pvalue'] == 0.0 && filtered.isNotEmpty) {
          results[profName]!['pvalue'] = filtered.first[idxPvalue];
        }
      }
    }

    // Расчёт разницы
    for (var entry in results.entries) {
      var diff =
          ((entry.value['f1_male'] ?? 0) - (entry.value['f1_female'] ?? 0));
      if (diff < 0) diff *= -1;
      entry.value['f1_score_difference'] = diff;
    }

    return results;
  }
}
