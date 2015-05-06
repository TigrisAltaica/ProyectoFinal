module Bola

export Bola

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
    

function contiene(B::Bola,x)

    if distancia(B.centro,x)<= B.radio
        return(true)
    else
        return(false)
    end
     
end

function +(A::Bola,B::Bola)
    
    return(Bola(A.centro+B.centro,A.radio+B.radio))
end

function +(A::Bola,c)
    
    return(Bola(A.centro+c,A.radio))
end

function +(c,A::Bola)
    
    return(Bola(A.centro+c,A.radio))
end

function -(A::Bola,B::Bola)
    
    return(Bola(A.centro-B.centro,A.radio+B.radio))
end

function +(A::Bola,B::Bola)
    
    return(Bola(A.centro+B.centro,A.radio+B.radio))
end

function -(A::Bola,c)
    
    return(Bola(A.centro+c,A.radio))
end

function -(c,A::Bola)
    
    return(Bola(A.centro-c,A.radio))
end   

end 
    
