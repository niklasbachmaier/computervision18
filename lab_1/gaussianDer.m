function Gd = gaussianDer(G,sigma)

    L=ceil(3*sigma);
    
    multiplTerm = -((-L:L)/(sigma^2));
    
    multiplMatrix = diag(multiplTerm);
    
    Gd = multiplMatrix * transpose(G)


end