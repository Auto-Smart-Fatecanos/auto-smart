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

OrcamentoData _$OrcamentoDataFromJson(Map<String, dynamic> json) {
  return _OrcamentoData.fromJson(json);
}

/// @nodoc
mixin _$OrcamentoData {
  @JsonKey(name: 'clienteId')
  int get clienteId => throw _privateConstructorUsedError;
  String get placa => throw _privateConstructorUsedError;
  String get modelo => throw _privateConstructorUsedError;

  /// Serializes this OrcamentoData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrcamentoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrcamentoDataCopyWith<OrcamentoData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrcamentoDataCopyWith<$Res> {
  factory $OrcamentoDataCopyWith(
    OrcamentoData value,
    $Res Function(OrcamentoData) then,
  ) = _$OrcamentoDataCopyWithImpl<$Res, OrcamentoData>;
  @useResult
  $Res call({
    @JsonKey(name: 'clienteId') int clienteId,
    String placa,
    String modelo,
  });
}

/// @nodoc
class _$OrcamentoDataCopyWithImpl<$Res, $Val extends OrcamentoData>
    implements $OrcamentoDataCopyWith<$Res> {
  _$OrcamentoDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrcamentoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clienteId = null,
    Object? placa = null,
    Object? modelo = null,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrcamentoDataImplCopyWith<$Res>
    implements $OrcamentoDataCopyWith<$Res> {
  factory _$$OrcamentoDataImplCopyWith(
    _$OrcamentoDataImpl value,
    $Res Function(_$OrcamentoDataImpl) then,
  ) = __$$OrcamentoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'clienteId') int clienteId,
    String placa,
    String modelo,
  });
}

