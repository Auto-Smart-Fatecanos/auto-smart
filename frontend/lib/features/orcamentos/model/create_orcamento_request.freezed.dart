// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_orcamento_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateOrcamentoItemRequest _$CreateOrcamentoItemRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateOrcamentoItemRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateOrcamentoItemRequest {
  String get descricao => throw _privateConstructorUsedError;
  @JsonKey(name: 'tipoOrcamento')
  String get tipoOrcamento => throw _privateConstructorUsedError;
  @JsonKey(name: 'orcamentoValor')
  double get valor => throw _privateConstructorUsedError;

  /// Serializes this CreateOrcamentoItemRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateOrcamentoItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateOrcamentoItemRequestCopyWith<CreateOrcamentoItemRequest>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrcamentoItemRequestCopyWith<$Res> {
  factory $CreateOrcamentoItemRequestCopyWith(
    CreateOrcamentoItemRequest value,
    $Res Function(CreateOrcamentoItemRequest) then,
  ) =
      _$CreateOrcamentoItemRequestCopyWithImpl<
        $Res,
        CreateOrcamentoItemRequest
      >;
  @useResult
  $Res call({
    String descricao,
    @JsonKey(name: 'tipoOrcamento') String tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') double valor,
  });
}

/// @nodoc
class _$CreateOrcamentoItemRequestCopyWithImpl<
  $Res,
  $Val extends CreateOrcamentoItemRequest
>
    implements $CreateOrcamentoItemRequestCopyWith<$Res> {
  _$CreateOrcamentoItemRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateOrcamentoItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? descricao = null,
    Object? tipoOrcamento = null,
    Object? valor = null,
  }) {
    return _then(
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateOrcamentoItemRequestImplCopyWith<$Res>
    implements $CreateOrcamentoItemRequestCopyWith<$Res> {
  factory _$$CreateOrcamentoItemRequestImplCopyWith(
    _$CreateOrcamentoItemRequestImpl value,
    $Res Function(_$CreateOrcamentoItemRequestImpl) then,
  ) = __$$CreateOrcamentoItemRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String descricao,
    @JsonKey(name: 'tipoOrcamento') String tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') double valor,
  });
}

/// @nodoc
class __$$CreateOrcamentoItemRequestImplCopyWithImpl<$Res>
    extends
        _$CreateOrcamentoItemRequestCopyWithImpl<
          $Res,
          _$CreateOrcamentoItemRequestImpl
        >
    implements _$$CreateOrcamentoItemRequestImplCopyWith<$Res> {
  __$$CreateOrcamentoItemRequestImplCopyWithImpl(
    _$CreateOrcamentoItemRequestImpl _value,
    $Res Function(_$CreateOrcamentoItemRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateOrcamentoItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? descricao = null,
    Object? tipoOrcamento = null,
    Object? valor = null,
  }) {
    return _then(
      _$CreateOrcamentoItemRequestImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrcamentoItemRequestImpl implements _CreateOrcamentoItemRequest {
  const _$CreateOrcamentoItemRequestImpl({
    required this.descricao,
    @JsonKey(name: 'tipoOrcamento') required this.tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') required this.valor,
  });

  factory _$CreateOrcamentoItemRequestImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$CreateOrcamentoItemRequestImplFromJson(json);

  @override
  final String descricao;
  @override
  @JsonKey(name: 'tipoOrcamento')
  final String tipoOrcamento;
  @override
  @JsonKey(name: 'orcamentoValor')
  final double valor;

  @override
  String toString() {
    return 'CreateOrcamentoItemRequest(descricao: $descricao, tipoOrcamento: $tipoOrcamento, valor: $valor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrcamentoItemRequestImpl &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao) &&
            (identical(other.tipoOrcamento, tipoOrcamento) ||
                other.tipoOrcamento == tipoOrcamento) &&
            (identical(other.valor, valor) || other.valor == valor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, descricao, tipoOrcamento, valor);

  /// Create a copy of CreateOrcamentoItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrcamentoItemRequestImplCopyWith<_$CreateOrcamentoItemRequestImpl>
  get copyWith =>
      __$$CreateOrcamentoItemRequestImplCopyWithImpl<
        _$CreateOrcamentoItemRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrcamentoItemRequestImplToJson(this);
  }
}

abstract class _CreateOrcamentoItemRequest
    implements CreateOrcamentoItemRequest {
  const factory _CreateOrcamentoItemRequest({
    required final String descricao,
    @JsonKey(name: 'tipoOrcamento') required final String tipoOrcamento,
    @JsonKey(name: 'orcamentoValor') required final double valor,
  }) = _$CreateOrcamentoItemRequestImpl;

  factory _CreateOrcamentoItemRequest.fromJson(Map<String, dynamic> json) =
      _$CreateOrcamentoItemRequestImpl.fromJson;

  @override
  String get descricao;
  @override
  @JsonKey(name: 'tipoOrcamento')
  String get tipoOrcamento;
  @override
  @JsonKey(name: 'orcamentoValor')
  double get valor;

  /// Create a copy of CreateOrcamentoItemRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateOrcamentoItemRequestImplCopyWith<_$CreateOrcamentoItemRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateOrcamentoRequest _$CreateOrcamentoRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateOrcamentoRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateOrcamentoRequest {
  @JsonKey(name: 'clienteId')
  int get clienteId => throw _privateConstructorUsedError;
  String get placa => throw _privateConstructorUsedError;
  String get modelo => throw _privateConstructorUsedError;
  @JsonKey(name: 'orcamentoItens')
  List<CreateOrcamentoItemRequest> get itens =>
      throw _privateConstructorUsedError;

  /// Serializes this CreateOrcamentoRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateOrcamentoRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateOrcamentoRequestCopyWith<CreateOrcamentoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateOrcamentoRequestCopyWith<$Res> {
  factory $CreateOrcamentoRequestCopyWith(
    CreateOrcamentoRequest value,
    $Res Function(CreateOrcamentoRequest) then,
  ) = _$CreateOrcamentoRequestCopyWithImpl<$Res, CreateOrcamentoRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'clienteId') int clienteId,
    String placa,
    String modelo,
    @JsonKey(name: 'orcamentoItens') List<CreateOrcamentoItemRequest> itens,
  });
}

