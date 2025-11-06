# BDUI Challenges - Backend Driven UI Flutter Application

## Overview

BDUI Challenges is a Flutter application that implements the **Backend Driven UI** approach, where the server manages application logic and UI structure, while the client focuses on rendering. The application serves as a daily goals tracking system.

## What Problem Does It Solve?

This prototype demonstrates how to build applications where:
- **Server controls both logic and UI** of the application
- **Client acts as a renderer** that displays server-defined interfaces
- **Dynamic UI updates** without requiring client app updates

## Understanding Backend Driven UI

### How It Works
The backend drives the client interface by:
- Sending JSON schemas that define screen layout and element appearance
- Specifying where each UI element will be positioned and how it will look
- Controlling the complete UI structure and business logic

### Implementation Approach
- **Client**: Uses `BDUIEngine` to render JSON schemas from the server
- **Server**: Handles business logic and defines UI pages and components

## Installation

### Adding to Your Project

**For Server Dependencies:**
```yaml
dependencies:
  server:
    path: bdui_challenge_app/server
  
**For Server Dependencies:**
dependencies:
  client:
    path: bdui_challenge_app/client

## Quick Start

### Install Dependencies

```bash
# Shared package
cd shared  
dart pub get 

# Server
cd server 
dart pub get 

# Client
cd client 
flutter pub get

## Generate Code

```bash
# Shared models
cd shared
dart run build_runner build

# Client codegen  
cd client
flutter pub run build_runner build

## Run Application

### Start Server

```bash
cd server
dart run bin/server.dart

### Start Client

cd client
flutter run

## Features

- **Backend Driven UI** - Server defines UI structure via JSON schemas
- **Clean Architecture** - Separation of concerns with testable layers
- **Dependency Injection** - Modular service composition with GetIt
- **BLoC State Management** - Predictable state transitions
- **Full-Stack Dart** - Shared models across client and server

## Architecture

The project follows Clean Architecture principles with clear separation between data, domain, and presentation layers. Dependency injection is handled through GetIt for modular and testable code composition.

## Development

### Adding New UI Components

1. Define component in shared models
2. Implement renderer in client BDUI engine
3. Add server endpoint for component schema
4. Generate serialization code

## Usage Examples

### Server Implementation

```dart
import 'package:bdui_server/server.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  // Create server with all dependencies
  final server = BDUIServer();
  
  // Start server on localhost:8080
  await server.start(host: 'localhost', port: 8080);
  
  print(' BDUI Server running on http://localhost:8080')}

## Client Implementation

```dart
import 'package:client/client.dart';
import 'package:flutter/material.dart';

void main() {
  // Setup dependency injection
  setUpDependencies();
  
  runApp(const BDUIApp());}

class BDUIApp extends StatelessWidget {
  const BDUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Challenges - BDUI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BDUIHomeScreen(),
    );}}