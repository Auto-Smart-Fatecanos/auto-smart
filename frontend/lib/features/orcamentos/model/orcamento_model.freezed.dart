// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orcamento_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrcamentoModel _$OrcamentoModelFromJson(Map<String, dynamic> json) {
  return _OrcamentoModel.fromJson(json);
}

/// @nodoc
mixin _$OrcamentoModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'clienteId')
  int get clienteId => throw _privateConstructorUsedError;
  String get placa => throw _privateConstructorUsedError;
  String get modelo => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'dataCriacao')
  DateTime? get dataCriacao => throw _privateConstructorUsedError;
  @JsonKey(name: 'orcamentoItems')
  List<OrcamentoItemModel> get orcamentoItems =>
      throw _privateConstructorUsedError;
  ClienteModel? get cliente => throw _privateConstructorUsedError;

  /// Serializes this OrcamentoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrcamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrcamentoModelCopyWith<OrcamentoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrcamentoModelCopyWith<$Res> {
  factory $OrcamentoModelCopyWith(
    OrcamentoModel value,
    $Res Function(OrcamentoModel) then,
  ) = _$OrcamentoModelCopyWithImpl<$Res, OrcamentoModel>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'clienteId') int clienteId,
    String placa,
    String modelo,
    String status,
    @JsonKey(name: 'dataCriacao') DateTime? dataCriacao,
    @JsonKey(name: 'orcamentoItems') List<OrcamentoItemModel> orcamentoItems,
    ClienteModel? cliente,
  });

  $ClienteModelCopyWith<$Res>? get cliente;
}

