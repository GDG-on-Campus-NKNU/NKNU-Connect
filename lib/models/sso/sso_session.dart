class SsoSession {
  String sessionID;
  String viewState;

  SsoSession({required this.sessionID, required this.viewState});

  factory SsoSession.fromJson(Map<String, dynamic> json) {
    return SsoSession(
      sessionID: json["data"]["aspNETSessionId"],
      viewState: json["data"]["viewState"],
    );
  }
}
