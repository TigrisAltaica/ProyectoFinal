module BolasTest

using Bolas, FactCheck

facts("Prueba básicas de Bolas:") do
	
    @fact Bola(1) => Bola(1,1)
    @fact Bola(2,-2) => Bola(2,2)
    
end

facts("Pruebas de funciones para bolas:") do
        
    A = Bola(0,1)
    B = Bola(1,2)
    C = Bola(0,.1)
    
    @fact contiene(C,.1) => true 
    @fact contiene(A,A.centro) => true
    @fact contiene(A,A.centro+A.radio) => true
    @fact contiene(A,A.centro-A.radio) => true
    @fact contiene(A,A.centro+2*A.radio) => false
    @fact contiene(B,A)=>true
    @fact contiene(A,A)=>true
    @fact distancia(A.centro,A.centro+A.radio) => A.radio
    @fact distancia(A,B) => 1
    
    
    
    
end

facts("Prueba básicas de aritmética:") do
    
        
    A = Bola(0,1)
    B = Bola(1,2)
    C = Bola(5,.2)  
    
    @fact A+B => Bola(1,3)
    @fact A+B => B+A
    @fact A+3 => Bola(A.centro+3,A.radio)
    @fact 3+A => A+3
    
    @fact A-B => Bola(-1,3)
    @fact B-A => Bola(1,3)
    @fact A-3 => Bola(A.centro-3,A.radio)
    @fact 3-A => Bola(3-A.centro,A.radio)
    
    @fact 1*A => A
    @fact 2*B => B*2
    @fact 0*A => Bola(0,0)
    
    @fact A*B => B*A
    @fact contiene(A*B,(A.centro+A.radio)*(B.centro+B.radio)) => true
    @fact contiene(A*B,(A.centro-A.radio)*(B.centro-B.radio)) => true
    
    @fact contiene(B/C,(B.centro+B.radio)/(C.centro+C.radio)) => true
    @fact contiene(B/C,(B.centro+B.radio)/(C.centro-C.radio)) => true
    @fact contiene(B/C,(B.centro-B.radio)/(C.centro+C.radio)) => true

    @fact contiene(B/C,(B.centro-B.radio)/(C.centro-C.radio)) => true


    
end

facts("Pruebas de funciones elementales:") do
    
    A=Bola(5,1)
    E=Bola(.5,.1)
    
    @fact contiene(sin(E),sin(.6)) => true
    @fact contiene(sin(E),sin(.5)) => true
    @fact contiene(sin(E),sin(.4)) => true
    @fact contiene(cos(E),cos(.599999999999)) => true
    @fact contiene(cos(E),cos(.5)) => true
    @fact contiene(cos(E),cos(.4)) => true
    @fact contiene(tan(E),tan(.6)) => true
    @fact contiene(tan(E),tan(.5)) => true
    @fact contiene(tan(E),tan(.4)) => true
    @fact contiene(cot(E),cot(.6)) => true
    @fact contiene(cot(E),cot(.5)) => true
    @fact contiene(cot(E),cot(.4)) => true
    @fact contiene(sec(E),sec(.6)) => true
    @fact contiene(sec(E),sec(.5)) => true
    @fact contiene(sec(E),sec(.4)) => true
    @fact contiene(csc(E),csc(.6)) => true
    @fact contiene(csc(E),csc(.5)) => true
    @fact contiene(csc(E),csc(.4)) => true
    
    @fact contiene(asin(E),asin(.6)) => true
    @fact contiene(asin(E),asin(.5)) => true
    @fact contiene(asin(E),asin(.4)) => true
    @fact contiene(acos(E),acos(.6)) => true
    @fact contiene(acos(E),acos(.5)) => true
    @fact contiene(acos(E),acos(.4)) => true
    @fact contiene(atan(E),atan(.6)) => true
    @fact contiene(atan(E),atan(.5)) => true
    @fact contiene(atan(E),atan(.4)) => true
    @fact contiene(acot(E),acot(.6)) => true
    @fact contiene(acot(E),acot(.5)) => true
    @fact contiene(acot(E),acot(.4)) => true
    @fact contiene(asec(A),asec(6)) => true
    @fact contiene(asec(A),asec(5)) => true
    @fact contiene(asec(A),asec(4)) => true
    @fact contiene(acsc(A),acsc(6)) => true
    @fact contiene(acsc(A),acsc(5)) => true
    @fact contiene(acsc(A),acsc(4)) => true
    
    @fact contiene(sinh(E),sinh(.6)) => true
    @fact contiene(sinh(E),sinh(.5)) => true
    @fact contiene(sinh(E),sinh(.4)) => true
    @fact contiene(cosh(E),cosh(.6)) => true
    @fact contiene(cosh(E),cosh(.5)) => true
    @fact contiene(cosh(E),cosh(.4)) => true
    @fact contiene(tanh(E),tanh(.6)) => true
    @fact contiene(tanh(E),tanh(.5)) => true
    @fact contiene(tanh(E),tanh(.4)) => true
    @fact contiene(coth(E),coth(.6)) => true
    @fact contiene(coth(E),coth(.5)) => true
    @fact contiene(coth(E),coth(.4)) => true
    @fact contiene(sech(E),sech(.6)) => true
    @fact contiene(sech(E),sech(.5)) => true
    @fact contiene(sech(E),sech(.4)) => true
    @fact contiene(csch(E),csch(.6)) => true
    @fact contiene(csch(E),csch(.5)) => true
    @fact contiene(csch(E),csch(.4)) => true
   
    @fact contiene(exp(E),exp(.6)) => true
    @fact contiene(exp(E),exp(.5)) => true
    @fact contiene(exp(E),exp(.4)) => true
    @fact contiene(log(E),log(.6)) => true
    @fact contiene(log(E),log(.5)) => true
    @fact contiene(log(E),log(.4)) => true
  
   

end

facts("Pruebas de funciones avanzadas:") do
    
        
    A = Bola(0,1)
    B = Bola(1,2)
    C = Bola(5,.2)  
    D = Bola(5,3)
    
    @fact bisectar_bolas([A]) => [Bola(-.5,.5),Bola(.5,.5)]
    @fact bisectar_bolas(bisectar_bolas([A])) => [Bola(-.75,.25),Bola(-.25,.25),Bola(.25,.25),Bola(.75,.25)]
    @fact interseccion_de_bolas(A,A)=>A
    @fact interseccion_de_bolas(A,B)=>A
    @fact interseccion_de_bolas(B,A)=>A
    @fact interseccion_de_bolas(B,C)=>nothing
    @fact interseccion_de_bolas(B,D)=>Bola(2.5,.5)
    @fact interseccion_de_bolas(D,B)=>interseccion_de_bolas(B,D)
    @fact revisar_cercanas(B,[C],4)=>true
    @fact revisar_cercanas(B,[C],3.9)=>false
    @fact quitar_repetidas([Bola(-.7,.25),Bola(-.6,.25),Bola(.4,.25),Bola(.5,.25)],.1)=>[Bola(-.7,.25),Bola(.4,.25)]
    @fact quitar_repetidas([Bola(-.7,.25),Bola(-.6,.25),Bola(.4,.25),Bola(.5,.25)],1.1)=>[Bola(-.7,.25),Bola(.5,.25)] 
    f(x)=(x^2)-(x)
    @fact quitar_no_deseadas(f,bisectar_bolas([Bola(1,1)]),0)=>[Bola(1.5,.5)]
    g(x)=(x^2)-(2)
    @fact quitar_no_utiles(g,bisectar_bolas([Bola(1,1)]),0)=>[Bola(1.5,.5)]

end

end
