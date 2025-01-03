// SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>
//
// SPDX-License-Identifier: MIT

/// Constants for the config files
library;

import 'package:bro_config_manager/src/types/config_environment_type.dart';

/// Default config folder path, the path is relative to the root of the project
const defaultConfigFolderPath = "assets/configs";

/// This is the name of the default config file
const defaultConfigFileName = "default";

/// This is the name of the local config file
const localConfigFileName = "local";

/// This is the name of the build environment key to find the application environment type
const envKeyName = "APP_ENV";

/// This is the extensions which can be used to identify YAML files.
const configYamlExtensions = <String>[
  ".json",
  ".yaml",
  ".yml",
];

/// This is the extension of dot env files
const dotEnvFileExtension = ".env";

/// This is the name of the custom environment variables file
const envMapFileName = "env_mapping";

/// This is the environment type to use when the environment type is not given by the build
/// environment.
const defaultEnvType = ConfigEnvironmentType.development;
