import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Database _db;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Inicializa GoogleSignIn
    scopes: [drive.DriveApi.driveFileScope], // Permisos de Drive
  );
  GoogleAuthClient? _authClient;

  @override
  void initState() {
    super.initState();
    _initializeDatabase(); // Llama a la función, no solo la defines
  }

  Future<void> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = path.join(databasesPath, 'control_flow.db'); // Importa path
    _db = await openDatabase(dbPath);
  }

  Future<void> _backupToDrive() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Authentication failed. Please sign in')),
        );
        return;
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.accessToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Authentication failed. Please sign in')),
        );
        return;
      }

      final accessToken = googleAuth.accessToken!;
      _authClient = GoogleAuthClient(accessToken);
      if (_authClient == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error: No se pudo autenticar con Google')),
        );
        return;
      }
      final driveApi = drive.DriveApi(_authClient!);

      final databasesPath = await getDatabasesPath();
      final dbPath = path.join(databasesPath, 'control_flow.db');
      final dbFile = File(dbPath);

      final tempDir = await getTemporaryDirectory();
      final backupFile = File('${tempDir.path}/backup_control_flow.db');
      await dbFile.copy(backupFile.path);

      final media = drive.Media(backupFile.openRead(), backupFile.lengthSync());
      final file = drive.File();
      file.name = 'backup_control_flow.db';
      await driveApi.files.create(file, uploadMedia: media);
      await backupFile.delete();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Backup complete!')));
    } catch (e) {
      print('Error en el backup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el backup: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.person, size: 50),
          ),
          const SizedBox(height: 20),
          const Text(
            'Laura Barroso',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          const Text(
            'laurabarroso@gmail.com',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            // Botón para el backup
            onPressed: _backupToDrive,
            child: const Text('Backup a Google Drive'),
          ),
        ],
      ),
    );
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(String accessToken)
      : _headers = {
          'Authorization': 'Bearer $accessToken',
        };

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
