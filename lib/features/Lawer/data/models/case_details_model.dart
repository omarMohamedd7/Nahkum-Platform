class CaseDetailsModel {
  final List<String> files;

  CaseDetailsModel({required this.files});

  factory CaseDetailsModel.fromJson(Map<String, dynamic> json) {
    var filesList = <String>[];
    if (json['attachments'] != null) {
      filesList.add(json['attachments']['url'].toString());
    }
    return CaseDetailsModel(files: filesList);
  }
}
