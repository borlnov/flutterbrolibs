<!--
SPDX-FileCopyrightText: 2024 Benoit Rolandeau <borlnov.obsessio@gmail.com>

SPDX-License-Identifier: MIT
-->

# Bro abstract manager <!-- omit from toc -->

## Table of contents

- [Table of contents](#table-of-contents)
- [Introduction](#introduction)

## Introduction

This contains abstract classes for all the managers.

Managers are singletons that manage a specific part of the application. They are used to separate
the logic from the UI and to have a single point of access to the data.

Managers are used to manage the data, the configuration, the services, the network, etc.

Each manager is an unique instance that is accessible from anywhere in the application.

The abstract classes are used to define the interface of the manager. The concrete classes must
implement the abstract classes.
