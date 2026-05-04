// API Library

import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:ghost_assist_app/core/enums/api_environment_enum.dart';
import 'package:ghost_assist_app/core/utils/logger.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:uuid/uuid.dart';

// Parts
part 'api_client.dart';
part 'api_urls.dart';
part 'api_functions.dart';
part 'api_response.dart';
part 'env_configurations_model.dart';

// Interceptors
part 'interceptors/authentication_interceptor.dart';
part 'interceptors/headers_interceptor.dart';
part 'interceptors/connectivity_interceptor.dart';
part 'interceptors/error_interceptor.dart';
part 'interceptors/body_interceptor.dart';

// Exceptions
part 'exception/api_error_exception.dart';
part 'exception/unsuccessful_api_status_exception.dart';
part 'exception/api_cancelled_exception.dart';
part 'exception/no_content_exception.dart';
