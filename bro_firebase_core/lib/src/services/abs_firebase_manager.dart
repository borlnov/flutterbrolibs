// SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

import 'package:bro_firebase_core/src/models/init_firebase_config.dart';
import 'package:bro_firebase_core/src/services/abs_firebase_service.dart';
import 'package:bro_global_manager/bro_global_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

/// This is the abstract builder for the [AbsFirebaseManager].
abstract class AbsFirebaseBuilder<M extends AbsFirebaseManager> extends AbsManagerBuilder<M> {
  /// Class constructor
  const AbsFirebaseBuilder();
}

/// This is the abstract manager for Firebase.
///
/// This class is used to initialize Firebase and its services. The services are initialized in
/// the [initLifeCycle] method and disposed in the [disposeLifeCycle] method.
///
/// The managed [AbsFirebaseService] are got from the [InitFirebaseConfig] returned by the
/// [getFirebaseOptions] method.
abstract class AbsFirebaseManager extends AbsWithLifeCycle {
  /// The list of the [AbsFirebaseService] managed by this manager.
  final List<AbsFirebaseService> _services;

  /// The [FirebaseApp] instance used by this manager.
  late final FirebaseApp _app;

  /// Class constructor.
  AbsFirebaseManager() : _services = [];

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initLifeCycle}
  @override
  Future<void> initLifeCycle() async {
    await super.initLifeCycle();
    final config = await getFirebaseOptions();

    _services.addAll(config.services);

    _app = await Firebase.initializeApp(
      options: config.firebaseOptions,
    );

    await Future.wait(_services.map((service) => service.initLifeCycle()));
  }

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.initAfterViewBuilt}
  @override
  Future<void> initAfterViewBuilt(BuildContext context) async {
    await super.initAfterViewBuilt(context);
    await Future.wait(_services.map((service) => service.initAfterViewBuilt(context)));
  }

  /// Get the [InitFirebaseConfig] config to init the manager and the linked services.
  @protected
  Future<InitFirebaseConfig> getFirebaseOptions();

  /// {@macro bro_abstract_manager.AbsWithLifeCycle.disposeLifeCycle}
  @override
  Future<void> disposeLifeCycle() async {
    await Future.wait(_services.map((service) => service.disposeLifeCycle()));
    await _app.delete();
    await super.disposeLifeCycle();
  }
}
