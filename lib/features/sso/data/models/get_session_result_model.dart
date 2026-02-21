class GetSessionResultModel {
  final String sessionId;
  final String viewState;
  final String error;

  GetSessionResultModel.fromJson(Map<String, dynamic> json) {
    if (json["err"] != "") {
      error = json["err"];
    }
  }
}