/// @nodoc
class _$OrcamentoModelCopyWithImpl<$Res, $Val extends OrcamentoModel>
    implements $OrcamentoModelCopyWith<$Res> {
  _$OrcamentoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrcamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? clienteId = null,
    Object? placa = null,
    Object? modelo = null,
    Object? status = null,
    Object? dataCriacao = freezed,
    Object? orcamentoItems = null,
    Object? cliente = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            clienteId: null == clienteId
                ? _value.clienteId
                : clienteId // ignore: cast_nullable_to_non_nullable
                      as int,
            placa: null == placa
                ? _value.placa
                : placa // ignore: cast_nullable_to_non_nullable
                      as String,
            modelo: null == modelo
                ? _value.modelo
                : modelo // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            dataCriacao: freezed == dataCriacao
                ? _value.dataCriacao
                : dataCriacao // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            orcamentoItems: null == orcamentoItems
                ? _value.orcamentoItems
                : orcamentoItems // ignore: cast_nullable_to_non_nullable
                      as List<OrcamentoItemModel>,
            cliente: freezed == cliente
                ? _value.cliente
                : cliente // ignore: cast_nullable_to_non_nullable
                      as ClienteModel?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrcamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClienteModelCopyWith<$Res>? get cliente {
    if (_value.cliente == null) {
      return null;
    }

    return $ClienteModelCopyWith<$Res>(_value.cliente!, (value) {
      return _then(_value.copyWith(cliente: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrcamentoModelImplCopyWith<$Res>
    implements $OrcamentoModelCopyWith<$Res> {
  factory _$$OrcamentoModelImplCopyWith(
    _$OrcamentoModelImpl value,
    $Res Function(_$OrcamentoModelImpl) then,
  ) = __$$OrcamentoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'clienteId') int clienteId,
    String placa,
    String modelo,
    String status,
    @JsonKey(name: 'dataCriacao') DateTime? dataCriacao,
    @JsonKey(name: 'orcamentoItems') List<OrcamentoItemModel> orcamentoItems,
    ClienteModel? cliente,
  });

  @override
  $ClienteModelCopyWith<$Res>? get cliente;
}

/// @nodoc
class __$$OrcamentoModelImplCopyWithImpl<$Res>
    extends _$OrcamentoModelCopyWithImpl<$Res, _$OrcamentoModelImpl>
    implements _$$OrcamentoModelImplCopyWith<$Res> {
  __$$OrcamentoModelImplCopyWithImpl(
    _$OrcamentoModelImpl _value,
    $Res Function(_$OrcamentoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrcamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? clienteId = null,
    Object? placa = null,
    Object? modelo = null,
    Object? status = null,
    Object? dataCriacao = freezed,
    Object? orcamentoItems = null,
    Object? cliente = freezed,
  }) {
    return _then(
      _$OrcamentoModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        clienteId: null == clienteId
            ? _value.clienteId
            : clienteId // ignore: cast_nullable_to_non_nullable
                  as int,
        placa: null == placa
            ? _value.placa
            : placa // ignore: cast_nullable_to_non_nullable
                  as String,
        modelo: null == modelo
            ? _value.modelo
            : modelo // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        dataCriacao: freezed == dataCriacao
            ? _value.dataCriacao
            : dataCriacao // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        orcamentoItems: null == orcamentoItems
            ? _value._orcamentoItems
            : orcamentoItems // ignore: cast_nullable_to_non_nullable
                  as List<OrcamentoItemModel>,
        cliente: freezed == cliente
            ? _value.cliente
            : cliente // ignore: cast_nullable_to_non_nullable
                  as ClienteModel?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrcamentoModelImpl implements _OrcamentoModel {
  const _$OrcamentoModelImpl({
    this.id,
    @JsonKey(name: 'clienteId') required this.clienteId,
    required this.placa,
    required this.modelo,
    this.status = '',
    @JsonKey(name: 'dataCriacao') this.dataCriacao,
    @JsonKey(name: 'orcamentoItems')
    final List<OrcamentoItemModel> orcamentoItems =
        const <OrcamentoItemModel>[],
    this.cliente,
  }) : _orcamentoItems = orcamentoItems;

  factory _$OrcamentoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrcamentoModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'clienteId')
  final int clienteId;
  @override
  final String placa;
  @override
  final String modelo;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'dataCriacao')
  final DateTime? dataCriacao;
  final List<OrcamentoItemModel> _orcamentoItems;
  @override
  @JsonKey(name: 'orcamentoItems')
  List<OrcamentoItemModel> get orcamentoItems {
    if (_orcamentoItems is EqualUnmodifiableListView) return _orcamentoItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orcamentoItems);
  }

  @override
  final ClienteModel? cliente;

  @override
  String toString() {
    return 'OrcamentoModel(id: $id, clienteId: $clienteId, placa: $placa, modelo: $modelo, status: $status, dataCriacao: $dataCriacao, orcamentoItems: $orcamentoItems, cliente: $cliente)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrcamentoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clienteId, clienteId) ||
                other.clienteId == clienteId) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.dataCriacao, dataCriacao) ||
                other.dataCriacao == dataCriacao) &&
            const DeepCollectionEquality().equals(
              other._orcamentoItems,
              _orcamentoItems,
            ) &&
            (identical(other.cliente, cliente) || other.cliente == cliente));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    clienteId,
    placa,
    modelo,
    status,
    dataCriacao,
    const DeepCollectionEquality().hash(_orcamentoItems),
    cliente,
  );

  /// Create a copy of OrcamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrcamentoModelImplCopyWith<_$OrcamentoModelImpl> get copyWith =>
      __$$OrcamentoModelImplCopyWithImpl<_$OrcamentoModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrcamentoModelImplToJson(this);
  }
}

abstract class _OrcamentoModel implements OrcamentoModel {
  const factory _OrcamentoModel({
    final int? id,
    @JsonKey(name: 'clienteId') required final int clienteId,
    required final String placa,
    required final String modelo,
    final String status,
    @JsonKey(name: 'dataCriacao') final DateTime? dataCriacao,
    @JsonKey(name: 'orcamentoItems')
    final List<OrcamentoItemModel> orcamentoItems,
    final ClienteModel? cliente,
  }) = _$OrcamentoModelImpl;

  factory _OrcamentoModel.fromJson(Map<String, dynamic> json) =
      _$OrcamentoModelImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'clienteId')
  int get clienteId;
  @override
  String get placa;
  @override
  String get modelo;
  @override
  String get status;
  @override
  @JsonKey(name: 'dataCriacao')
  DateTime? get dataCriacao;
  @override
  @JsonKey(name: 'orcamentoItems')
  List<OrcamentoItemModel> get orcamentoItems;
  @override
  ClienteModel? get cliente;

  /// Create a copy of OrcamentoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrcamentoModelImplCopyWith<_$OrcamentoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
