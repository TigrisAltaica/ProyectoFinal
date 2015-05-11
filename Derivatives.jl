
module Derivatives

import Base.==, Base.contains, Base.^, Base.exp, Base.log, Base.sin, Base.cos, Base.tan


export Derive,makex, +,-,*,/, ==,^,GetFunctionValue,GetDerivativeValue





type Derive
    
    f
    d  
end

Derive(f) = Derive(f,0)

#Redefino las operaciones aritméticas siguiendo las convenciones de arriba


function +(v::Derive,w::Derive)
    
    return(Derive(v.f+w.f,v.d+w.d))
   
end

function +(v::Real,w::Derive)
    
    v=Derive(v)
    
    return(Derive(v.f+w.f,v.d+w.d))

end

function +(w::Derive,v::Real)
    
    v=Derive(v)
    
    return(Derive(v.f+w.f,v.d+w.d))
end



function -(v::Derive,w::Derive)
    
	return(Derive(v.f-w.f,v.d-w.d))
end

function -(v::Real,w::Derive)
 
    v=Derive(v)
    return(Derive(v.f-w.f,v.d-w.d))

end

function -(w::Derive,v::Real)
    
    v=Derive(v)
    
    return(Derive(w.f-v.f,w.d-v.d))
end

function *(v::Derive,w::Derive)
    
    return(Derive(v.f*w.f,v.d*w.f+v.f+w.d))

end

function *(c::Real,v::Derive)
    
    return(Derive(v.f*c,v.d*c))

end

function *(v::Derive,c::Real)
    
    return(Derive(v.f*c,v.d*c))

end


function /(v::Derive,w::Derive)
    
    return(Derive(v.f/w.f,(v.d*w.f-w.d*v.f)/(w.f)^2))
    
end

function ^(v::Derive,c::Real)
    
    return(Derive( v.f^c,c*(v.f^(c-1.0))*v.d))

end

function ^(v::Derive,c::Integer)
    
    return(Derive( v.f^c,c*(v.f^(c-1))*v.d))

end


function makex(x)
    
    y = Derive(x,1)
end


#Ahora redefino las funciones trigonométricas etc para que funciones con mi nuevo tipo

function Base.sin(v::Derive)
    
    return(Derive(sin(v.f),-cos(v.f)*v.d))
    
end

function Base.cos(v::Derive)
    
    return(Derive(cos(v.f),sin(v.f)*v.d))
  
end

function Base.tan(v::Derive)
     
    return(Derive(tan(v.f),v.d*sec(v.f)^2))
    
end   

function Base.exp(v::Derive)
    
    return(Derive(exp(v.f),v.d*exp(v.f)))
    
end

function Base.log(v::Derive)
     
    return(Derive(log(v.f),v.d/(v.f)))

end  

function ==(v::Derive,w::Derive)
	
	(v.f == w.f) && (v.d == w.d)

end

function GetFunctionValue(f::Function,x)
	
	return(f(makex(x)).f)
end

function GetDerivativeValue(f::Function,x)
	
	return(f(makex(x)).d)
end

end 
