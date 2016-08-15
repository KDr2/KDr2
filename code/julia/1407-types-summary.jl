
type T
    foo::Int
    bar::Float64
end

type T1
    qux::Any
end

immutable T2
    r::Int
    g::Int
    b::Int
end

t = T(0, 1.0)
t1 = T1(3)
t2 = T2(1,2,3)

# super
@assert(is(super(T), Any))
@assert(is(super(T1), Any))
@assert(is(super(T2), Any))
@assert(is(super(Type{Union(T1, T2)}), Any))

@assert(is(super(Type), Any))
@assert(is(super(DataType), Type))
@assert(is(super(UnionType), Type))
@assert(is(super(Type{T}), Any))


# issubtype
@assert(Type{T} <: DataType)
@assert(Type{Union(T1, T2)} <: UnionType)
@assert((T1,T2) <: (Any, Any) <: Tuple)
@assert(None <: T1 <: Union(T1, T2) <: Top)

# isa
@assert(isa(t, T))
@assert(isa(t, Any))

@assert(isa(T, Type{T}))
@assert(isa(T, DataType))

@assert(isa((t1, t2), (T1, T2)))
@assert(isa((T1, T2), (Type{T1}, Type{T2})))
@assert(isa((T1, T2), (DataType, DataType)))
