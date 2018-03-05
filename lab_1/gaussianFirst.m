function Gd = gaussianFirst(G,sigma)

    L=ceil(3*sigma);
    
    multiplTerm = ((-L:L)/(sigma^2))./sigma^4;
    
    Gd = multiplTerm .* G;

end