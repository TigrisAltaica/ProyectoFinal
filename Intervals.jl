module Intervals

import Base.==, Base.contains, Base.^, Base.exp, Base.log, Base.sin, Base.cos, Base.tan

export Interval, +,-,*,/, ==,^, midpoint, contains, IntervalLength, NewtonOperator, Intersection, BisectInterval, MultiDimInterval, MakeMultiDimInterval
#Ahora quiero implementar redondeo. lo más lógico es redondear el primer número para abajo y el segundo para arriba
type Interval
    
    a::Float64
    b::Float64
    
    Interval(a,b) = a > b ? new(b,a) : new(a,b)

end
    

#Estas funciones sirven para hacer aritmética con redondeo dirigido


function UpSum(x,y)
    with_rounding(Float64,RoundUp) do
        x+y
    end
end

function DownSum(x,y)
    with_rounding(Float64,RoundDown) do
        x+y
    end
end

function UpSubs(x,y)
    with_rounding(Float64,RoundUp) do
        x-y
    end
end

function DownSubs(x,y)
    with_rounding(Float64,RoundDown) do
        x-y
    end
end

function UpProd(x,y)
    with_rounding(Float64,RoundUp) do
        x*y
    end
end

function DownProd(x,y)
    with_rounding(Float64,RoundDown) do
        x*y
    end
end

function UpDiv(x,y)
    with_rounding(Float64,RoundUp) do
        x/y
    end
end

function DownDiv(x,y)
    with_rounding(Float64,RoundDown) do
        x/y
    end
end

function UpExp(x,y)
    with_rounding(Float64,RoundUp) do
        x^y
    end
end

function DownExp(x,y)
    with_rounding(Float64,RoundDown) do
        x^y
    end
end

#Revisa si un número dado está en un intervalo

function contains(x::Interval, n::Real)
	
	n>=x.a && n<=x.b
end

function contains(x::Interval, y::Interval)
	
	contains(x,y.a)&&contains(x,y.b)
end

#Aritmética de intervalos

function +(x::Interval, y::Interval)
    
    return(Interval(DownSum(x.a,y.a),UpSum(x.b,y.b)))
    
end


function -(x::Interval, y::Interval)
    
    return(Interval(DownSubs(x.a,y.b),UpSubs(x.b,y.a)))
    
end

function +(y::Interval, x::Real)
    
    return(Interval(DownSum(x,y.a),UpSum(x,y.b)))
    
end

function +(y::Real,x::Interval)
    
    return(Interval(DownSum(x.a,y),UpSum(x.b,y)))
    
end

function -(x::Interval, y::Real)
    
    return(Interval(DownSubs(x.a,y),UpSubs(x.b,y)))
    
end


function -(x::Real,y::Interval)
    
    return(Interval(DownSubs(x,y.a),UpSubs(x,y.b)))
    
end

#para la multiplicación y la división es un poco más complejo, así que tomo el intervalo más amplio posible, es decir, el m'inimo de las multiplicaciones 
#posibles como a y el máximo como b, y así mismo para la división


function *(x::Interval, y::Interval)
    
    return(Interval(min(DownProd(x.a,y.a),DownProd(x.a,y.b),DownProd(x.b,y.a),DownProd(x.b,y.b)),max(UpProd(x.a,y.a),UpProd(x.a,y.b),UpProd(x.b,y.a),UpProd(x.b,y.b))))
    
end

function *( y::Real,x::Interval)
    
    return(Interval(DownProd(x.a,y),UpProd(x.b,y)))
    
end

function *( x::Interval,y::Real)
    
    return(Interval(DownProd(x.a,y),UpProd(x.b,y)))
    
end

function /(x::Interval, y::Interval)
    
   if contains(y,0.0)
	error("No puedo dividir por un intervalo que contiene el 0")
   end	
    
    return(Interval(min(DownDiv(x.a,y.a),DownDiv(x.a,y.b),DownDiv(x.b,y.a),DownDiv(x.b,y.b)),max(UpDiv(x.a,y.a),UpDiv(x.a,y.b),UpDiv(x.b,y.a),UpDiv(x.b,y.b))))
    
end


function /(x::Real, y::Interval)
    
   if contains(y,0.0)
	error("No puedo dividir por un intervalo que contiene el 0")
   end	
    
    return(Interval(min(DownDiv(x,y.a),DownDiv(x,y.b)),max(UpDiv(x,y.a),UpDiv(x,y.b))))
    
end

#potencia de un intervalo

function ^(x::Interval,n::Integer)

    if isodd(n) 
        return(Interval(x.a^n,x.b^n))
    end

    if iseven(n)
        if x.a>=0
            Interval((x.a)^n,(x.b)^n)
            elseif x.b >= 0
                Interval(0,max(x.a^n,x.b^n))
            else
                Interval((x.a)^n,(x.b)^n)
        end
    end
end

function ^(x::Interval,n::Real)


    
    if x.b < 0
	error("Intervalo completamente negativo, al menos parte del intervalo debe ser no negativo")
    end	

    if x.a < 0
	x.a=0
        println("Solo se utilizó la parte no negativa del intervalo")
    end
	
    return(Interval(x.a^n,x.b^n))

