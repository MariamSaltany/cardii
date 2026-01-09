import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:saees_cards/services/api.dart';

class BaseProvider with ChangeNotifier {
  bool busy = false;
  Api api = Api();

  void setBusy(bool status) {
    busy = status;
    notifyListeners();
  }

  bool failed = false;
  void setFailed(bool status) {
    failed = status;
    notifyListeners();
  }

  String? errorMessage;
  void setErrorMessage(String? msg) {
    errorMessage = msg;
    notifyListeners();
  }

  List<dynamic> items = [];
  bool hasMore = true;
  bool isPaginating = false;
  int currentPage = 1;
  String? nextUrl;

  Future<void> fetchPaginated({
    required String endpoint,
    bool loadMore = false,
    required List<dynamic> Function(List<dynamic> data) parseData,
    int perPage = 14,
  }) async {
    if (busy || isPaginating || !hasMore) return;

    if (!loadMore) {
      currentPage = 1;
      items.clear();
      nextUrl = null;
      setBusy(true);
    } else {
      isPaginating = true;
    }
    notifyListeners();

    try {
      String url;
      if (loadMore && nextUrl != null) {
        url = nextUrl!;
      } else {
        url = "$endpoint?page=$currentPage&per_page=$perPage";
      }

      final response = await api.get(url, perPage: perPage);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'] ?? [];
        final parsedItems = parseData(data);

        if (loadMore) {
          items.addAll(parsedItems);
        } else {
          items = parsedItems;
        }

        nextUrl = jsonData['links']?['next'];
        hasMore = nextUrl != null && parsedItems.isNotEmpty;
        currentPage++;
      } else {
        hasMore = false;
        setErrorMessage("Failed to load data");
      }
    } catch (e) {
      hasMore = false;
      setErrorMessage("Network error: $e");
    } finally {
      isPaginating = false;
      if (!loadMore) setBusy(false);
      notifyListeners();
    }
  }

  void resetPagination() {
    items.clear();
    hasMore = true;
    isPaginating = false;
    currentPage = 1;
    nextUrl = null;
    notifyListeners();
  }

  Future<void> refresh({
    required String endpoint,
    required List<dynamic> Function(List<dynamic>) parseData,
    int perPage = 20,
  }) async {
    await fetchPaginated(
      endpoint: endpoint,
      loadMore: false,
      parseData: parseData,
      perPage: perPage,
    );
  }
}
