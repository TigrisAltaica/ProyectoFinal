module BolasTest

using Bolas, FactCheck

facts("Prueba básicas de Bolas:") do
	
    @fact Bola(1) => Bola(1,1)
    @fact Bola(2,-2) => Bola(2,2)
    
end

facts("Pruebas de funciones para bolas :") do
        
    A = Bola(0,1)
    B = Bola(1,2)
    C = Bola(0,.1)
    
    @fact contiene(C,.1) => true 
    @fact contiene(A,A.centro) => true
    @fact contiene(A,A.centro+A.radio) => true
    @fact contiene(A,A.centro-A.radio) => true
    @fact contiene(A,A.centro+2*A.radio) => false
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
    
    @fact contiene(B/C,(B.centro+B.radio)/(C.centro-C.radio)) => true
    @fact contiene(B/C,(B.centro-B.radio)*(C.centro+C.radio)) => true

    
end

end