end



#Longitud de in intervalo

function IntervalLength(x::Interval)

	return(abs(x.b-x.a))
end


		
			
#Punto medio de un intervalo

function midpoint(x::Interval)
	
	return(Interval(DownDiv(DownSum(x.a,x.b),2),UpDiv(UpSum(x.a,x.b),2)))
end



#Comparación de intervalos

function ==(x::Interval, y::Interval)
	
	(x.a == y.a) && (x.b == y.b)

end

#Funciones monótonas estandard

function exp(x::Interval)

	Interval(exp(x.a),exp(x.b))

end

function log(x::Interval)

	Interval(log(x.a),log(x.b))
end

#Funciones trigonométricas

function cos(x::Interval)
    
    n2=int(x.b/pi)
    n1=int(x.a/pi)
    a=0
    b=0
    
    
    for i=n1:n2
        
        if contains(x,i*pi)
            if iseven(i)
                b=1
            end
            if isodd(i)
                a=-1
            end
            
        end
    end
    
    
    if a == 0
        a=min(cos(x.a),cos(x.b))
    end
    
    if b == 0
        b=max(cos(x.a),cos(x.b))
    end
    
    return(Interval(a,b))
end

function sin(x::Interval)

	return(cos(x-pi/2))
end

function tan(x::Interval)

	return(sin(x)/cos(x))
end


#Operador de Newton

function NewtonOperator(F::Function,dF::Interval,X::Interval)
    
    m=midpoint(X)

    return(m-F(m)/dF)
    
    
end

#Interseccion de dos intervalos

function Intersection(A::Interval,B::Interval)
    
    if(A.a > B.b || B.a > A.b)
   	return(nothing)
    end
    
    if(contains(A,B))
        return(B)
    end
    
    if(contains(B,A))
        return(A)
    end
    
    if(A.b<=B.b)
        return(Interval(B.a,A.b))
    end
    
    if(B.b<=A.b)
        return(Interval(A.a,B.b))
    end
   
end


function BisectInterval(x::Interval)
    
    c=(x.a+x.b)/2.0

    return([Interval(x.a,c),Interval(c,x.b)])
    
end

#Intervalos Multidimensionales

type MultiDimInterval
    
    N::Int
    I::Vector{Interval}
    
end

function MakeMultiDimInterval(N,L)

    I=Interval[]
    
    for i=1:N
        push!(I,Interval(-L,L))
    end
    
    return(MultiDimInterval(N,I))

end

function +(A::MultiDimInterval, B::MultiDimInterval)
    
    if A.N != B.N
        error("Las dimensiones de los intervalos no son iguales")
    end
    
    temp = Interval[]
    
    for i = 1:A.N
        push!(temp,A.I[i]+B.I[i])
    end
    
    return(MultiDimInterval(A.N,temp))
end

function +(A::Real, B::MultiDimInterval)

    
    temp = Interval[]
    
    for i = 1:B.N
        push!(temp,A+B.I[i])
    end
    
    return(MultiDimInterval(B.N,temp))
end

function +(A::MultiDimInterval, B::Real)
    
    temp = Interval[]
    
    for i = 1:A.N
        push!(temp,A.I[i]+B)
    end
    
    return(MultiDimInterval(A.N,temp))
end

function -(A::MultiDimInterval, B::MultiDimInterval)
    
    if A.N != B.N
        error("Las dimensiones de los intervalos no son iguales")
    end
    
    temp = Interval[]
    
    for i = 1:A.N
        push!(temp,A.I[i]-B.I[i])
    end
    
    return(MultiDimInterval(A.N,temp))
end

function -(A::Real, B::MultiDimInterval)

    
    temp = Interval[]
    
    for i = 1:B.N
        push!(temp,A-B.I[i])
    end
    
    return(MultiDimInterval(B.N,temp))
end

function -(A::MultiDimInterval, B::Real)
    
    temp = Interval[]
    
    for i = 1:A.N
        push!(temp,A.I[i]-B)
    end
    
    return(MultiDimInterval(A.N,temp))
end

function *(A::Real, B::MultiDimInterval)
    
    temp = Interval[]
    
    for i = 1:B.N
        push!(temp,A*B.I[i])
    end
    
    return(MultiDimInterval(B.N,temp))
end

function *(B::MultiDimInterval,A::Real)
    
    temp = Interval[]
    
    for i = 1:B.N
        push!(temp,A*B.I[i])
    end
    
    return(MultiDimInterval(B.N,temp))
end


#Redefinición de la funcion zero para poder utilizar multiplicar arreglos de intervalos por matrices

Base.promote_type{T<:Number}(::Type{T}, ::Type{Interval}) = Interval
#Base.promote_type(::Type{Interval}, ::Type{Number}) = Interval
#Base.promote(x::Number, y::Interval) = Interval(x, x

Base.convert(::Type{Interval}, x::Real) = Interval(x, x)
Base.convert(::Type{Interval}, x::Interval) = x

Base.zero(::Type{Interval}) = Interval(0,0)
promote_type(Int, Interval)

Base.zero(x::Interval) = Interval(0, 0)
Base.zero(x::Any) = 0

end
