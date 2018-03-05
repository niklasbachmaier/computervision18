function Gd = gaussianSec(G,sigma)

L=ceil(3*sigma);

multiplTerm = -((-L:L).^2 - sigma^2);

Gd = multiplTerm .* G;

end