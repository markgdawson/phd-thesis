function sig = buildDecayingSignal(amplitude,omega,T,dt,decayConst)
    sig.dt = dt; 
    t=0:sig.dt:T;

    decayTerm = exp(-t./decayConst);

    sig.amplitude = real(amplitude.*exp(1i.*omega.*t).*decayTerm);
end