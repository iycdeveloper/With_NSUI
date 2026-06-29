import 'dart:convert';
import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/di_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart'; // Corrected import for MediaType

class AwsUploadServices {
  late String accessKey;
  late String secretKey;
  String? bucket;
  String region = "ap-south-1";

  Future<String?> uploadFile({
    required File file,
    required String destDir,
    String? filename,
  }) async {
    bucket = sl<SharedPreferences>().getString("s3_bucket");
    secretKey = sl<SharedPreferences>().getString("s3_secret_key")!;
    accessKey = sl<SharedPreferences>().getString("s3_access_token")!;
    Log.printDLog(' AWS server Directory:'+destDir);

    Log.printDLog('Uploading photo to AWS server');

    if (bucket == null || secretKey == null || accessKey == null) {
      Log.printELog('AWS S3 credentials or bucket are missing');
      return null;
    }

    final endpoint = 'https://$bucket.s3.$region.amazonaws.com';
    final uploadDest = '$destDir/$filename';
        Log.printDLog(' AWS server uploadDest Directory:'+uploadDest);

    final stream = http.ByteStream(Stream.castFrom(file.openRead()));
    final length = await file.length();
    final uri = Uri.parse(endpoint);

    final req = http.MultipartRequest("POST", uri);

    final multipartFile = http.MultipartFile('file', stream, length,
        filename: filename,
        contentType: filename?.split(".").last == "jpg"
            ? MediaType("image", "jpeg")
            : MediaType("audio", "mpeg"));
    Log.printDLog('token: ${accessKey}');

    final policy = Policy.fromS3PresignedPost(
        uploadDest, bucket!, accessKey, 15, length,
        region: region);
    final key = SigV4.calculateSigningKey(secretKey, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = uploadDest; // Corrected to use uploadDest instead of policy.key
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    Log.printDLog('Policy: ${policy.encode()}');
    Log.printDLog('Signature: $signature');
    Log.printDLog('Request Fields: ${req.fields}');

    try {
      final res = await req.send();
      final resStr = await res.stream.bytesToString();
      Log.printDLog('Response status: ${res.statusCode}');
      Log.printDLog('Response body: $resStr');

      if (res.statusCode == 204) {
        Log.printDLog("File uploaded successfully: $endpoint/$uploadDest");
        return '$endpoint/$uploadDest';
      } else {
        Log.printELog('Failed to upload to AWS, with error code: ${res.statusCode}');
      }
    } catch (e) {
      Log.printELog('Failed to upload to AWS, with exception: $e');
    }
    return null;
  }
}

class Policy {
  String expiration;
  String region;
  String bucket;
  String key;
  String credential;
  String datetime;
  int maxFileSize;

  Policy(this.key, this.bucket, this.datetime, this.expiration, this.credential,
      this.maxFileSize,
      {this.region = 'us-east-1'});

  factory Policy.fromS3PresignedPost(
      String key,
      String bucket,
      String accessKeyId,
      int expiryMinutes,
      int maxFileSize, {
        String region = 'us-east-1',
      }) {
    final datetime = SigV4.generateDatetime();
    final expiration = (DateTime.now())
        .add(Duration(minutes: expiryMinutes))
        .toUtc()
        .toString()
        .split(' ')
        .join('T');
    final cred =
        '$accessKeyId/${SigV4.buildCredentialScope(datetime, region, 's3')}';

    return Policy(key, bucket, datetime, expiration, cred, maxFileSize,
        region: region);
  }

  String encode() {
    final bytes = utf8.encode(toString());
    return base64.encode(bytes);
  }

  @override
  String toString() {
    return '''
{ "expiration": "${this.expiration}",
  "conditions": [
    {"bucket": "${this.bucket}"},
    ["starts-with", "\$key", "${this.key}"],
    ["content-length-range", 1, ${this.maxFileSize}],
    {"x-amz-credential": "${this.credential}"},
    {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
    {"x-amz-date": "${this.datetime}" }
  ]
}
''';
  }
}
