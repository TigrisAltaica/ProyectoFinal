module Bolas

import Base.sin,Base.cos,Base.exp,Base.tan,Base.cot,Base.sec,Base.csc,Base.log,Base.asin,Base.acos,Base.atan,Base.acot,Base.asec,Base.acsc,Base.sinh,Base.cosh,Base.tanh,Base.coth,Base.sech,Base.csch
export Bola, distancia, contiene

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


type Bola
    
    centro
    radio
   
    Bola(c) = new(c,1)
    Bola(c,r) = r < 0 ? new(c,abs(r)) : new(c,r)
end

function distancia(x,y) #Mide la distancia entre dos puntos
    
    if length(x) != length(y)
        error("Error: ambos puntos deben tener el mismo numero de entradas")
    end
    
    dist=0
    
    for i=1:length(x)
        dist=UpSum(dist,DownSubs(x[i],y[i])^2)
    end
    
    return(sqrt(dist))
end
    
function distancia(A::Bola,B::Bola) #Mide la distancia entre dos puntos
    
    x=A.centro
    y=B.centro
    
    if length(x) != length(y)
        error("Error: ambos puntos deben tener el mismo numero de entradas")
    end
    
    dist=0
    
    for i=1:length(x)
        dist+=(x[i]-y[i])^2
    end
    
    return(sqrt(dist))
end


function contiene(B::Bola,x)

    if distancia(B.centro,x)<= B.radio
        return(true)
    else
        return(false)
    end
     
end

function ==(A::Bola,B::Bola)

    return( A.centro==B.centro && A.radio==B.radio )
    
end
    

function +(A::Bola,B::Bola)
    
    return(Bola(A.centro+B.centro,UpSum(A.radio,B.radio)))
end

function +(A::Bola,c)
    
    return(Bola(A.centro+c,A.radio))
end

function +(c,A::Bola)
    
    return(Bola(A.centro+c,A.radio))
end

function -(A::Bola,B::Bola)
    
    return(Bola(A.centro-B.centro,UpSum(A.radio,B.radio)))
end

function -(A::Bola,c)
    
    return(Bola(A.centro-c,A.radio))
end

function -(c,A::Bola)
    
    return(Bola(c-A.centro,A.radio))
end   

function *(c::Real, A::Bola)
    return(Bola(c*A.centro,A.radio))
end

function *(A::Bola,c::Real)
    return(Bola(c*A.centro,A.radio))
end

function sin(A::Bola)
return Bola(sin(A.centro),A.radio*cos(A.centro))
end

function cos(A::Bola)
return Bola(cos(A.centro),A.radio*sin(A.centro))
end

function exp(A::Bola)
return Bola(exp(A.centro),exp(A.centro)*A.radio)
end

function log(A::Bola)
return Bola(log(A.centro),A.radio/A.centro)
end

function tan(A::Bola)
return Bola(tan(A.centro),(sec(A.centro)^2)*A.radio)
end

function cot(A::Bola)
return Bola(cot(A.centro),(csc(A.centro)^2)*A.radio)
end

function sec(A::Bola)
return Bola(sec(A.centro),tan(A.centro)*sec(A.centro)*A.radio)
end

function csc(A::Bola)
return Bola(csc(A.centro),csc(A.centro)*cot(A.centro)*A.radio)
end

function asin(A::Bola)
return Bola(asin(A.centro),A.radio/sqrt(1-(A.centro^2)))
end

function acos(A::Bola)
return Bola(acos(A.centro),A.radio/sqrt(1-(A.centro^2)))
end

function atan(A::Bola)
return Bola(atan(A.centro),A.radio/(1+(A.centro^2)))
end

function acot(A::Bola)
return Bola(acot(A.centro),A.radio/(1+(A.centro^2)))
end

function asec(A::Bola)
return Bola(asec(A.centro),A.radio/((A.centro^2)*sqrt(1-(A.centro^-2))))
end

function acsc(A::Bola)
return Bola(acsc(A.centro),A.radio/((A.centro^2)*sqrt(1-(A.centro^-2))))
end

function sinh(A::Bola)
return Bola(sinh(A.centro),A.radio*cosh(A.centro))
end

function cosh(A::Bola)
return Bola(cosh(A.centro),A.radio*sinh(A.centro))
end

function tanh(A::Bola)
return Bola(tanh(A.centro),(sech(A.centro)^2)*A.radio)
end

function coth(A::Bola)
return Bola(coth(A.centro),(csch(A.centro)^2)*A.radio)
end

function sech(A::Bola)
return Bola(sech(A.centro),tanh(A.centro)*sech(A.centro)*A.radio)
end

function csch(A::Bola)
return Bola(csch(A.centro),csch(A.centro)*coth(A.centro)*A.radio)
end





end 
    
