<!--
SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>

SPDX-License-Identifier: MIT
-->

# Bro global manager <!-- omit from toc -->

## Table of contents

- [Table of contents](#table-of-contents)
- [Introduction](#introduction)
- [Usage](#usage)

## Introduction

This contains the abstract global manager for the application.

This package is based on the [bro_abstract_manager](https://pub.dev/packages/bro_abstract_manager)
package.

The global manager is a singleton that manages the global data of the application. It's the entry
point in the application for all the other managers. It initializes all the managers and provides
a single point of access to them.

## Usage

```dart
import 'package:bro_global_manager/bro_global_manager.dart';

/// The global manager of the application.
class GlobalManager extends AbsGlobalManager {
  /// This is the static getter to get the instance of the global manager.
  static GlobalManager get instance => AbsGlobalManager.getCastedInstance(GlobalManager.new);

  /// Register the managers.
  @override
  void registerManagers(
      void Function<M extends AbsWithLifeCycle, B extends AbsManagerBuilder<M>>(B builder)
          registerManager) {}
}
```
