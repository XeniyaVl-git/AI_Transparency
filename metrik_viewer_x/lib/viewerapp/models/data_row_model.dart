class DataRowModel {
  final int id;
  final String hardText;
  final int professionId;
  final int genderId;
  final int pred;
  final int female;
  final int male;
  final String professionName;
  final double contrast;
  final double pvalue;
  final double statistic;
  final double pos;
  final double neg;

  DataRowModel({
    required this.professionId,
    required this.genderId,
    required this.pred,
    required this.female,
    required this.male,
    required this.professionName,
    required this.contrast,
    required this.pvalue,
    required this.statistic,
    required this.pos,
    required this.neg,
    required this.id,
    required this.hardText,
  });
}
