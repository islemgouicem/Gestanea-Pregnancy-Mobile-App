import 'package:gestanea/core/database/models/doctor_model.dart';
import 'package:gestanea/core/database/db_helper.dart';

class DoctorsLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Get all doctors
  Future<List<DoctorModel>> getDoctors() async {
    final db = await _dbHelper.database;
    final result = await db.query('doctors', orderBy: 'name ASC');
    return result.map((map) => DoctorModel.fromMap(map)).toList();
  }

  /// Get doctors by specialty
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'doctors',
      where: 'specialty = ?',
      whereArgs: [specialty],
      orderBy: 'name ASC',
    );
    return result.map((map) => DoctorModel.fromMap(map)).toList();
  }

  /// Get doctors by gender
  Future<List<DoctorModel>> getDoctorsByGender(String gender) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'doctors',
      where: 'gender = ?',
      whereArgs: [gender],
      orderBy: 'name ASC',
    );
    return result.map((map) => DoctorModel.fromMap(map)).toList();
  }

  /// Get favorite doctors
  Future<List<DoctorModel>> getFavoriteDoctors() async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'doctors',
      where: 'isfavorite = ?',
      whereArgs: [1],
      orderBy: 'name ASC',
    );
    return result.map((map) => DoctorModel.fromMap(map)).toList();
  }

  /// Get doctor by ID
  Future<DoctorModel?> getDoctorById(String id) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'doctors',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return DoctorModel.fromMap(result.first);
  }

  /// Insert a new doctor
  Future<void> insertDoctor(DoctorModel doctor) async {
    final db = await _dbHelper.database;
    await db.insert('doctors', doctor.toMap());
  }

  /// Bulk insert doctors
  Future<void> insertDoctors(List<DoctorModel> doctors) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (var doctor in doctors) {
      batch.insert('doctors', doctor.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Update doctor
  Future<void> updateDoctor(DoctorModel doctor) async {
    final db = await _dbHelper.database;
    await db.update(
      'doctors',
      doctor.toMap(),
      where: 'id = ?',
      whereArgs: [doctor.id],
    );
  }

  /// Delete doctor
  Future<void> deleteDoctor(String id) async {
    final db = await _dbHelper.database;
    await db.delete('doctors', where: 'id = ?', whereArgs: [id]);
  }

  /// Toggle doctor favorite status
  Future<void> toggleFavorite(String id, bool isFavorite) async {
    final db = await _dbHelper.database;
    await db.update(
      'doctors',
      {'isfavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Search doctors by name or specialty
  Future<List<DoctorModel>> searchDoctors(String query) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'doctors',
      where: 'name LIKE ? OR specialty LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((map) => DoctorModel.fromMap(map)).toList();
  }

  /// Get doctors filtered by specialty and gender
  Future<List<DoctorModel>> getFilteredDoctors({
    String? specialty,
    String? gender,
  }) async {
    final db = await _dbHelper.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (specialty != null && gender != null) {
      whereClause = 'specialty = ? AND gender = ?';
      whereArgs = [specialty, gender];
    } else if (specialty != null) {
      whereClause = 'specialty = ?';
      whereArgs = [specialty];
    } else if (gender != null) {
      whereClause = 'gender = ?';
      whereArgs = [gender];
    }

    final result = await db.query(
      'doctors',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'name ASC',
    );
    return result.map((map) => DoctorModel.fromMap(map)).toList();
  }

  /// Check if database has doctors
  Future<bool> hasDoctors() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM doctors');
    final count = result.first['count'] as int;
    return count > 0;
  }

  /// Clear all doctors
  Future<void> clearAllDoctors() async {
    final db = await _dbHelper.database;
    await db.delete('doctors');
  }
}
