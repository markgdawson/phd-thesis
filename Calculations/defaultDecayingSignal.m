function sig = defaultDecayingSignal()
    amplitude = 5;
    omega = 1;
    T=100000;
    dt = 1;
    decayConst = 1000;
    sig = buildDecayingSignal(amplitude,omega,T,dt,decayConst);
end