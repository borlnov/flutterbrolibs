// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_firebase_core/src/services/abs_firebase_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';

/// This is the configuration used to initialize Firebase.
class InitFirebaseConfig extends Equatable {
  /// The [FirebaseOptions] used to initialize Firebase.
  final FirebaseOptions firebaseOptions;

  /// The list of [AbsFirebaseService] to initialize.
  final List<AbsFirebaseService> services;

  /// Class constructor.
  const InitFirebaseConfig({
    required this.firebaseOptions,
    this.services = const [],
  });

  /// {@macro bro_abstract_manager.AbsManagerBuilder.getDependencies}
  @override
  List<Object?> get props => [firebaseOptions, services];
}
