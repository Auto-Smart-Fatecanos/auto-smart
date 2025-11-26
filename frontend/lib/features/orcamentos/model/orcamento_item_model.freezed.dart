// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'orcamento_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrcamentoItemModel _$OrcamentoItemModelFromJson(Map<String, dynamic> json) {
  return _OrcamentoItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrcamentoItemModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'orcamentoId')
  int? get orcamentoId => throw _privateConstructorUsedError;
  String get descricao => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipoOrcamento')
  String get tipoOrcamento => throw _privateConstructorUsedError;
  @JsonKey(name: 'orcamentoValor')
  double get valor => throw _privateConstructorUsedError;
  bool get ativo => throw _privateConstructorUsedError;

  /// Serializes this OrcamentoItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrcamentoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrcamentoItemModelCopyWith<OrcamentoItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrcamentoItemModelCopyWith<$Res> {
  factory $OrcamentoItemModelCopyWith(
    OrcamentoItemModel value,
    $Res Function(OrcamentoItemModel) then,
  ) = _$OrcamentoItemModelCopyWithImpl<$Res, OrcamentoItemModel>;
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'orcamentoId') int? orcamentoId,
    String descricao,
    @JsonKey(name: 'tipoOrcamento') String tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') double valor,
    bool ativo,
  });
}

/// @nodoc
class _$OrcamentoItemModelCopyWithImpl<$Res, $Val extends OrcamentoItemModel>
    implements $OrcamentoItemModelCopyWith<$Res> {
  _$OrcamentoItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrcamentoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orcamentoId = freezed,
    Object? descricao = null,
    Object? tipoOrcamento = null,
    Object? valor = null,
    Object? ativo = null,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            orcamentoId: freezed == orcamentoId
                ? _value.orcamentoId
                : orcamentoId // ignore: cast_nullable_to_non_nullable
                      as int?,
            descricao: null == descricao
                ? _value.descricao
                : descricao // ignore: cast_nullable_to_non_nullable
                      as String,
            tipoOrcamento: null == tipoOrcamento
                ? _value.tipoOrcamento
                : tipoOrcamento // ignore: cast_nullable_to_non_nullable
                      as String,
            valor: null == valor
                ? _value.valor
                : valor // ignore: cast_nullable_to_non_nullable
                      as double,
            ativo: null == ativo
                ? _value.ativo
                : ativo // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrcamentoItemModelImplCopyWith<$Res>
    implements $OrcamentoItemModelCopyWith<$Res> {
  factory _$$OrcamentoItemModelImplCopyWith(
    _$OrcamentoItemModelImpl value,
    $Res Function(_$OrcamentoItemModelImpl) then,
  ) = __$$OrcamentoItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    @JsonKey(name: 'orcamentoId') int? orcamentoId,
    String descricao,
    @JsonKey(name: 'tipoOrcamento') String tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') double valor,
    bool ativo,
  });
}

/// @nodoc
class __$$OrcamentoItemModelImplCopyWithImpl<$Res>
    extends _$OrcamentoItemModelCopyWithImpl<$Res, _$OrcamentoItemModelImpl>
    implements _$$OrcamentoItemModelImplCopyWith<$Res> {
  __$$OrcamentoItemModelImplCopyWithImpl(
    _$OrcamentoItemModelImpl _value,
    $Res Function(_$OrcamentoItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrcamentoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? orcamentoId = freezed,
    Object? descricao = null,
    Object? tipoOrcamento = null,
    Object? valor = null,
    Object? ativo = null,
  }) {
    return _then(
      _$OrcamentoItemModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        orcamentoId: freezed == orcamentoId
            ? _value.orcamentoId
            : orcamentoId // ignore: cast_nullable_to_non_nullable
                  as int?,
        descricao: null == descricao
            ? _value.descricao
            : descricao // ignore: cast_nullable_to_non_nullable
                  as String,
        tipoOrcamento: null == tipoOrcamento
            ? _value.tipoOrcamento
            : tipoOrcamento // ignore: cast_nullable_to_non_nullable
                  as String,
        valor: null == valor
            ? _value.valor
            : valor // ignore: cast_nullable_to_non_nullable
                  as double,
        ativo: null == ativo
            ? _value.ativo
            : ativo // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrcamentoItemModelImpl implements _OrcamentoItemModel {
  const _$OrcamentoItemModelImpl({
    this.id,
    @JsonKey(name: 'orcamentoId') this.orcamentoId,
    required this.descricao,
    @JsonKey(name: 'tipoOrcamento') required this.tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') required this.valor,
    this.ativo = true,
  });

  factory _$OrcamentoItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrcamentoItemModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'orcamentoId')
  final int? orcamentoId;
  @override
  final String descricao;
  @override
  @JsonKey(name: 'tipoOrcamento')
  final String tipoOrcamento;
  @override
  @JsonKey(name: 'orcamentoValor')
  final double valor;
  @override
  @JsonKey()
  final bool ativo;

  @override
  String toString() {
    return 'OrcamentoItemModel(id: $id, orcamentoId: $orcamentoId, descricao: $descricao, tipoOrcamento: $tipoOrcamento, valor: $valor, ativo: $ativo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrcamentoItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orcamentoId, orcamentoId) ||
                other.orcamentoId == orcamentoId) &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao) &&
            (identical(other.tipoOrcamento, tipoOrcamento) ||
                other.tipoOrcamento == tipoOrcamento) &&
            (identical(other.valor, valor) || other.valor == valor) &&
            (identical(other.ativo, ativo) || other.ativo == ativo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orcamentoId,
    descricao,
    tipoOrcamento,
    valor,
    ativo,
  );

  /// Create a copy of OrcamentoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrcamentoItemModelImplCopyWith<_$OrcamentoItemModelImpl> get copyWith =>
      __$$OrcamentoItemModelImplCopyWithImpl<_$OrcamentoItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrcamentoItemModelImplToJson(this);
  }
}

abstract class _OrcamentoItemModel implements OrcamentoItemModel {
  const factory _OrcamentoItemModel({
    final int? id,
    @JsonKey(name: 'orcamentoId') final int? orcamentoId,
    required final String descricao,
    @JsonKey(name: 'tipoOrcamento') required final String tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') required final double valor,
    final bool ativo,
  }) = _$OrcamentoItemModelImpl;

  factory _OrcamentoItemModel.fromJson(Map<String, dynamic> json) =
      _$OrcamentoItemModelImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'orcamentoId')
  int? get orcamentoId;
  @override
  String get descricao;
  @override
  @JsonKey(name: 'tipoOrcamento')
  String get tipoOrcamento;
  @override
  @JsonKey(name: 'orcamentoValor')
  double get valor;
  @override
  bool get ativo;

  /// Create a copy of OrcamentoItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrcamentoItemModelImplCopyWith<_$OrcamentoItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
