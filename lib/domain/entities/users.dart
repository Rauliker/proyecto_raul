class User {
  final String email;
  final String username;
  final String password;
  final int role;
  final String avatar;
  final bool banned;
  late final int? balance;
  final String calle;
  final Provincia provincia;
  final Localidad localidad;
  final List<Token>? tokens;
  final List<Puja>? createdPujas;
  final List<PujaBid>? pujaBids;

  User(
      {required this.email,
      required this.username,
      required this.password,
      required this.avatar,
      required this.role,
      required this.banned,
      required this.balance,
      required this.provincia,
      required this.localidad,
      required this.createdPujas,
      required this.tokens,
      required this.pujaBids,
      required this.calle});
}

class Provincia {
  final int idProvincia;
  final String nombre;

  Provincia({
    required this.idProvincia,
    required this.nombre,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_provincia': idProvincia,
      'nombre': nombre,
    };
  }

  factory Provincia.fromJson(Map<String, dynamic> json) {
    return Provincia(
      idProvincia: json['id_provincia'],
      nombre: json['nombre'],
    );
  }
}

class Token {
  final int idToken;
  final String token;
  final String fcmToken;
  final String deviceInfo;
  final DateTime createdAt;
  final DateTime? loggedOutAt;

  Token({
    required this.idToken,
    required this.token,
    required this.fcmToken,
    required this.deviceInfo,
    required this.createdAt,
    required this.loggedOutAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": idToken,
      "token": token,
      "fcmToken": fcmToken,
      "deviceInfo": deviceInfo,
      "createdAt": createdAt.toIso8601String(),
      "loggedOutAt": loggedOutAt?.toIso8601String(),
    };
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      idToken: json['id'],
      token: json['token'],
      fcmToken: json['fcmToken'],
      deviceInfo: json['deviceInfo'],
      createdAt: DateTime.parse(json['createdAt']),
      loggedOutAt: json['loggedOutAt'] == null
          ? null
          : DateTime.parse(json['loggedOutAt']
              .toString()
              .substring(0, json['loggedOutAt'].toString().length - 1)),
    );
  }
}

class Localidad {
  final int idLocalidad;
  final String nombre;

  Localidad({
    required this.idLocalidad,
    required this.nombre,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_localidad': idLocalidad,
      'nombre': nombre,
    };
  }

  factory Localidad.fromJson(Map<String, dynamic> json) {
    return Localidad(
      idLocalidad: json['id_localidad'],
      nombre: json['nombre'],
    );
  }
}

class Puja {
  final int id;
  final String nombre;
  final bool open;
  final String descripcion;
  final String pujaInicial;
  final DateTime fechaFin;

  Puja({
    required this.id,
    required this.nombre,
    required this.open,
    required this.descripcion,
    required this.pujaInicial,
    required this.fechaFin,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'pujaInicial': pujaInicial,
      'fechaFin': fechaFin.toIso8601String(),
    };
  }

  factory Puja.fromJson(Map<String, dynamic> json) {
    return Puja(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      pujaInicial: json['pujaInicial'],
      fechaFin: DateTime.parse(json['fechaFin']),
      open: json['open'],
    );
  }
}

class PujaBid {
  final int id;
  final bool iswinner;
  final String amount;
  final String emailUser;
  final bool isAuto;
  final int maxAutoBid;
  final int increment;
  final DateTime fecha;

  PujaBid(
      {required this.id,
      required this.iswinner,
      required this.amount,
      required this.emailUser,
      required this.fecha,
      required this.isAuto,
      required this.maxAutoBid,
      required this.increment});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iswinner': iswinner,
      'amount': amount,
      'email_user': emailUser,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory PujaBid.fromJson(Map<String, dynamic> json) {
    return PujaBid(
      id: json['id'] as int,
      iswinner: json['iswinner'] as bool,
      amount: json['amount'] as String,
      emailUser: json['email_user'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      isAuto: json['is_auto'] as bool,
      maxAutoBid: json['max_auto_bid'] as int,
      increment: json['increment'] as int,
    );
  }
}
