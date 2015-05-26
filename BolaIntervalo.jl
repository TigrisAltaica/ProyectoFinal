module BolaIntervalo

using Intervals, Bolas

export bola_a_intervalo,intervalo_a_bola

function bola_a_intervalo(B::Bola)
    
    return(Interval(B.centro+B.radio,B.centro-B.radio))
    
end

function intervalo_a_bola(I::Interval)
    
    return Bola(.5*(I.a+I.b),.5*distancia(I.b,I.a))
    
end

end
