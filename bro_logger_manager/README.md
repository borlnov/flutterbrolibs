<!--
SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>

SPDX-License-Identifier: MIT
-->

# Bro logger manager <!-- omit from toc -->

## Table of contents

- [Table of contents](#table-of-contents)
- [Introduction](#introduction)
- [Configuration](#configuration)

## Introduction

This package is an implementation of the [logger](https://pub.dev/packages/logger) package with the
manager system. It allows you to have multiple loggers in your application and to manage them
easily.

This package is based on the [bro_abstract_manager](https://pub.dev/packages/bro_abstract_manager)
and [bro_abstract_logger](https://pub.dev/packages/bro_abstract_logger) packages.

## Configuration

If you use the [LoggerManager](lib/src/services/logger_manager.dart) class,
you have to add the [MixinLoggerConfigs](lib/src/mixins/mixin_logger_configs.dart) to your
app config manager.

Read the mixin, to see what you have to set in your config files.
