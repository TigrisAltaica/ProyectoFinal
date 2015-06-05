module Bolas

using Derivatives

import Base.sin,Base.cos,Base.exp,Base.tan,Base.cot,Base.sec,Base.csc,Base.log,Base.asin,Base.acos,Base.atan,Base.acot,Base.asec,Base.acsc,Base.sinh,Base.cosh,Base.tanh,Base.coth,Base.sech,Base.csch



export 
Bola,distancia,contiene,norma,interseccion_de_bolas,bisectar_bolas,revisar_cercanas,quitar_repetidas,quitar_no_utiles,operador_de_newton,quitar_no_deseadas,metodo_newton_bola                           



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
    Bola(c,r) = r < 0 ? new(c,abs(r)) : new(c,r) #Fuerza radio positivo
    
    
 end

function distancia(x,y) #Mide la distancia entre dos puntos
    
    if length(x) != length(y)
        error("Error: ambos puntos deben tener el mismo numero de entradas")
    end
    
    dist=0
    
    for i=1:length(x)
        dist+=(x[i]-y[i])^2
    end
    
    return(sqrt(dist))
end
    
function distancia(A::Bola,B::Bola) #Mide la distancia entre dos puntos

    return(distancia(A.centro,B.centro))

end

function norma(A) #Me dá la norma de un vector o un punto

    return(distancia(A,zeros(length(A))))

end


function contiene(B::Bola,x::Real) #revisa si un real se encuentra dentro de una bola dada

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

     if A.centro==B.centro && A.radio==B.radio 
     return true
     else
     return false
     end
    
end

function bisectar_bolas(B) #regresa un arreglo de dos bolas
    
    temp=Bola[]
    
    for i=1:length(B)
        append!(temp,[Bola(B[i].centro-.5*B[i].radio,.5*B[i].radio),Bola(B[i].centro+.5*B[i].radio,.5*B[i].radio)])
    end
    
    return(temp)
    
end



function interseccion_de_bolas(A::Bola, B::Bola) #Regresa la bola intersección, regresa nothing si esta es nula
    
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

function revisar_cercanas(A,B,tol) #revisa si una raíz dada está cerca de las demás
    
    for i = 1:length(B)
        
        if distancia(A,B[i]) <= tol
            return(true) 
        end
        
        
    end
    
    return(false)
end

function quitar_repetidas(A,tol) #remueve raices que esten mas cerca que una cierta tolerancia
   
    temp=Bola[]
    
    for i=1:length(A)
        
        if !(revisar_cercanas(A[i],temp,tol))
            push!(temp,A[i])
        end
        
    end
    
    return(temp)
end



function quitar_no_deseadas(F::Function,B,x) #Funcion para quitar bolas donde la derivada de la funcion se hace cero
    
    temp=Bola[]
    dF(x)=F(makex(x)).d
    
    for i=1:length(B)
        if !contiene(dF(B[i]),x)
            push!(temp,B[i])
        end
    end
    
    return(temp)
end

function quitar_no_utiles(F::Function,B,x) #Se encarga de quitar bolas que no contienen ceros de la funcion
    
    temp=Bola[]
    
    for i=1:length(B)
        if contiene(F(B[i]),x)
            push!(temp,B[i])
        end
    end
    
    return(temp)
end



function operador_de_newton_bola(F::Function,B::Bola) 
    
    dF(x)=F(makex(x)).d
    m=Bola(B.centro,1e-16) #Le asigno un radio mínimo al punto m 
    
    
    return (m-UpDiv(F(m),(dF(B))))
    
end   

#Método de Newton con intervalos de bola
#El método requiere una función, una bola inicial y una tolerancia de bisección, entre más fina mejor.
#Si el método no logra actuar en alguno de los intervalos, avisa al usuario que debería probar con más bisección. 
#Si una raíz se encuentra muy cerca de una raíz de la derivada el método falla.



function metodo_newton_bola(F::Function, B::Bola,tolbis=1e-3)
    
    X=[B]
    
    i=0
    tolradio=1e-15
    tolsimilar = 1e-2
    
    while(X[1].radio>tolbis)
        
       X=bisectar_bolas(X)
       X=quitar_no_utiles(F,X,0)
    
        
        i+=1
        
        if i==50
            break
        end
        
        X
 
    end
    
    X=quitar_no_deseadas(F,X,0)
    
    j=0
    
    flag=X[1].radio
    
    radio_promedio=1
    
    while(tolradio<radio_promedio)
        
        radio_promedio=0
        
        
        for i=1:length(X)
            
            temp=operador_de_newton_bola(F,X[i])
            
            if interseccion_de_bolas(X[i],temp)==nothing
                X[i]=interseccion_de_bolas(B,temp)
            else
                X[i]=interseccion_de_bolas(X[i],temp)
            end
            
            radio_promedio+=(X[i].radio)
        end
         
        radio_promedio/=length(X)
        
        j+=1
        
        if j==50
            break
        end
    end
    
    X=quitar_repetidas(X,tolsimilar)
    
    for i=1:length(X) 
        println("Posible raíz en $(X[i].centro) ± $(X[i].radio)")
    end
    
    for i=1:length(X) 
        if X[i].radio >= flag
            println("El método de Newton no pudo actuar en todas las bolas, probar una tolerancia de bisección menor")
            break
        end
    end
    
    
    
end
    
