function doPhasing(sig)

% conclusion - regardless of phase, the absolute value is always the
% same....

if(nargin==0)
    sig = defaultDecayingSignal;
end
    

F_noPhase = fft(sig.amplitude);

% phase
    
phi = 0;

f = figure;
ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);
xrange=1.4*10^4:1.8*10^4;
hold all
F = F_noPhase.*exp(1i*phi);
Freal = real(F);
Fimag = imag(F);
Fabs = abs(F);
Fangle = angle(F);
h_real = plot(xrange,Freal(xrange),'r-','displayName','real');
h_imag = plot(xrange,Fimag(xrange),'b-','displayName','imag');
h_abs = plot(xrange,Fabs(xrange),'g-','displayName','imag');
h_angle = plot(xrange,Fangle(xrange),'k-','displayName','imag');

% build UI control slider
b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',phi, 'min',0, 'max',2*pi);
bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                'String','0','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
                'String','2pi','BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
                'String','Phase','BackgroundColor',bgcolor);
            
%b.Callback = @(es,ed) replotPhase(es.Value); - synchronous
addlistener(b,'ContinuousValueChange',@(hObject, event) replotPhase(hObject, event));

[minF,maxF] = minMaxAmplitude(F_noPhase);
ylim([minF,maxF]);

function replotPhase(hObject, event)
    phi = get(hObject,'Value');
    F = F_noPhase.*exp(1i*phi);
    Freal = real(F);
    Fimag = imag(F);
    Fabs = abs(F);
    Fangle = angle(F);
    
    h_real.YData = Freal(xrange);
    h_abs.YData = Fabs(xrange);
    h_imag.YData = Fimag(xrange);
    h_angle.YData = Fangle(xrange);
    
    title(sprintf('phi = %g',phi));
end

function [minF,maxF] = minMaxAmplitude(F_noPhase)
    nPhases = 1000;
    phases = linspace(0,2*pi,nPhases);
    minF = Inf;
    maxF = - Inf;
    
    for iPhase=1:nPhases
        F = F_noPhase.*exp(1i*phases(iPhase));
        arr = [real(F),imag(F)];
        maxF = max([maxF,arr]);
        minF = min([minF,arr]);
    end
end

function [minF,maxF] = maxNumBelowTheshold(F_noPhase)
    nPhases = 1000;
    phases = linspace(0,2*pi,nPhases);
    minF = Inf;
    maxF = - Inf;
    
    for iPhase=1:nPhases
        F = F_noPhase.*exp(1i*phases(iPhase));
        arr = [real(F),imag(F)];
        maxF = max([maxF,arr]);
        minF = min([minF,arr]);
    end
end

end