/// @nodoc
class _$CreateOrcamentoRequestCopyWithImpl<
  $Res,
  $Val extends CreateOrcamentoRequest
>
    implements $CreateOrcamentoRequestCopyWith<$Res> {
  _$CreateOrcamentoRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateOrcamentoRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clienteId = null,
    Object? placa = null,
    Object? modelo = null,
    Object? itens = null,
  }) {
    return _then(
      _value.copyWith(
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
            itens: null == itens
                ? _value.itens
                : itens // ignore: cast_nullable_to_non_nullable
                      as List<CreateOrcamentoItemRequest>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateOrcamentoRequestImplCopyWith<$Res>
    implements $CreateOrcamentoRequestCopyWith<$Res> {
  factory _$$CreateOrcamentoRequestImplCopyWith(
    _$CreateOrcamentoRequestImpl value,
    $Res Function(_$CreateOrcamentoRequestImpl) then,
  ) = __$$CreateOrcamentoRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'clienteId') int clienteId,
    String placa,
    String modelo,
    @JsonKey(name: 'orcamentoItens') List<CreateOrcamentoItemRequest> itens,
  });
}

/// @nodoc
class __$$CreateOrcamentoRequestImplCopyWithImpl<$Res>
    extends
        _$CreateOrcamentoRequestCopyWithImpl<$Res, _$CreateOrcamentoRequestImpl>
    implements _$$CreateOrcamentoRequestImplCopyWith<$Res> {
  __$$CreateOrcamentoRequestImplCopyWithImpl(
    _$CreateOrcamentoRequestImpl _value,
    $Res Function(_$CreateOrcamentoRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateOrcamentoRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clienteId = null,
    Object? placa = null,
    Object? modelo = null,
    Object? itens = null,
  }) {
    return _then(
      _$CreateOrcamentoRequestImpl(
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
        itens: null == itens
            ? _value._itens
            : itens // ignore: cast_nullable_to_non_nullable
                  as List<CreateOrcamentoItemRequest>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrcamentoRequestImpl implements _CreateOrcamentoRequest {
  const _$CreateOrcamentoRequestImpl({
    @JsonKey(name: 'clienteId') required this.clienteId,
    required this.placa,
    required this.modelo,
    @JsonKey(name: 'orcamentoItens')
    required final List<CreateOrcamentoItemRequest> itens,
  }) : _itens = itens;

  factory _$CreateOrcamentoRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrcamentoRequestImplFromJson(json);

  @override
  @JsonKey(name: 'clienteId')
  final int clienteId;
  @override
  final String placa;
  @override
  final String modelo;
  final List<CreateOrcamentoItemRequest> _itens;
  @override
  @JsonKey(name: 'orcamentoItens')
  List<CreateOrcamentoItemRequest> get itens {
    if (_itens is EqualUnmodifiableListView) return _itens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itens);
  }

  @override
  String toString() {
    return 'CreateOrcamentoRequest(clienteId: $clienteId, placa: $placa, modelo: $modelo, itens: $itens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrcamentoRequestImpl &&
            (identical(other.clienteId, clienteId) ||
                other.clienteId == clienteId) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.modelo, modelo) || other.modelo == modelo) &&
            const DeepCollectionEquality().equals(other._itens, _itens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    clienteId,
    placa,
    modelo,
    const DeepCollectionEquality().hash(_itens),
  );

  /// Create a copy of CreateOrcamentoRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateOrcamentoRequestImplCopyWith<_$CreateOrcamentoRequestImpl>
  get copyWith =>
      __$$CreateOrcamentoRequestImplCopyWithImpl<_$CreateOrcamentoRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateOrcamentoRequestImplToJson(this);
  }
}

abstract class _CreateOrcamentoRequest implements CreateOrcamentoRequest {
  const factory _CreateOrcamentoRequest({
    @JsonKey(name: 'clienteId') required final int clienteId,
    required final String placa,
    required final String modelo,
    @JsonKey(name: 'orcamentoItens')
    required final List<CreateOrcamentoItemRequest> itens,
  }) = _$CreateOrcamentoRequestImpl;

  factory _CreateOrcamentoRequest.fromJson(Map<String, dynamic> json) =
      _$CreateOrcamentoRequestImpl.fromJson;

  @override
  @JsonKey(name: 'clienteId')
  int get clienteId;
  @override
  String get placa;
  @override
  String get modelo;
  @override
  @JsonKey(name: 'orcamentoItens')
  List<CreateOrcamentoItemRequest> get itens;

  /// Create a copy of CreateOrcamentoRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateOrcamentoRequestImplCopyWith<_$CreateOrcamentoRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
