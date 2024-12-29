<!--
SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>

SPDX-License-Identifier: MIT
-->

# Bro config manager <!-- omit from toc -->

## Table of contents

- [Table of contents](#table-of-contents)
- [Introduction](#introduction)
- [Usage](#usage)
  - [Presentation](#presentation)
  - [Config folder structure](#config-folder-structure)
  - [Config file content](#config-file-content)
  - [Override the config files with environment variables](#override-the-config-files-with-environment-variables)
  - [Use environment variables](#use-environment-variables)
    - [Presentation](#presentation-1)
    - [Platform specific environment variables](#platform-specific-environment-variables)
    - [Dot env files](#dot-env-files)
    - [Build environment variables](#build-environment-variables)
  - [Summary](#summary)

## Introduction

This package contains the abstract class for the config manager. The config manager can be used by
all the other manager but also other classes to read app configs from specific files.

This package is inspired from the [node config package](https://www.npmjs.com/package/config).

## Usage

### Presentation

The config manager used configs files aware of the environment used to build the app: `dev`,
`staging` or `prod`. To do so, when you build the app you need to specify the environment you want
to use. This can be done by using the `--dart-define` option when building the app.

The environment value to use is `APP_ENV` and the values must be `dev`, `staging` or `prod`
(`development` and `production` are also usable).

The config manager will look for the config files in the `assets/configs` directory. The directory
has to be added as an asset in the `pubspec.yaml` file.
The config folder path can be changed by using the `configFolderPath` parameter of the constructor.

### Config folder structure

The config manager will look for the config files in the `assets/configs` directory. The config
files have to be json or yaml files (the file extension can be `.json`, `.yaml` or `.yml`). The
config manager will parse the files in this order:

1. `default.{json|yaml|yml}`: this file contains the default values for all the configs and which
   doesn't depend on the environment.
2. `{environment}.{json|yaml|yml}`: this file contains the values that depend on the environment.
   The environment is the one specified by the `APP_ENV` variable.
   **BE CAREFUL: the name of the file can only be: `development`, `staging` or `production`.**
3. `local.{json|yaml|yml}`: this file contains the values that are specific to the local
   environment. **The file is local to the device and is not meant to be committed to the repo.**

If one of those files doesn't exist, the config manager won't throw an error. It will just use the
values from the other files. The config manager only throws an error if variable is expected but its
value is not found in any of the files.

### Config file content

The structure of the config file is a `Map<String, dynamic>` where the keys are the variable names.
You can create a hierarchy in the config file to make it more readable.

Avoid to use `.` in the variable names as it can make the parsing fails.

The variable values can be any of a yaml values. Here is an example of a config file:

```yaml
# This is a main category to store the config variables linked to the logger
logger:
    # This is the global level of the logger, it can be accessed with the following path:
    # `logger.globalLevel`
    globalLevel: debug

    # This contains the settings for the console logger
    console:
        # This is the level of the console logger, it can be accessed with the following path:
        # `logger.console.level`
        level: debug

        # If true, this will enable the console logger
        enabled: true

    # This contains the settings for the file logger
    file:
        # This is the level of the file logger, it can be accessed with the following path:
        # `logger.file.level`
        level: debug

        # If true, this will enable the file logger
        enabled: true
```

### Override the config files with environment variables

You can override the values of the config files by using environment variables.

To do so, you need to create a mapping file that will map the environment variables to the config
variables. The mapping file has to be a json or yaml file and has to be named
`env_mapping.{json|yaml|yml}`.

The structure of the mapping file is the same as the config file. The only difference is that the
values are the environment variables names.

If you want to parse non string values, you can precise the type of the value by using the following
syntax:

```yaml
key:
    __name: ENV_VAR_NAME
    __type: int
```

Here is an example of a mapping file:

```yaml
# This is a main category to store the config variables linked to the logger
logger:
    # This is the global level of the logger, it can be accessed with the following path:
    # `logger.globalLevel`
    globalLevel: LOGGER_GLOBAL_LEVEL

    # This contains the settings for the console logger
    console:
        # This is the level of the console logger, it can be accessed with the following path:
        # `logger.console.level`
        level: LOGGER_CONSOLE_LEVEL

        # If true, this will enable the console logger
        enabled:
            __name: LOGGER_CONSOLE_ENABLED
            __type: bool

    # This contains the settings for the file logger
    file:
        # This is the level of the file logger, it can be accessed with the following path:
        # `logger.file.level`
        level: LOGGER_FILE_LEVEL

        # If true, this will enable the file logger
        enabled:
            __name: LOGGER_FILE_ENABLED
            __type: bool
```

The supported types are:

- `int`,
- `double`,
- `bool`,
- `string`,
- `object` (this will parse the value as a json object),
- `array` (this will parse the value as a json array).

### Use environment variables

#### Presentation

To use the environment variables, you need to add the mapping file in the `assets/configs`
directory.

#### Platform specific environment variables

First, the app will try to find the values of the environment variables in the platform specific
variables.

#### Dot env files

Then you can use `.env` files to set the environment variables. The `.env` files have to be named
`{environment}.env` where `{environment}` is the environment you want to use.

We don't recommend to commit the `.env` files to the repo as they can contain sensitive data.

This library uses the [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) package to parse the
`.env` files.

The config manager will parse the env files in this order:

1. `.env`: this file contains user values for all the environment variables.
2. `default.env`: this file contains the default values for all the environment variables.
3. `{environment}.env`: this file contains the values that depend on the environment.
4. `local.env`: this file contains the values that are specific to the local environment.

#### Build environment variables

You can also set the environment variables directly in the build command by using the
`--dart-define` option.

Those values will override the values from the `.env` files.

Be careful, the values set in the build command can only be got at runtime if they are acceeded with
constant key.

### Summary

To summarize, the config manager will look for the values in this order:

1. `default.{json|yaml|yml}`: default values for all the configs.
2. `{environment}.{json|yaml|yml}`: values that depend on the environment.
3. `local.{json|yaml|yml}`: values that are specific to the local environment.
4. Platform specific environment variables.
5. `.env` files.
    1. `.env`: user values for all the environment variables.
    2. `default.env`: default values for all the environment variables.
    3. `{environment}.env`: values that depend on the environment.
    4. `local.env`: values that are specific to the local environment.
6. Build environment variables.
