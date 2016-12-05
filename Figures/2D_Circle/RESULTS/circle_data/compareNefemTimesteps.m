for iH=3:5
    figure
    a = load(sprintf('nefem/half_timestep/H%d_p2_TM_conv.mat',iH));
    b = load(sprintf('nefem/H%d_p2_TM_conv.mat',iH));
    
    plot(log10(a.freqConv.T),log10(a.freqConv.freq{1,1}.error))
    hold all
    plot(log10(b.freqConv.T),log10(b.freqConv.freq{1,1}.error))
    title(iH);
end