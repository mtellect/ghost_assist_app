part of base_api;

typedef UploadProgressCallback = void Function(String fileName, double progress);

extension ApiFunctionsV2 on ApiClient {
  Future<Response> postApi({
    required String url,
    var body,
    Map<String, String>? headers,
    bool useApiHeader = true,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.post(
      url,
      options: Options(headers: headers ?? {}),
      data: body ?? '{}',
      cancelToken: cancelToken,
      queryParameters: queryParameters,
    );
  }

  Future<Response> putApi({
    required String url,
    var body,
    Map<String, String>? headers,
    bool useApiHeader = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.put(
      url,
      options: Options(headers: headers ?? {}),
      data: body,
      queryParameters: queryParameters,
    );
  }

  Future<Response> patchApi({
    required String url,
    var body,
    Map<String, String>? headers,
    bool useApiHeader = true,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.patch(
      url,
      options: Options(headers: headers ?? {}),
      data: body,
      queryParameters: queryParameters,
    );
  }

  Future<Response> getApi({
    required String url,
    Map<String, String>? headers,
    bool useApiHeader = true,
    var body,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    bool isAbsoluteUrl = false,
  }) async {
    return _dio.get(
      url,
      options: Options(
        headers: headers ?? {},
        extra: {'isAbsoluteUrl': isAbsoluteUrl},
      ),
      data: body,
      cancelToken: cancelToken,
      queryParameters: queryParameters,
    );
  }

  Future<Response> deleteApi({
    required String url,
    var body,
    Map<String, String>? headers,
  }) async {
    return _dio.delete(
      url,
      options: Options(headers: headers ?? {}),
      data: body,
    );
  }

  Future<Response> downloadApi({
    required String url,
    required String filePath,
    ProgressCallback? onReceiveProgress,
    var body,
    Map<String, String>? headers,
  }) {
    return _dio.download(
      url,
      filePath,
      onReceiveProgress: onReceiveProgress,
      options: Options(headers: headers ?? {}),
      data: body,
    );
  }

  Future<Response> postMultiPartApi({
    required String url,
    required File image,
    dynamic body,
    Map<String, String>? headers,
    bool useApiHeader = true,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(image.path),
      // Add additional fields if needed
    });

    return _dio.post(
      url,
      data: formData,
      options: Options(
        headers: headers,
      ),
    );
  }

  Future<Response> postMultiPartApi3({
    required String url,
    Map<String, String>? headers,
    bool useApiHeader = true,
    Map<String, String>? formDataFields,
    required String imageKey,
    required File file,
    UploadProgressCallback? onProgress,
  }) async {
    Map<String, String>? rootHeaders = {};

    if (headers != null) rootHeaders.addAll(headers);

    final fileName = file.path.split('/').last;
    final formData = FormData();

    if (null != formDataFields) {
      formDataFields.forEach((key, value) {
        formData.fields.add(
          MapEntry(
            key,
            value,
          ),
        );
      });
    }

    formData.files.add(
      MapEntry(
        imageKey,
        await MultipartFile.fromFile(file.path),
      ),
    );

    log("formData-sent ${formData.files.map((e) => e.key)}");
    return _dio.post(
      url,
      data: formData,
      onSendProgress: (count, total) {
        final progress = count / total;

        if (null != onProgress) {
          onProgress(fileName, progress);
        }
      },
    );
  }

  Future<Response> postMultiPartListApi({
    required String url,
    Map<String, String>? headers,
    bool useApiHeader = true,
    Map<String, String>? formDataFields,
    required List<MapEntry<String, MultipartFile>> files,
    UploadProgressCallback? onProgress,
  }) async {
    Map<String, String>? rootHeaders = {};

    if (headers != null) rootHeaders.addAll(headers);

    final formData = FormData.fromMap(formDataFields ?? {});

    // if (null != formDataFields) {
    //   formDataFields.forEach((key, value) {
    //     formData.fields.add(
    //       MapEntry(
    //         key,
    //         value,
    //       ),
    //     );
    //   });
    // }

    formData.files.addAll(files);

    log("formData-sent-files ${formData.files.map((e) => e.key)}");
    return _dio.post(
      url,
      data: formData,
      onSendProgress: (count, total) {
        final progress = count / total;
        // logic for progress if needed, simplistic for now
        if (null != onProgress) {
          onProgress("multiple_files", progress);
        }
      },
      options: Options(
        headers: headers,
      ),
    );
  }

  Future<Response> putMultiPartListApi({
    required String url,
    Map<String, String>? headers,
    bool useApiHeader = true,
    Map<String, String>? formDataFields,
    required List<MapEntry<String, MultipartFile>> files,
    UploadProgressCallback? onProgress,
  }) async {
    Map<String, String>? rootHeaders = {};

    if (headers != null) rootHeaders.addAll(headers);

    final formData = FormData.fromMap(formDataFields ?? {});

    formData.files.addAll(files);

    return _dio.put(
      url,
      data: formData,
      onSendProgress: (count, total) {
        final progress = count / total;
        // logic for progress if needed, simplistic for now
        if (null != onProgress) {
          onProgress("multiple_files", progress);
        }
      },
      options: Options(
        headers: headers,
      ),
    );
  }
}

class AppVersionCheck {
  static String appVersion = "";
  static String deviceType = "";
  static String deviceId = "";
  static String? appsFlyerId;
  static String get traceId => const Uuid().v4().toString();
  static String spanId = "";
  static String deviceSessionId = "";
  static String appType = "";
}
