module Bolas

import Base.sin,Base.cos,Base.exp,Base.tan,Base.cot,Base.sec,Base.csc,Base.log,Base.asin,Base.acos,Base.atan,Base.acot,Base.asec,Base.acsc,Base.sinh,Base.cosh,Base.tanh,Base.coth,Base.sech,Base.csch



export Bola, distancia, contiene, norma


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


function contiene(B::Bola,x)

    if distancia(B.centro,x)<= B.radio
        return(true)
    else
        return(false)
    end
     
end

function ==(A::Bola,B::Bola)

     if A.centro==B.centro && A.radio==B.radio 
     return true
     else
     return false
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
if A.centro>0
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

function intersection(A::Bola,B::Bola)
    h=Array(BigFloat,4)
    ord=Array(BigFloat,4)
    inter=Array(BigFloat,2)

    if A==B
        return A
    end
    
    h[1]=(A.centro-A.radio)
h[2]=(A.centro+A.radio)
h[3]=(B.centro-B.radio)
h[4]=(B.centro+B.radio)
    ord[1]=minimum(h)
    ord[4]=maximum(h)
    
    
    
    j=1
    for i=1:4
        
        if h[i]!= minimum(h) && h[i]!= maximum(h)
            inter[j]=h[i]
       j=j+1
        end
    end
    
    
    if inter[1]<= inter[2]
        ord[2]=inter[1]
        ord[3]=inter[2]
    else
        ord[2]=inter[2]
        ord[3]=inter[1]
    end
    
    
    if (A.centro-A.radio)==ord[1]
        
        if (A.centro+A.radio)==ord[2]
            return 0
            else
            return Bola((ord[2]+ord[3])/2,(ord[3]-ord[2])/2) 
        end
        
        elseif (A.centro-A.radio)==ord[2]
        
        return Bola((ord[2]+ord[3])/2,(ord[3]-ord[2])/2)
        
        elseif (A.centro-A.radio)==ord[3]
        
        return 0
    end

end

function N(X,g,dg,x)
x-(g(x)*(dg(X)^-1))
end




function NOperator(X,g,dg)
m=X.centro
N(X,g,dg,m)
end


function intervalRoot(X,g,dg)
    if (dg(X).centro+dg(X).radio)*(dg(X).centro-dg(X).radio)<0
        X1=Bola((X.centro-X.radio-.0000000000000000000000000000000000001)/2,(-.0000000000000000000000000000000000001-(X.centro-X.radio))/2)
        X2=Bola(X.centro+X.radio/2,(X.centro+X.radio)/2)
    
        
        
         if intersection(X1,NOperator(X1,g,dg))==0
            println("no hay raiz en el intervalo negativo")
         else
         Y=intersection(X1,NOperator(X1,g,dg))
            
         while Y !=0 && (2*Y.radio) > .0000001   
         Y=intersection(Y,NOperator(Y,g,dg))
         end 
            if Y==0
            println("no hay raiz en el intervalo negativo")
            else
            println(Y)
            end
         end
        
        if intersection(X2,NOperator(X2,g,dg))==0
            println("no hay raiz en el intervalo positivo")
        else
        Y=intersection(X2,NOperator(X2,g,dg))
    
        while Y !=0 && (2*Y.radio) > .0000001     
      
        Y=intersection(Y,NOperator(Y,g,dg))
      
        end    
            if Y==0
                println("no hay raiz en el intervalo positivo")
            else
            println(Y)
            end
      
        end
        
   else   
    
    if intersection(X,NOperator(X,g,dg))==0
        println("no hay raiz en el intervalo")
    else
      Y=intersection(X,NOperator(X,g,dg))
    
    while Y !=0 && (2*Y.radio) > .0000001      
      
        Y=intersection(Y,NOperator(Y,g,dg))
      
    end    
              if Y==0
            println("no hay raiz en el intervalo negativo")
            else
                return Y
            end
      
    end
    end
    
end






end 
    
