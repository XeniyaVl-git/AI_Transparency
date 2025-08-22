part of 'viewer_bloc.dart';

@immutable
abstract class ViewerEvent {}

class SelectFile extends ViewerEvent {
  SelectFile();
}

class UploadFile extends ViewerEvent {
  UploadFile();
}

class NextPage extends ViewerEvent {
  NextPage();
}

class PrevPage extends ViewerEvent {
  PrevPage();
}

class SelectPage extends ViewerEvent {
  final int selectedPage;
  SelectPage({required this.selectedPage});
}

class CheckShowBorderlineContrastEvent extends ViewerEvent {
  CheckShowBorderlineContrastEvent();
}

class CheckShowContrastEvent extends ViewerEvent {
  CheckShowContrastEvent();
}

class SelectProfessionEvent extends ViewerEvent {
  final String profession;
  final int categoryId;
  final int favorsId;
  SelectProfessionEvent({
    required this.profession,
    required this.categoryId,
    required this.favorsId,
  });
}

class NextProfessionEvent extends ViewerEvent {
  NextProfessionEvent();
}

class ChangeGroupFairnessSupIndex extends ViewerEvent {
  final int supIndex;

  ChangeGroupFairnessSupIndex({required this.supIndex});
}
