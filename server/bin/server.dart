import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

const int port = 8080;
const String imageDirectory = 'server/data/images';
const String dataFile = 'server/data/db.json';

void main(List<String> args) async {
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
    if (!request.mimeType!.startsWith('multipart/form-data')) {
      return Response.forbidden('Invalid content type');
    }

    final boundary = request.mimeType!.split('boundary=')[1];
    final transformer = MimeMultipartTransformer(boundary);
    final bodyStream = request.read().transform(transformer);

    try {
      await for (final part in bodyStream) {
        final contentDisposition = part.headers['content-disposition'];
        if (contentDisposition != null &&
            contentDisposition.contains('filename=')) {
          final filename = RegExp(
            r'filename="([^"]*)"',
          ).firstMatch(contentDisposition)?.group(1);

          if (filename != null) {
            final uniqueFilename =
                '${DateTime.now().millisecondsSinceEpoch}_$filename';
            final file = File(path.join(imageDirectory, uniqueFilename));
            final sink = file.openWrite();
            await part.pipe(sink);
            await sink.close();

            final imageUrl = 'http://localhost:$port/images/$uniqueFilename';
            return Response.ok(imageUrl);
          }
        }
      }
    } catch (e) {
      print('Upload Error: $e');
      return Response.internalServerError(body: 'Upload failed: $e');
    }

    return Response.badRequest(body: 'No file uploaded');
  });

  // Get Data
  app.get('/api/data', (Request request) async {
    final content = await dataFileObj.readAsString();
    return Response.ok(content, headers: {'content-type': 'application/json'});
  });

  // Update Data
  app.post('/api/data', (Request request) async {
    final payload = await request.readAsString();
    try {
      // Validate JSON
      jsonDecode(payload);
      await dataFileObj.writeAsString(payload);
      return Response.ok('Data saved');
    } catch (e) {
      return Response.badRequest(body: 'Invalid JSON');
    }
  });

  // CORS Middleware
  final handler = const Pipeline()
      .addMiddleware((innerHandler) {
        return (request) async {
          if (request.method == 'OPTIONS') {
            return Response.ok(
              '',
              headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods':
                    'GET, POST, PUT, DELETE, OPTIONS',
                'Access-Control-Allow-Headers':
                    'Origin, Content-Type, X-Auth-Token',
              },
            );
          }
          final response = await innerHandler(request);
          return response.change(
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers':
                  'Origin, Content-Type, X-Auth-Token',
            },
          );
        };
      })
      .addHandler(app);

  final server = await io.serve(handler, 'localhost', port);
  print('Server running on http://${server.address.host}:${server.port}');
}
