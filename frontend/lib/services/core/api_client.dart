import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../screens/auth/auth_config.dart';
import '../auth/token_service.dart';
import '../../screens/auth/splash_screen.dart';

class ApiClient {
  // Internal: a single in-flight refresh future so concurrent requests don't rotate refresh token twice
  static Future<bool>? _refreshFuture;

  // POST with Authorization header and built-in refresh-on-401 logic
  static Future<http.Response?> postWithAuth(BuildContext context, String path, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    final uri = Uri.parse('$backendHost$path');

    final defaultHeaders = <String, String>{'Content-Type': 'application/json'};
    if (TokenService.accessToken != null) {
      defaultHeaders['Authorization'] = 'Bearer ${TokenService.accessToken}';
    }
    if (headers != null) defaultHeaders.addAll(headers);

    // First attempt
    final resp = await http.post(uri, headers: defaultHeaders, body: body, encoding: encoding);
    if (resp.statusCode != 401) return resp;

    // If 401, we need to refresh. Use a single shared refresh future so concurrent requests wait for it.
    final currentRefresh = TokenService.refreshToken;
    debugPrint('[ApiClient] Received 401 for $path; refreshToken present=${currentRefresh!=null}');
    if (currentRefresh == null) {
      _logoutToSplash(context);
      return null;
    }

    // If a refresh is already in progress, wait for it to complete (success==true means refreshed)
    if (_refreshFuture != null) {
      debugPrint('[ApiClient] Waiting on existing refresh future for $path');
      final refreshed = await _refreshFuture!;
      debugPrint('[ApiClient] Existing refresh future completed: $refreshed');
      if (!refreshed) {
        _logoutToSplash(context);
        return null;
      }
      // retry original request with updated token
      final retryHeaders = <String, String>{'Content-Type': 'application/json'};
      if (TokenService.accessToken != null) retryHeaders['Authorization'] = 'Bearer ${TokenService.accessToken}';
      if (headers != null) retryHeaders.addAll(headers);
      debugPrint('[ApiClient] Retrying $path after refresh (via existing future)');
      return await http.post(uri, headers: retryHeaders, body: body, encoding: encoding);
    }

    // Start refresh and store the future
    debugPrint('[ApiClient] Starting refresh for $path');
    _refreshFuture = _doRefresh(context, currentRefresh);
    final refreshResult = await _refreshFuture!;
    debugPrint('[ApiClient] Refresh completed for $path: $refreshResult');
    _refreshFuture = null;

    if (!refreshResult) {
      _logoutToSplash(context);
      return null;
    }

    // retry original request with new token
    final retryHeaders = <String, String>{'Content-Type': 'application/json'};
    if (TokenService.accessToken != null) retryHeaders['Authorization'] = 'Bearer ${TokenService.accessToken}';
    if (headers != null) retryHeaders.addAll(headers);
    return await http.post(uri, headers: retryHeaders, body: body, encoding: encoding);
  }

  // GET with Authorization header and built-in refresh-on-401 logic
  static Future<http.Response?> getWithAuth(BuildContext context, String path, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$backendHost$path');

    final defaultHeaders = <String, String>{'Content-Type': 'application/json'};
    if (TokenService.accessToken != null) {
      defaultHeaders['Authorization'] = 'Bearer ${TokenService.accessToken}';
    }
    if (headers != null) defaultHeaders.addAll(headers);

    // First attempt
    final resp = await http.get(uri, headers: defaultHeaders);
    if (resp.statusCode != 401) return resp;

    // If 401, we need to refresh. Use a single shared refresh future so concurrent requests wait for it.
    final currentRefresh = TokenService.refreshToken;
    debugPrint('[ApiClient] Received 401 for $path; refreshToken present=${currentRefresh!=null}');
    if (currentRefresh == null) {
      _logoutToSplash(context);
      return null;
    }

    // If a refresh is already in progress, wait for it to complete (success==true means refreshed)
    if (_refreshFuture != null) {
      debugPrint('[ApiClient] Waiting on existing refresh future for $path');
      final refreshed = await _refreshFuture!;
      debugPrint('[ApiClient] Existing refresh future completed: $refreshed');
      if (!refreshed) {
        _logoutToSplash(context);
        return null;
      }
      // retry original request with updated token
      final retryHeaders = <String, String>{'Content-Type': 'application/json'};
      if (TokenService.accessToken != null) retryHeaders['Authorization'] = 'Bearer ${TokenService.accessToken}';
      if (headers != null) retryHeaders.addAll(headers);
      debugPrint('[ApiClient] Retrying GET $path after refresh (via existing future)');
      return await http.get(uri, headers: retryHeaders);
    }

    // Start refresh and store the future
    debugPrint('[ApiClient] Starting refresh for $path');
    _refreshFuture = _doRefresh(context, currentRefresh);
    final refreshResult = await _refreshFuture!;
    debugPrint('[ApiClient] Refresh completed for $path: $refreshResult');
    _refreshFuture = null;

    if (!refreshResult) {
      _logoutToSplash(context);
      return null;
    }

    // retry original request with new token
    final retryHeaders = <String, String>{'Content-Type': 'application/json'};
    if (TokenService.accessToken != null) retryHeaders['Authorization'] = 'Bearer ${TokenService.accessToken}';
    if (headers != null) retryHeaders.addAll(headers);
    return await http.get(uri, headers: retryHeaders);
  }

  // Performs the refresh flow and returns true if refreshed successfully
  static Future<bool> _doRefresh(BuildContext context, String refresh) async {
    try {
      final refreshUri = Uri.parse('$backendHost/api/auth/refresh');
      debugPrint('[ApiClient] POST $refreshUri with refreshToken prefix=${refresh.substring(0, min(6, refresh.length))}');
      final refreshResp = await http.post(refreshUri, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'refreshToken': refresh}));
      debugPrint('[ApiClient] refresh response status=${refreshResp.statusCode} body=${refreshResp.body}');
      if (refreshResp.statusCode == 200) {
        final bodyJson = jsonDecode(refreshResp.body);
        final newAccess = bodyJson['accessToken'] as String?;
        final newRefresh = bodyJson['refreshToken'] as String?;
        if (newAccess != null && newRefresh != null) {
          TokenService.setTokens(accessToken: newAccess, refreshToken: newRefresh);
          debugPrint('[ApiClient] Tokens updated via refresh; new access prefix=${newAccess.substring(0, min(6, newAccess.length))}');
          return true;
        }
      }
    } catch (e) {
      debugPrint('[ApiClient] _doRefresh exception: $e');
    }
    return false;
  }

  static void _logoutToSplash(BuildContext context) {
    debugPrint('[ApiClient] Logging out and clearing tokens');
    TokenService.clear();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (r) => false);
  }
}
