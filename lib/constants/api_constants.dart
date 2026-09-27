import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Base URL resolution order:
  // 1. --dart-define=API_BASE_URL=http://<your-pc-lan-ip>:5000  (REQUIRED for a physical
  //    device such as the realme C3 — it cannot reach "localhost" or "10.0.2.2",
  //    those only resolve on an emulator/simulator. Find your PC's LAN IP with
  //    `ipconfig` on Windows (look for "IPv4 Address" on your Wi-Fi adapter) and make
  //    sure the phone is on the same Wi-Fi network as the backend server.
  // 2. If not provided, falls back to emulator/desktop-friendly defaults below.
  static const String _overrideUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_overrideUrl.isNotEmpty) {
      return _overrideUrl;
    }
    if (kIsWeb) {
      return 'http://localhost:5000';
    }
    if (Platform.isAndroid) {
      // 10.0.2.2 points to host machine localhost from the standard Android
      // EMULATOR only. This does NOT work on a physical phone — pass
      // --dart-define=API_BASE_URL=http://<lan-ip>:5000 when running on a real device.
      return 'http://10.0.2.2:5000';
    }
    return 'http://localhost:5000';
  }

  // Endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String profileEndpoint = '/api/auth/me';
  static const String productsEndpoint = '/api/products';
  static const String categoriesEndpoint = '/api/categories';
  static const String ordersEndpoint = '/api/orders';
  static const String trackOrderEndpoint = '/api/orders/track';
  static const String chatbotEndpoint = '/api/chatbot';
  static const String feedbackEndpoint = '/api/feedback';

  // Hub Info
  static const String storeName = 'HERBSKIN HEAVEN';
  static const String tagline = "Nature's Care, Crafted for You";
  static const String hubLocation = 'Palpannai, Trichy-8, Tamil Nadu';
  static const String ownerEmail = 'rpandimeenacsc@gmail.com';
}
