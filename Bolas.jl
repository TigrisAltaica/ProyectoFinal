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
    
    return(Bola(A.centro/B.centro,UpSum(UpProd(norma(A.centro)+A.radio,B.radio),UpProd(norma(B.centro),A.radio))))
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
return Bola(sin(A.centro),sin(A.centro)*(cos(A.radio)-1)+sin(A.radio)*cos(A.centro))
end

function cos(A::Bola)
return Bola(cos(A.centro),(cos(A.radio)-1)*cos(A.centro)+sin(A.radio)*sin(A.centro))
end

function exp(A::Bola)

return Bola(exp(A.centro),exp(A.centro)*(cosh(A.radio)+sinh(A.radio)-1))
end

function log(A::Bola)
return Bola(log(A.centro),log(A.centro/(A.centro-A.radio)))
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
    
