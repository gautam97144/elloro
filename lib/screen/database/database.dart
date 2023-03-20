import 'dart:convert';
import 'dart:io';
import 'package:elloro/model/MusicDataModel.dart';
import 'package:elloro/model/token_model.dart';
import 'package:elloro/model/user_register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  DatabaseHelper._PrivateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._PrivateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ?? await initDatabase();

  Future<Database> initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, "MusicDataBase.db");

    return await openDatabase(path, version: 1, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE MusicDataBase(
    id INTEGER PRIMARY KEY,
    musicTitle TEXT,
    musicSubtitle TEXT,
    musicDuration TEXT,
    creatorName TEXT,
    creatorAbout TEXT,
    path TEXT,
    description TEXT,
    catalogId INTEGER,
    image TEXT,
    userId INTEGER,
    musicFileSize TEXT,
    userProfile TEXT,
    token INTEGER,
    isDelete INTEGER,
    isFavourite INTEGER
    )''');
    await db.execute('''
    CREATE TABLE TokenTable(
    id INTEGER PRIMARY KEY,
    token INTEGER,
    profileImage TEXT
    )
   ''');
  }

  Future<List<Music>> getMusicData() async {
    UserRegisterModel? user;

    SharedPreferences preferences = await SharedPreferences.getInstance();

    user = UserRegisterModel.fromJson(
        jsonDecode(preferences.getString('user') ?? ""));

    // print(user.name);

    Database db = await instance.database;

    var music = await db
        .query("MusicDataBase", where: 'userId = ?', whereArgs: [user.userId]);

    List<Music> musicList =
        music.isNotEmpty ? music.map((e) => Music.fromJson(e)).toList() : [];

    return musicList;
  }

  Future<int> addFavourite(Music music) async {
    Database db = await instance.database;
    return await db.insert(
      "MusicDataBase",
      music.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Music>> getFavourite() async {
    Database db = await instance.database;

    var music = await db.query(
      "MusicDataBase",
    );

    List<Music> musicList =
        music.isNotEmpty ? music.map((e) => Music.fromJson(e)).toList() : [];
    return musicList;
  }

  Future<int> addMusicData(Music music) async {
    Database db = await instance.database;

    return await db.insert(
      "MusicDataBase",
      music.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeData(int id) async {
    Database db = await instance.database;
    return db.delete("MusicDataBase", where: 'catalogId = ?', whereArgs: [id]);
  }

  Future deleteData() async {
    Database db = await instance.database;
    return db.delete("MusicDataBase");
  }

  Future<List<TokenModel>> getTokenData() async {
    Database db = await instance.database;
    var tokenData = await db.query("TokenTable");

    List<TokenModel> token = tokenData.isNotEmpty
        ? tokenData.map((e) => TokenModel.fromJson(e)).toList()
        : [];

    return token;
  }

  Future addTokenData(TokenModel tokenModel) async {
    Database tokenData = await instance.database;
    return await tokenData.insert("TokenTable", tokenModel.toJson());
  }

  Future<int> updateData(TokenModel tokenModel) async {
    Database db = await instance.database;
    return db.update("TokenTable", tokenModel.toJson(),
        where: 'id=?', whereArgs: [tokenModel.id]);
  }

  Future updateFavourite(Music music) async {
    Database db = await instance.database;
    return db.update("MusicDataBase", music.toJson(),
        where: "catalogId = ?", whereArgs: [music.catalogId]);
  }
}
