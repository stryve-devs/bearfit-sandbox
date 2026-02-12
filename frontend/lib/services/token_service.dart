import 'package:flutter/foundation.dart';
import 'dart:math';

class TokenService {
  static String? _accessToken;
  static String? _refreshToken;

  static void setTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    // Debug
    // ignore: avoid_print
    debugPrint('[TokenService] setTokens accessPrefix=${accessToken.substring(0, min(6, accessToken.length))} refreshPrefix=${refreshToken.substring(0, min(6, refreshToken.length))}');
  }

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;

  static void clear() {
    _accessToken = null;
    _refreshToken = null;
    // ignore: avoid_print
    debugPrint('[TokenService] cleared tokens');
  }
}