#Operaciones Aritméticas

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
    return(Bola(A.centro*B.centro,UpSum(UpProd(norma(A.centro)+A.radio,B.radio),UpProd(norma(B.centro)+B.radio,A.radio))))
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
    
    h=Array(Float64,2)
    h[1]=abs(UpSubs((A.centro+A.radio)^n,(A.centro)^n))
    h[2]=abs(UpSubs((A.centro-A.radio)^n,(A.centro)^n))

    

    return Bola((A.centro)^n,maximum(h))
end


#Funciones elementales

function sin(A::Bola)
    if A.centro>0
        s=UpSubs(1,cos(A.radio))
    else
        s=UpSubs(cos(A.radio),1)
    end
    
    return Bola(sin(A.centro),UpSum(UpProd(sin(A.centro),s),UpProd(sin(A.radio),cos(A.centro))))
end

function cos(A::Bola)
    if A.centro<(pi/2)
        s=UpSubs(1.0,cos(A.radio))
    else
        s=UpSubs(cos(A.radio),1.0)
    end
    return Bola(cos(A.centro),UpSum(UpProd(s,cos(A.centro)),UpProd(sin(A.radio),sin(A.centro))))
end

function exp(A::Bola)

    return Bola(exp(A.centro),UpProd(exp(A.centro),UpSum(cosh(A.radio),UpSubs(sinh(A.radio),1))))
end

function log(A::Bola)
    return Bola(log(A.centro),UpSubs(log(A.centro),log(A.centro-A.radio)))
end

function tan(A::Bola)
    if A.centro>0
        s=UpSubs(1.0,UpProd(tan(A.radio),tan(A.centro)))
    else
        s=UpSum(1.0,UpProd(tan(A.centro),tan(A.radio)))
    end
    return Bola(tan(A.centro),UpDiv(UpProd(tan(A.radio),UpSum(1.0,UpProd(tan(A.centro),tan(A.centro)))),s))
end

function cot(A::Bola)
    if A.centro<pi/2
        s=UpSubs(tan(A.centro),tan(A.radio))
    else
        s=UpSum(tan(A.centro),tan(A.radio))
    end
    return Bola(cot(A.centro),UpProd(UpDiv(tan(A.radio),tan(A.centro)),UpDiv( UpSum(1,(tan(A.centro))^2),s )))
end

function sec(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(sec(A.centro+A.radio),sec(A.centro)))
    h[2]=abs(UpSubs(sec(A.centro-A.radio),sec(A.centro)))
    
    return Bola(sec(A.centro),maximum(h))
end

function csc(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(csc(A.centro+A.radio),csc(A.centro)))
    h[2]=abs(UpSubs(csc(A.centro-A.radio),csc(A.centro)))
    return Bola(csc(A.centro),maximum(h))
end

function asin(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(asin(A.centro+A.radio),asin(A.centro)))
    h[2]=abs(UpSubs(asin(A.centro-A.radio),asin(A.centro)))
    return Bola(asin(A.centro),maximum(h))
end

function acos(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(acos(A.centro+A.radio),acos(A.centro)))
    h[2]=abs(UpSubs(acos(A.centro-A.radio),acos(A.centro)))
    return Bola(acos(A.centro),maximum(h))
end

function atan(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(atan(A.centro+A.radio),atan(A.centro)))
    h[2]=abs(UpSubs(atan(A.centro-A.radio),atan(A.centro)))
    return Bola(atan(A.centro),maximum(h))
end

function acot(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(acot(A.centro+A.radio),acot(A.centro)))
    h[2]=abs(UpSubs(acot(A.centro-A.radio),acot(A.centro)))
    return Bola(acot(A.centro),maximum(h))
end

function asec(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(asec(A.centro+A.radio),asec(A.centro)))
    h[2]=abs(UpSubs(asec(A.centro-A.radio),asec(A.centro)))
    return Bola(asec(A.centro),maximum(h))
end

function acsc(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(acsc(A.centro+A.radio),acsc(A.centro)))
    h[2]=abs(UpSubs(acsc(A.centro-A.radio),acsc(A.centro)))
    return Bola(acsc(A.centro),maximum(h))
end

function sinh(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(sinh(A.centro+A.radio),sinh(A.centro)))
    h[2]=abs(UpSubs(sinh(A.centro-A.radio),sinh(A.centro)))
    return Bola(sinh(A.centro),maximum(h))
end

function cosh(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(cosh(A.centro+A.radio),cosh(A.centro)))
    h[2]=abs(UpSubs(cosh(A.centro-A.radio),cosh(A.centro)))
    return Bola(cosh(A.centro),maximum(h))
end

function tanh(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(tanh(A.centro+A.radio),tanh(A.centro)))
    h[2]=abs(UpSubs(tanh(A.centro-A.radio),tanh(A.centro)))
    return Bola(tanh(A.centro),maximum(h))
end

function coth(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(coth(A.centro+A.radio),coth(A.centro)))
    h[2]=abs(UpSubs(coth(A.centro-A.radio),coth(A.centro)))
    return Bola(coth(A.centro),maximum(h))
end

function sech(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(sech(A.centro+A.radio),sech(A.centro)))
    h[2]=abs(UpSubs(sech(A.centro-A.radio),sech(A.centro)))
    return Bola(sech(A.centro),maximum(h))
end

function csch(A::Bola)
    h=Array(Float64,2)
    h[1]=abs(UpSubs(csch(A.centro+A.radio),csch(A.centro)))
    h[2]=abs(UpSubs(csch(A.centro-A.radio),csch(A.centro)))
    return Bola(csch(A.centro),maximum(h))
end


end 
    
