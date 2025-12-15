# BDUI Challenges - Backend Driven UI Flutter Application

## Overview

BDUI Challenges is a Flutter application that implements the **Backend Driven UI** approach, where the server manages application logic, the template server defines UI structure, and the client focuses on rendering. The application serves as a daily goals tracking system.

## What Problem Does It Solve?

This prototype demonstrates how to build applications where:
- **Main Server controls business logic** while **Template Server defines UI**
- **Client acts as a renderer** that displays server-defined interfaces
- **Dynamic UI updates** without requiring client app updates

## Understanding Backend Driven UI

### How It Works
The backend drives the client interface by:
- Sending JSON schemas (from the **Template Server**) that define screen layout and element appearance
- Specifying where each UI element will be positioned and how it will look
- Separating business logic (**Main Server**) from UI definition (**Template Server**)

### Implementation Approach
- **Client**: Uses `BDUIEngine` to render JSON schemas from the server
- **Server**: Handles business logic and data management
- **Template Server**: Reads UI templates, fills them with data from Server, and renders final JSON for Client

## Installation

### Adding to Your Project

**For Template Server Dependencies:**
```yaml
dependencies:
  client:
    path: bdui_challenge_app/template_server
```

**For Server Dependencies:**
```yaml
dependencies:
  server:
    path: bdui_challenge_app/server
```
  
**For Server Dependencies:**
```yaml
dependencies:
  client:
    path: bdui_challenge_app/client
```

## Quick Start

### Install Dependencies

```bash
# Shared package
cd shared  
dart pub get 

# Template Server
cd template_server 
dart pub get 

# Server
cd server 
dart pub get 

# Client
cd client 
flutter pub get
```

## Generate Code

```bash
# Shared models
cd shared
dart run build_runner build

# Client codegen  
cd client
flutter pub run build_runner build
```

## Run Application

### Start Template Server

```bash
cd template_server
dart run bin/template_server.dart
```

### Start Server

```bash
cd server
dart run bin/server.dart
```

### Start Client
```bash
cd client
flutter run
```

## Features

- **Three-Layer BDUI** - Business logic (Server) → UI definition (Template Server) → Rendering (Client)
- **Clean Architecture** - Testable layers with clear separation of concerns
- **Dependency Injection** - Modular services with GetIt container
- **Template Server** - Dedicated UI schema generation and platform adaptation
- **BLoC State Management** - Predictable state transitions
- **Full-Stack Dart** - Shared models and business logic across client and server
- **Dynamic UI Updates** - Interface changes without app store releases

## Architecture

The project follows Clean Architecture principles with clear separation between data, domain, and presentation layers. Dependency injection is handled through GetIt for modular and testable code composition.

## Development

### Adding New UI Components

1. Define component in shared models
2. Implement renderer in client BDUI engine
3. Add server endpoint for component schema
4. Generate serialization code

## Usage Examples

### Template Server Implementation

```dart
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:template_server/template_server.dart';

void main() async {
    // 💡 Инициализация DI контейнера
    final diContainer = DependencyContainer();

    // Middleware pipeline
    final handler = shelf.Pipeline()
        .addMiddleware(corsHeaders)
        .addMiddleware(logRequests)
        .addHandler(diContainer.appRouter.router);

    // Запуск сервера
    final server = await io.serve(handler, 'localhost', 8082);
}
  ```

### Server Implementation

```dart
import 'dart:io';
import 'package:bdui_server/server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
    // 1. Настраиваем зависимости
    setupDependencies();

    // 2. Получаем роутер из DI контейнера
    final appRouter = getIt.get<AppRouter>();

    // 3. Добавляем middleware
    final handler = Pipeline()
        .addMiddleware(_corsMiddleware)
        .addMiddleware(_logRequests)
        .addHandler(appRouter.router);

    // 4. Запускаем сервер
    final _ = await io.serve(handler, InternetAddress.anyIPv4, 8080);
}

// CORS middleware
Middleware get _corsMiddleware {
  return (Handler innerHandler) {
    return (Request request) async {
      // Обрабатываем OPTIONS
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
          'Access-Control-Max-Age': '86400',
        });
      }

      final response = await innerHandler(request);
      return response.change(headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
      });
    };
  };
}

// Logging middleware
Middleware get _logRequests {
  return (Handler handler) {
    return (Request request) async {
      final startTime = DateTime.now();
      final response = await handler(request);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      print(
          '${request.method} ${request.requestedUri} - ${response.statusCode} (${duration.inMilliseconds}ms)');
      return response;
    };
  };
}
  ```

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
    );
    }
  }
  ```