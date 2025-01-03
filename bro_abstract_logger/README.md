<!--
SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>

SPDX-License-Identifier: MIT
-->

# Bro abstract logger <!-- omit from toc -->

## Table of contents

- [Table of contents](#table-of-contents)
- [Introduction](#introduction)
- [Usage](#usage)

## Introduction

This package contains abstract classes for all the loggers. It doesn't contain any implementation of
the loggers. It's just a way to have a common interface for all the loggers.

## Usage

This package is not meant to be used directly. It's meant to be used by other packages that need to
implement a logger.

If you want to implement a logger, you should create a new package that depends on this package and
implements the abstract classes.

If you want to log to multiple loggers at the time, you can use the `AbstractMultiLogger` class.
This class will log to all the loggers that you add to it and allows you to only have one main
logger manager in your app.

