import 'package:nknu_connect/ffi/sso/sso_ffi_helper.dart';
import 'package:nknu_connect/ffi/sso/sso_json_api.dart';
import 'package:nknu_connect/services/sso_service.dart';

import '../ffi/ffi_loader.dart';

class NativeServices {
  static final NativeServices instance = NativeServices._internal();

  late final SsoService sso;

  NativeServices._internal() {
    // load lib sso
    SsoFfiHelper ssoFfiHelper = SsoFfiHelper(FfiLoader.load("libnknu.so"));
    SsoJsonApi ssoJsonApi = SsoJsonApi(ssoFfiHelper);
    sso = SsoService(ssoJsonApi);
  }
}
