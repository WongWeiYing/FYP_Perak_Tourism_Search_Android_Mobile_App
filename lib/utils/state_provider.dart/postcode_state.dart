import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_perak/data/location.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postcodeProvider =
    StateNotifierProvider<PostcodeState, Perak?>((ref) => PostcodeState());
// final postcodeProvider = FutureProvider<Perak?>((ref) async {
//   final provider = PostcodeState();
//   await provider.initFromJson(); // Wait for initialization
//   return provider.state;
// });

class PostcodeState extends StateNotifier<Perak?> {
  PostcodeState() : super(null);

  Future<void> initFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('assets/jsons/perak.json');
      debugPrint("Loaded Raw JSON: $jsonString"); // Print the full JSON
      final jsonMap = jsonDecode(jsonString);
      debugPrint("Decoded JSON: $jsonMap"); // Print after decoding
      state = Perak.fromJson(jsonMap);
      debugPrint("State.city: ${state?.city ?? ''}"); // P
    } catch (e) {
      debugPrint("Error loading JSON: $e"); // Print any errors
    }
  }

  Map<String, String> autoPopulateFromPostCode({required String postcode}) {
    Map<String, String> resultMap = {
      'city': '',
      'state': '',
      'country': '',
    };

    if (state == null || state!.city.isEmpty) return resultMap;

    for (var city in state!.city) {
      if (city.postcode.contains(postcode)) {
        resultMap['city'] = city.name;
        resultMap['state'] = 'Perak';
        resultMap['country'] = 'Malaysia';
        break;
      }
    }

    return resultMap;
  }
}