/// @nodoc
class __$$OrcamentoDataImplCopyWithImpl<$Res>
    extends _$OrcamentoDataCopyWithImpl<$Res, _$OrcamentoDataImpl>
    implements _$$OrcamentoDataImplCopyWith<$Res> {
  __$$OrcamentoDataImplCopyWithImpl(
    _$OrcamentoDataImpl _value,
    $Res Function(_$OrcamentoDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrcamentoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clienteId = null,
    Object? placa = null,
    Object? modelo = null,
  }) {
    return _then(
      _$OrcamentoDataImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrcamentoDataImpl implements _OrcamentoData {
  const _$OrcamentoDataImpl({
    @JsonKey(name: 'clienteId') required this.clienteId,
    required this.placa,
    required this.modelo,
  });

  factory _$OrcamentoDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrcamentoDataImplFromJson(json);

  @override
  @JsonKey(name: 'clienteId')
  final int clienteId;
  @override
  final String placa;
  @override
  final String modelo;

  @override
  String toString() {
    return 'OrcamentoData(clienteId: $clienteId, placa: $placa, modelo: $modelo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrcamentoDataImpl &&
            (identical(other.clienteId, clienteId) ||
                other.clienteId == clienteId) &&
            (identical(other.placa, placa) || other.placa == placa) &&
            (identical(other.modelo, modelo) || other.modelo == modelo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, clienteId, placa, modelo);

  /// Create a copy of OrcamentoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrcamentoDataImplCopyWith<_$OrcamentoDataImpl> get copyWith =>
      __$$OrcamentoDataImplCopyWithImpl<_$OrcamentoDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrcamentoDataImplToJson(this);
  }
}

abstract class _OrcamentoData implements OrcamentoData {
  const factory _OrcamentoData({
    @JsonKey(name: 'clienteId') required final int clienteId,
    required final String placa,
    required final String modelo,
  }) = _$OrcamentoDataImpl;

  factory _OrcamentoData.fromJson(Map<String, dynamic> json) =
      _$OrcamentoDataImpl.fromJson;

  @override
  @JsonKey(name: 'clienteId')
  int get clienteId;
  @override
  String get placa;
  @override
  String get modelo;

  /// Create a copy of OrcamentoData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrcamentoDataImplCopyWith<_$OrcamentoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrcamentoItensWrapper _$OrcamentoItensWrapperFromJson(
  Map<String, dynamic> json,
) {
  return _OrcamentoItensWrapper.fromJson(json);
}

/// @nodoc
mixin _$OrcamentoItensWrapper {
  @JsonKey(name: 'orcamentoItens')
  List<CreateOrcamentoItemRequest> get orcamentoItens =>
      throw _privateConstructorUsedError;

  /// Serializes this OrcamentoItensWrapper to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrcamentoItensWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrcamentoItensWrapperCopyWith<OrcamentoItensWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrcamentoItensWrapperCopyWith<$Res> {
  factory $OrcamentoItensWrapperCopyWith(
    OrcamentoItensWrapper value,
    $Res Function(OrcamentoItensWrapper) then,
  ) = _$OrcamentoItensWrapperCopyWithImpl<$Res, OrcamentoItensWrapper>;
  @useResult
  $Res call({
    @JsonKey(name: 'orcamentoItens')
    List<CreateOrcamentoItemRequest> orcamentoItens,
  });
}

/// @nodoc
class _$OrcamentoItensWrapperCopyWithImpl<
  $Res,
  $Val extends OrcamentoItensWrapper
>
    implements $OrcamentoItensWrapperCopyWith<$Res> {
  _$OrcamentoItensWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrcamentoItensWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orcamentoItens = null}) {
    return _then(
      _value.copyWith(
            orcamentoItens: null == orcamentoItens
                ? _value.orcamentoItens
                : orcamentoItens // ignore: cast_nullable_to_non_nullable
                      as List<CreateOrcamentoItemRequest>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrcamentoItensWrapperImplCopyWith<$Res>
    implements $OrcamentoItensWrapperCopyWith<$Res> {
  factory _$$OrcamentoItensWrapperImplCopyWith(
    _$OrcamentoItensWrapperImpl value,
    $Res Function(_$OrcamentoItensWrapperImpl) then,
  ) = __$$OrcamentoItensWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'orcamentoItens')
    List<CreateOrcamentoItemRequest> orcamentoItens,
  });
}

/// @nodoc
class __$$OrcamentoItensWrapperImplCopyWithImpl<$Res>
    extends
        _$OrcamentoItensWrapperCopyWithImpl<$Res, _$OrcamentoItensWrapperImpl>
    implements _$$OrcamentoItensWrapperImplCopyWith<$Res> {
  __$$OrcamentoItensWrapperImplCopyWithImpl(
    _$OrcamentoItensWrapperImpl _value,
    $Res Function(_$OrcamentoItensWrapperImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrcamentoItensWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? orcamentoItens = null}) {
    return _then(
      _$OrcamentoItensWrapperImpl(
        orcamentoItens: null == orcamentoItens
            ? _value._orcamentoItens
            : orcamentoItens // ignore: cast_nullable_to_non_nullable
                  as List<CreateOrcamentoItemRequest>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrcamentoItensWrapperImpl implements _OrcamentoItensWrapper {
  const _$OrcamentoItensWrapperImpl({
    @JsonKey(name: 'orcamentoItens')
    required final List<CreateOrcamentoItemRequest> orcamentoItens,
  }) : _orcamentoItens = orcamentoItens;

  factory _$OrcamentoItensWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrcamentoItensWrapperImplFromJson(json);

  final List<CreateOrcamentoItemRequest> _orcamentoItens;
  @override
  @JsonKey(name: 'orcamentoItens')
  List<CreateOrcamentoItemRequest> get orcamentoItens {
    if (_orcamentoItens is EqualUnmodifiableListView) return _orcamentoItens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orcamentoItens);
  }

  @override
  String toString() {
    return 'OrcamentoItensWrapper(orcamentoItens: $orcamentoItens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrcamentoItensWrapperImpl &&
            const DeepCollectionEquality().equals(
              other._orcamentoItens,
              _orcamentoItens,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_orcamentoItens),
  );

  /// Create a copy of OrcamentoItensWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrcamentoItensWrapperImplCopyWith<_$OrcamentoItensWrapperImpl>
  get copyWith =>
      __$$OrcamentoItensWrapperImplCopyWithImpl<_$OrcamentoItensWrapperImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrcamentoItensWrapperImplToJson(this);
  }
}

abstract class _OrcamentoItensWrapper implements OrcamentoItensWrapper {
  const factory _OrcamentoItensWrapper({
    @JsonKey(name: 'orcamentoItens')
    required final List<CreateOrcamentoItemRequest> orcamentoItens,
  }) = _$OrcamentoItensWrapperImpl;

  factory _OrcamentoItensWrapper.fromJson(Map<String, dynamic> json) =
      _$OrcamentoItensWrapperImpl.fromJson;

  @override
  @JsonKey(name: 'orcamentoItens')
  List<CreateOrcamentoItemRequest> get orcamentoItens;

  /// Create a copy of OrcamentoItensWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrcamentoItensWrapperImplCopyWith<_$OrcamentoItensWrapperImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateOrcamentoRequest _$CreateOrcamentoRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateOrcamentoRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateOrcamentoRequest {
  @JsonKey(name: 'Orcamento')
  OrcamentoData get orcamento => throw _privateConstructorUsedError;
  @JsonKey(name: 'orcamentoItens')
  OrcamentoItensWrapper get orcamentoItens =>
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
    @JsonKey(name: 'Orcamento') OrcamentoData orcamento,
    @JsonKey(name: 'orcamentoItens') OrcamentoItensWrapper orcamentoItens,
  });

  $OrcamentoDataCopyWith<$Res> get orcamento;
  $OrcamentoItensWrapperCopyWith<$Res> get orcamentoItens;
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
  $Res call({Object? orcamento = null, Object? orcamentoItens = null}) {
    return _then(
      _value.copyWith(
            orcamento: null == orcamento
                ? _value.orcamento
                : orcamento // ignore: cast_nullable_to_non_nullable
                      as OrcamentoData,
            orcamentoItens: null == orcamentoItens
                ? _value.orcamentoItens
                : orcamentoItens // ignore: cast_nullable_to_non_nullable
                      as OrcamentoItensWrapper,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateOrcamentoRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrcamentoDataCopyWith<$Res> get orcamento {
    return $OrcamentoDataCopyWith<$Res>(_value.orcamento, (value) {
      return _then(_value.copyWith(orcamento: value) as $Val);
    });
  }

  /// Create a copy of CreateOrcamentoRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrcamentoItensWrapperCopyWith<$Res> get orcamentoItens {
    return $OrcamentoItensWrapperCopyWith<$Res>(_value.orcamentoItens, (value) {
      return _then(_value.copyWith(orcamentoItens: value) as $Val);
    });
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
    @JsonKey(name: 'Orcamento') OrcamentoData orcamento,
    @JsonKey(name: 'orcamentoItens') OrcamentoItensWrapper orcamentoItens,
  });

  @override
  $OrcamentoDataCopyWith<$Res> get orcamento;
  @override
  $OrcamentoItensWrapperCopyWith<$Res> get orcamentoItens;
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
  $Res call({Object? orcamento = null, Object? orcamentoItens = null}) {
    return _then(
      _$CreateOrcamentoRequestImpl(
        orcamento: null == orcamento
            ? _value.orcamento
            : orcamento // ignore: cast_nullable_to_non_nullable
                  as OrcamentoData,
        orcamentoItens: null == orcamentoItens
            ? _value.orcamentoItens
            : orcamentoItens // ignore: cast_nullable_to_non_nullable
                  as OrcamentoItensWrapper,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateOrcamentoRequestImpl implements _CreateOrcamentoRequest {
  const _$CreateOrcamentoRequestImpl({
    @JsonKey(name: 'Orcamento') required this.orcamento,
    @JsonKey(name: 'orcamentoItens') required this.orcamentoItens,
  });

  factory _$CreateOrcamentoRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateOrcamentoRequestImplFromJson(json);

  @override
  @JsonKey(name: 'Orcamento')
  final OrcamentoData orcamento;
  @override
  @JsonKey(name: 'orcamentoItens')
  final OrcamentoItensWrapper orcamentoItens;

  @override
  String toString() {
    return 'CreateOrcamentoRequest(orcamento: $orcamento, orcamentoItens: $orcamentoItens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateOrcamentoRequestImpl &&
            (identical(other.orcamento, orcamento) ||
                other.orcamento == orcamento) &&
            (identical(other.orcamentoItens, orcamentoItens) ||
                other.orcamentoItens == orcamentoItens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, orcamento, orcamentoItens);

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
    @JsonKey(name: 'Orcamento') required final OrcamentoData orcamento,
    @JsonKey(name: 'orcamentoItens')
    required final OrcamentoItensWrapper orcamentoItens,
  }) = _$CreateOrcamentoRequestImpl;

  factory _CreateOrcamentoRequest.fromJson(Map<String, dynamic> json) =
      _$CreateOrcamentoRequestImpl.fromJson;

  @override
  @JsonKey(name: 'Orcamento')
  OrcamentoData get orcamento;
  @override
  @JsonKey(name: 'orcamentoItens')
  OrcamentoItensWrapper get orcamentoItens;

  /// Create a copy of CreateOrcamentoRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateOrcamentoRequestImplCopyWith<_$CreateOrcamentoRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
