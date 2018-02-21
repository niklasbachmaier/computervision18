function G = gaussianFilter( sigma )
    L=ceil(3*sigma);
    G = 1/sigma*(sqrt(pi*2))*exp(-(-L:L).^2/(2*(sigma^2)));
    G = G/sum(G);
end


