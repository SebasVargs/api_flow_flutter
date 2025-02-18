import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:googleapis_auth/auth_io.dart';
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

  const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/drive.file',
  ];

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );
class _ProfileScreenState extends State<ProfileScreen> {
  late Database _db;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Inicializa GoogleSignIn
    scopes: [drive.DriveApi.driveFileScope], // Permisos de Drive
  );
  GoogleAuthClient? _authClient;
  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;
  final baseClient = http.Client();

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) async {
      setState(() {
        _currentUser = account;
      });
      if(account != null) {
        await _initializeDriveApi();
      }
    });
    _googleSignIn.signInSilently();
    _initializeDatabase(); 
  }

  Future<void> _initializeDriveApi() async {
    final googleUser = await _googleSignIn.signIn();
    if(googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    if(accessToken == null) return;

    final authClient = authenticatedClient(
      baseClient,
      AccessCredentials(
        AccessToken('Bearer', accessToken, DateTime.now().toUtc()),
        null,
        scopes,
      )
    );

    setState(() {
      _driveApi = drive.DriveApi(authClient);
    });
  }

  Future<void> _initializeDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = path.join(databasesPath, 'control_flow.db'); // Importa path
    _db = await openDatabase(dbPath);
  }

  Future<void> _backupToDrive() async {
    if(_driveApi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo autentica con Google Drive')),
      );
      return;
    }

    try {
      final databasesPath = await getDatabasesPath();
      final dbPath = path.join(databasesPath, 'control_flow.db');
      final dbFile = File(dbPath);
      if (!await dbFile.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se encontro la base de datos')),
        );
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final backupFile = File('${tempDir.path}/backup_control_flow.db');
      await dbFile.copy(backupFile.path);

      final media = drive.Media(backupFile.openRead(), backupFile.lengthSync());
      final fileMetada = drive.File()..name = 'backup_control_flow.db';

      await _driveApi!.files.create(fileMetada, uploadMedia: media);
      await backupFile.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Backup completado con éxito en Google Drive')),
      );
    } catch (e) {
      print('Error en el backup $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al hacer backup en Google Drive'))
      );
    }
  }

  Future<void> _signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (err) {
      print('Error al iniciar sesion: $err');
    }
  }

  Future<void> _signOut() async {
    await _googleSignIn.signIn();
    setState(() {
      _currentUser = null;
      _driveApi = null;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Google Drive Backup'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _currentUser?.photoUrl != null
                ? NetworkImage(_currentUser!.photoUrl!)
                : null,
            child: _currentUser?.photoUrl == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          const SizedBox(height: 20),
          Text(
            _currentUser?.displayName ?? 'Nombre no disponible',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            _currentUser?.email ?? 'Correo no disponible',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _currentUser == null ? _signIn : _signOut,
            child: Text(_currentUser == null ? 'Iniciar Sesión con Google' : 'Cerrar Sesión'),
          ),
        ],
      ),
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
