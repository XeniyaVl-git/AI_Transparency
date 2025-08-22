part of 'viewer_bloc.dart';

@immutable
class ViewerState extends Equatable {
  final bool isLoading;
  final String? fileName;
  final List<DataRowModel>? data;
  final Map<String, dynamic>? selectedProfessionMetadata;
  final FilePickerResult? filePickerResult;
  final bool selectFile;
  final int currentIndex;
  final List<Map<int, String>> navigatorTextList;
  final List<String> highlightProfessions;
  final Map<String, Map<String, dynamic>>? dashboardData;
  final bool showContrast;
  final bool showBorderlineContrast;
  final int groupFairnessSupIndex;
  final List<double> groupFairnessSelected;
  final List<List<double>> groupFairnessSup;

  @override
  List<Object?> get props => [
    isLoading,
    data ?? "",
    selectFile,
    fileName ?? "",
    navigatorTextList,
    dashboardData ?? "",
    showContrast,
    currentIndex,
    highlightProfessions,
    showBorderlineContrast,
    groupFairnessSupIndex,
    groupFairnessSelected,
    selectedProfessionMetadata ?? "",
  ];

  ViewerState({
    required this.isLoading,
    this.data,
    required this.selectFile,
    this.fileName,
    required this.currentIndex,
    this.filePickerResult,
    required this.navigatorTextList,
    this.dashboardData,
    this.selectedProfessionMetadata,
    required this.groupFairnessSupIndex,
    required this.groupFairnessSelected,
    required this.highlightProfessions,
    required this.showContrast,
    required this.showBorderlineContrast,
  }) : groupFairnessSup = [
         [0.1, 1],
         [0.2, 2],
         [0.33, 3],
         [0.4, 4],
         [0.5, 5],
         [0.6, 6],
         [0.7, 7],
         [0.8, 8],
         [0.9, 9],
       ];

  ViewerState copyWith({
    bool? isLoading,
    List<DataRowModel>? data,
    bool? selectFile,
    String? fileName,
    int? currentIndex,
    FilePickerResult? filePickerResult,
    int? dataListLength,
    List<String>? highlightProfessions,
    List<Map<int, String>>? navigatorTextList,
    Map<String, Map<String, dynamic>>? dashboardData,
    int? groupFairnessSupIndex,
    List<double>? groupFairnessSelected,
    bool? showContrast,
    bool? showBorderlineContrast,
    Map<String, dynamic>? selectedProfessionMetadata,
  }) {
    return ViewerState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      selectFile: selectFile ?? this.selectFile,
      fileName: fileName ?? this.fileName,
      highlightProfessions: highlightProfessions ?? this.highlightProfessions,
      currentIndex: currentIndex ?? this.currentIndex,
      filePickerResult: filePickerResult ?? this.filePickerResult,
      navigatorTextList: navigatorTextList ?? this.navigatorTextList,
      dashboardData: dashboardData ?? this.dashboardData,
      showContrast: showContrast ?? this.showContrast,
      groupFairnessSelected:
          groupFairnessSelected ?? this.groupFairnessSelected,
      groupFairnessSupIndex:
          groupFairnessSupIndex ?? this.groupFairnessSupIndex,
      showBorderlineContrast:
          showBorderlineContrast ?? this.showBorderlineContrast,
      selectedProfessionMetadata:
          selectedProfessionMetadata ?? this.selectedProfessionMetadata,
    );
  }
}
