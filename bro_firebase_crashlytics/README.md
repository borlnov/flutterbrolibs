<!--
SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>

SPDX-License-Identifier: MIT
-->

# Bro firebase crashlytics <!-- omit from toc -->

## Table of contents

- [Table of contents](#table-of-contents)
- [Introduction](#introduction)
- [Configuration](#configuration)

## Introduction

This package imports the [firebase_crashlytics](https://pub.dev/packages/firebase_crashlytics)
package to the manager system
(_see [bro_abstract_manager](https://pub.dev/packages/bro_abstract_manager)_).

## Configuration

If you use the [CrashlyticsLoggerManager](lib/src/services/crashlytics_logger_manager.dart) class,
you have to add the [MixinCrashlyticsConfigs](lib/src/mixins/mixin_crashlytics_configs.dart) to your
app config manager.

Read the mixin, to see what you have to set in your config files.
