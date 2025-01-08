<!--
SPDX-FileCopyrightText: 2025 Benoit Rolandeau <borlnov.obsessio@gmail.com>

SPDX-License-Identifier: MIT
-->

# Bro firebase core <!-- omit from toc -->

## Table of contents

- [Table of contents](#table-of-contents)
- [Introduction](#introduction)
- [Quick start](#quick-start)
  - [Install firebase tools](#install-firebase-tools)
  - [Configure the firebase project](#configure-the-firebase-project)

## Introduction

This package imports the [firebase_core](https://pub.dev/packages/firebase_core) package to the
manager system (_see [bro_abstract_manager](https://pub.dev/packages/bro_abstract_manager)_).

## Quick start

### Install firebase tools

This application uses firebase, so you need to install the firebase tools:

- `firebase`
- `flutterfire_cli`

You can follow the doc here:
[install tools](https://firebase.google.com/docs/flutter/setup?hl=fr&platform=android#install-cli-tools).

### Configure the firebase project

After having installed the firebase tools and login to your account, you need to configure the
firebase project.

You have to call the following command:

```bash
flutterfire configure
```
