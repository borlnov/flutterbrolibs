library;

import 'package:bro_config_manager/src/types/config_environment_type.dart';

const defaultConfigFolderPath = "config";

const defaultConfigFileName = "default";

const localConfigFileName = "local";

const envKeyName = "ENV";
const envKeyLowName = "env";

const configYamlSuffixes = <String>[
  ".json",
  ".yaml",
  ".yml",
];

const dotEnvFileSuffix = ".env";

const envMapFileName = "custom_env_variables";

const defaultEnvType = ConfigEnvironmentType.development;
