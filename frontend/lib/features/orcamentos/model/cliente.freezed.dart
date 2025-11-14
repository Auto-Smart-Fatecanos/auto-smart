// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cliente.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ClienteModel _$ClienteModelFromJson(Map<String, dynamic> json) {
  return _ClienteModel.fromJson(json);
}

/// @nodoc
mixin _$ClienteModel {
  int? get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get cpf => throw _privateConstructorUsedError;
  String get telefone => throw _privateConstructorUsedError;

  /// Serializes this ClienteModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClienteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClienteModelCopyWith<ClienteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClienteModelCopyWith<$Res> {
  factory $ClienteModelCopyWith(
    ClienteModel value,
    $Res Function(ClienteModel) then,
  ) = _$ClienteModelCopyWithImpl<$Res, ClienteModel>;
  @useResult
  $Res call({int? id, String nome, String cpf, String telefone});
}

/// @nodoc
class _$ClienteModelCopyWithImpl<$Res, $Val extends ClienteModel>
    implements $ClienteModelCopyWith<$Res> {
  _$ClienteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClienteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nome = null,
    Object? cpf = null,
    Object? telefone = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            nome: null == nome
                ? _value.nome
                : nome // ignore: cast_nullable_to_non_nullable
                      as String,
            cpf: null == cpf
                ? _value.cpf
                : cpf // ignore: cast_nullable_to_non_nullable
                      as String,
            telefone: null == telefone
                ? _value.telefone
                : telefone // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClienteModelImplCopyWith<$Res>
    implements $ClienteModelCopyWith<$Res> {
  factory _$$ClienteModelImplCopyWith(
    _$ClienteModelImpl value,
    $Res Function(_$ClienteModelImpl) then,
  ) = __$$ClienteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, String nome, String cpf, String telefone});
}

/// @nodoc
class __$$ClienteModelImplCopyWithImpl<$Res>
    extends _$ClienteModelCopyWithImpl<$Res, _$ClienteModelImpl>
    implements _$$ClienteModelImplCopyWith<$Res> {
  __$$ClienteModelImplCopyWithImpl(
    _$ClienteModelImpl _value,
    $Res Function(_$ClienteModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ClienteModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nome = null,
    Object? cpf = null,
    Object? telefone = null,
  }) {
    return _then(
      _$ClienteModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        cpf: null == cpf
            ? _value.cpf
            : cpf // ignore: cast_nullable_to_non_nullable
                  as String,
        telefone: null == telefone
            ? _value.telefone
            : telefone // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ClienteModelImpl implements _ClienteModel {
  const _$ClienteModelImpl({
    this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
  });

  factory _$ClienteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClienteModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String nome;
  @override
  final String cpf;
  @override
  final String telefone;

  @override
  String toString() {
    return 'ClienteModel(id: $id, nome: $nome, cpf: $cpf, telefone: $telefone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClienteModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.cpf, cpf) || other.cpf == cpf) &&
            (identical(other.telefone, telefone) ||
                other.telefone == telefone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nome, cpf, telefone);

  /// Create a copy of ClienteModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClienteModelImplCopyWith<_$ClienteModelImpl> get copyWith =>
      __$$ClienteModelImplCopyWithImpl<_$ClienteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClienteModelImplToJson(this);
  }
}

abstract class _ClienteModel implements ClienteModel {
  const factory _ClienteModel({
    final int? id,
    required final String nome,
    required final String cpf,
    required final String telefone,
  }) = _$ClienteModelImpl;

  factory _ClienteModel.fromJson(Map<String, dynamic> json) =
      _$ClienteModelImpl.fromJson;

  @override
  int? get id;
  @override
  String get nome;
  @override
  String get cpf;
  @override
  String get telefone;

  /// Create a copy of ClienteModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClienteModelImplCopyWith<_$ClienteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
