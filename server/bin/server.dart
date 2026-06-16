import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

const int port = 8080;
const int maxImageDimension = 2048; // WebGL safe limit

void main(List<String> args) async {
  // Get absolute paths based on script location
  final scriptDir = File(Platform.script.toFilePath()).parent.parent.path;
  final imageDirectory = path.join(scriptDir, 'data', 'images');
  final dataFile = path.join(scriptDir, 'data', 'db.json');

  print('Script directory: $scriptDir');
  print('Image directory: $imageDirectory');
  print('Data file: $dataFile');

  // Ensure directories exist
  final imageDir = Directory(imageDirectory);
  if (!await imageDir.exists()) {
    await imageDir.create(recursive: true);
  }

  final dataFileObj = File(dataFile);
  if (!await dataFileObj.exists()) {
    await dataFileObj.create(recursive: true);
    await dataFileObj.writeAsString(
      jsonEncode({
        'projects': [],
        'profile': null,
        'experience': [],
        'education': [],
        'skills': [],
      }),
    );
  }

  final app = Router();

  // Root - Server Status
  app.get('/', (Request request) {
    return Response.ok(
      'Portfolio Server is Acting Correctly! 🚀\n\n- API: /api/data\n- Images: /images/',
    );
  });

  // Serve Images
  app.mount('/images/', createStaticHandler(imageDirectory));

  // Upload Image
  app.post('/upload', (Request request) async {
    print('Upload request received');
    print('Origin: ${request.headers['origin']}');
    print('Content-Type: ${request.mimeType}');

    if (request.mimeType == null || !request.mimeType!.startsWith('multipart/form-data')) {
      print('Invalid content type: ${request.mimeType}');
      return Response.forbidden('Invalid content type');
    }

    // Extract boundary from Content-Type header
    final contentType = request.headers['content-type'];
    print('Full Content-Type: $contentType');

    if (contentType == null || !contentType.contains('boundary=')) {
      print('No boundary found in Content-Type');
      return Response.badRequest(body: 'Invalid multipart/form-data: no boundary');
    }

    final boundaryMatch = RegExp(r'boundary=([^;]+)').firstMatch(contentType);
    if (boundaryMatch == null) {
      print('Could not parse boundary from Content-Type');
      return Response.badRequest(body: 'Invalid multipart/form-data: invalid boundary format');
    }

    final boundary = boundaryMatch.group(1)!.trim();
    print('Extracted boundary: $boundary');

    // Use MimeMultipartTransformer correctly
    final transformer = MimeMultipartTransformer(boundary);
    final parts = transformer.bind(request.read());

    try {
      await for (final part in parts) {
        final contentDisposition = part.headers['content-disposition'];
        print('Processing part with content-disposition: $contentDisposition');

        if (contentDisposition != null &&
            contentDisposition.contains('filename=')) {
          final filename = RegExp(
            r'filename="([^"]*)"',
          ).firstMatch(contentDisposition)?.group(1);

          if (filename != null) {
            final uniqueFilename =
                '${DateTime.now().millisecondsSinceEpoch}_$filename';
            final file = File(path.join(imageDirectory, uniqueFilename));

            print('Processing file: $filename');

            // Read the image bytes
            final imageBytes = await part.toList();
            final bytes = Uint8List.fromList(
              imageBytes.expand((chunk) => chunk).toList(),
            );

            print('Original image size: ${bytes.length} bytes');

            // Decode and resize the image
            final image = img.decodeImage(bytes);
            if (image == null) {
              print('Failed to decode image');
              return Response.badRequest(body: 'Invalid image format');
            }

            print('Original dimensions: ${image.width}x${image.height}');

            // Save original image without any resizing
            // Using HTML rendering in Flutter Web bypasses WebGL texture limits
            print('✓ Saving original quality (HTML renderer will handle display)');
            await file.writeAsBytes(bytes);

            final fileSize = await file.length();
            print('File saved successfully: $uniqueFilename (${fileSize} bytes)');

            final imageUrl = 'http://localhost:$port/images/$uniqueFilename';
            print('Returning image URL: $imageUrl');
            return Response.ok(imageUrl);
          }
        }
      }
    } catch (e, stackTrace) {
      print('Upload Error: $e');
      print('Stack trace: $stackTrace');
      return Response.internalServerError(body: 'Upload failed: $e');
    }

    print('No file found in request');
    return Response.badRequest(body: 'No file uploaded');
  });

  // Get Data
  app.get('/api/data', (Request request) async {
    final content = await dataFileObj.readAsString();
    return Response.ok(content, headers: {'content-type': 'application/json'});
  });

  // Update Data
  app.post('/api/data', (Request request) async {
    print('Data save request received');
    final payload = await request.readAsString();
    print('Payload length: ${payload.length} bytes');

    try {
      // Validate JSON
      final jsonData = jsonDecode(payload);
      print('JSON validated successfully');

      // Pretty print for better debugging
      final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);
      await dataFileObj.writeAsString(prettyJson);

      final fileSize = await dataFileObj.length();
      print('Data saved successfully: ${fileSize} bytes');

      return Response.ok('Data saved');
    } catch (e, stackTrace) {
      print('Error saving data: $e');
      print('Stack trace: $stackTrace');
      return Response.badRequest(body: 'Invalid JSON: $e');
    }
  });

  // CORS Middleware
  final handler = const Pipeline()
      .addMiddleware((innerHandler) {
        return (request) async {
          print('Request: ${request.method} ${request.url}');
          print('Origin: ${request.headers['origin']}');

          // CORS headers for all responses
          final corsHeaders = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers': '*',
            'Access-Control-Expose-Headers': '*',
            'Access-Control-Max-Age': '86400',
          };

          if (request.method == 'OPTIONS') {
            print('Handling OPTIONS preflight request');
            return Response.ok('', headers: corsHeaders);
          }

          try {
            final response = await innerHandler(request);
            print('Response status: ${response.statusCode}');
            return response.change(headers: corsHeaders);
          } catch (e, stackTrace) {
            print('Error handling request: $e');
            print('Stack trace: $stackTrace');
            return Response.internalServerError(
              body: 'Internal server error: $e',
              headers: corsHeaders,
            );
          }
        };
      })
      .addHandler(app);

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print('Server running on http://${server.address.host}:${server.port}');
}
