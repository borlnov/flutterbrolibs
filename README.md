<!--
SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>

SPDX-License-Identifier: MIT
-->

# Flutter Bro libraries <!-- omit from toc -->

## Badges

[![Flutter Unit Tests](https://github.com/borlnov/flutterbrolibs/actions/workflows/flutter_unit_tests.yml/badge.svg)](https://github.com/borlnov/flutterbrolibs/actions/workflows/flutter_unit_tests.yml)
[![Markdown Lint](https://github.com/borlnov/flutterbrolibs/actions/workflows/markdown_lint.yml/badge.svg)](https://github.com/borlnov/flutterbrolibs/actions/workflows/markdown_lint.yml)
[![REUSE Compliance Check](https://github.com/borlnov/flutterbrolibs/actions/workflows/reuse_compliance.yml/badge.svg)](https://github.com/borlnov/flutterbrolibs/actions/workflows/reuse_compliance.yml)

## Table of contents

- [Badges](#badges)
- [Table of contents](#table-of-contents)
- [Introduction](#introduction)
- [Packages list](#packages-list)
- [Quick start](#quick-start)
  - [Generate the packages list](#generate-the-packages-list)
  - [Publish one package](#publish-one-package)

## Introduction

This contains shared flutter packages to use in projects.

## Packages list

| Package                                       | Description                                                               | Version                                                               |
|-----------------------------------------------|---------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| [bro_abstract_logger](bro_abstract_logger/)   | This package contains abstract classes to loggers with managers.          | [![pub package](https://img.shields.io/pub/v/bro_abstract_logger.svg)](https://pub.dev/packages/bro_abstract_logger)   |
| [bro_abstract_manager](bro_abstract_manager/) | This package contains abstract classes to work with managers.             | [![pub package](https://img.shields.io/pub/v/bro_abstract_manager.svg)](https://pub.dev/packages/bro_abstract_manager) |
| [bro_config_manager](bro_config_manager/)     | This package contains the configuration manager for your application.     | [![pub package](https://img.shields.io/pub/v/bro_config_manager.svg)](https://pub.dev/packages/bro_config_manager)     |
| [bro_file_utility](bro_file_utility/)         | This contains utility functions for manipulating files and assets.        | [![pub package](https://img.shields.io/pub/v/bro_file_utility.svg)](https://pub.dev/packages/bro_file_utility)         |
| [bro_global_manager](bro_global_manager/)     | This contains the abstract global manager for the application.            | [![pub package](https://img.shields.io/pub/v/bro_global_manager.svg)](https://pub.dev/packages/bro_global_manager)     |
| [bro_list_utility](bro_list_utility/)         | This package contains utility classes for managing lists and maps.        | [![pub package](https://img.shields.io/pub/v/bro_list_utility.svg)](https://pub.dev/packages/bro_list_utility)         |
| [bro_types_utility](bro_types_utility/)       | This package contains utility classes for managing object types.          | [![pub package](https://img.shields.io/pub/v/bro_types_utility.svg)](https://pub.dev/packages/bro_types_utility)       |
| [bro_yaml_utility](bro_yaml_utility/)         | This package contains utility classes for managing JSON and YAML objects. | [![pub package](https://img.shields.io/pub/v/bro_yaml_utility.svg)](https://pub.dev/packages/bro_yaml_utility)         |

## Quick start

### Generate the packages list

To generate the packages list, run the following command:

```bash
mono_repo readme -p --pad
```

Then copy/past the output in the README.md file.

### Publish one package

To publish a new package, you have to update its version in the pubspec.yaml file and then create a
new tag with the following format: `<package_name>-v<version>`.

Don't forget to update the CHANGELOG.md file with the new version and the changes.

Then push the changes and the tag to the repository.

The GitHub action will publish the package to pub.dev.
