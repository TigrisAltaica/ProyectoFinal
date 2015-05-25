module Bolas

import Base.sin,Base.cos,Base.exp,Base.tan,Base.cot,Base.sec,Base.csc,Base.log,Base.asin,Base.acos,Base.atan,Base.acot,Base.asec,Base.acsc,Base.sinh,Base.cosh,Base.tanh,Base.coth,Base.sech,Base.csch


export Bola, distancia, contiene, norma, interseccion_de_bolas, bisectar_bolas, operador_de_newton, quitar_no_deseadas


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
        dist=UpSum(dist,(x[i]-y[i])^2)
    end
    
    return(sqrt(dist))
end
    
function distancia(A::Bola,B::Bola) #Mide la distancia entre dos puntos

    return(distancia(A.centro,B.centro))

end

function norma(A) #Me dá la norma de un vector o un punto

    return(distancia(A,zeros(length(A))))

end


function contiene(B::Bola,x::Real)

    if distancia(B.centro,x)<= B.radio
        return(true)
    else
        return(false)
    end
     
end

function contiene(A::Bola,B::Bola)
    return(contiene(A,B.centro+B.radio)&&contiene(A,B.centro-B.radio)) 
end

function ==(A::Bola,B::Bola)

    return( A.centro==B.centro && A.radio==B.radio )
    
end

function bisectar_bolas(B)
    
    temp=Bola[]
    
    for i=1:length(B)
        append!(temp,[Bola(B[i].centro-.5*B[i].radio,.5*B[i].radio),Bola(B[i].centro+.5*B[i].radio,.5*B[i].radio)])
    end
    
    return(temp)
    
end

function quitar_no_deseadas(F::Function,B,x)
    
    temp=Bola[]
    dF(x)=F(makex(x)).d
    
    for i=1:length(B)
        if contiene(F(B[i]),x)
            push!(temp,B[i])
        end
    end
    
    return(temp)
    
    
end

function operador_de_newton_bola(F::Function,B::Bola)
    
    dF(x)=F(makex(x)).d
    m=Bola(B.centro,0)
    
    return (m-F(m)/(dF(B)))
    
end   



function interseccion_de_bolas(A::Bola, B::Bola)
    
    if contiene(A,B)
        return(B)
    end
    
    if contiene(B,A)
        return(A)
    end
    
    if A.centro > B.centro
        
        if A.centro-A.radio > B.centro + B.radio
            return(nothing)
        end
        
        return(Bola((A.centro-A.radio+B.centro+B.radio)*.5,distancia((A.centro-A.radio+B.centro+B.radio)*.5,A.centro-A.radio)))
        
    end
    
    if B.centro > A.centro
        
        if B.centro-B.radio > A.centro + A.radio
            return(nothing)
        end
        
        return(Bola((B.centro-B.radio+A.centro+A.radio)*.5,distancia((B.centro-B.radio+A.centro+A.radio)*.5,B.centro-B.radio)))
        
    end
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
    return(Bola(c*A.centro,c*A.radio))
end

function *(A::Bola,c::Real)
    return(Bola(c*A.centro,c*A.radio))
end

function *(A::Bola,B::Bola)
    return(Bola(A.centro*B.centro,UpSum(UpProd(norma(A.centro)+A.radio,B.radio),UpProd(norma(B.centro),A.radio))))
end

function /(A::Bola,B::Bola)
    
    if contiene(B,0)
       error("No se puede dividir por una bola que contine el 0")
    end
    
    return(Bola(A.centro/B.centro,UpSum(UpProd(norma(A.centro)+A.radio,B.radio),UpProd(norma(1/B.centro),A.radio))))
end

function ^(A::Bola, n::Int)
    
    if n == -1
        return Bola(1,0)/A
    end

    if n == 0
        return Bola(1,0)
    end
    
    if n == 1
        
        return A
    end
    
    
    return Bola(A.centro^n,n*abs(A.centro)^(n-1)*A.radio+n*(n-1)*abs(A.centro)^(n-2)*A.radio)
end


#Funciones elementales

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
    
