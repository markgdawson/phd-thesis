clear all;
mode = 'TE'
syms mu eps real
syms E1 E2 E3 H1 H2 H3

ATM=cell(2,1);
ATE=cell(2,1);

%TE MODE
ATE{1} = [
    0      0          0;
    0      0          mu^-1;
    0      eps^-1   0;
    ];

ATE{2} = [
    0       0       -mu^-1;    
    0       0       0;
    -eps^-1	0       0;
    ];

UTE = [
    eps*E1;
    eps*E2;
    mu*H3;
    ];

Vn_TE = [
    E1;
    E2;
    H3;
    ];

%TM MODE
ATM{1} = [
    0      0          0;
    0      0          -eps^-1;
    0      -mu^-1   0;
    ];

ATM{2} = [
    0      0          eps^-1;
    0      0          0;
    mu^-1  0          0;
    ];

UTM = [
    mu*H1;
    mu*H2;
    eps*E3;
    ];

Vn_TM = [
    - H1;
    - H2;
    - E3;
    ];

%% normal compoenent
syms n1 n2 real
if(strcmp(mode,'TM'))
    An = n1.*ATM{1} + n2.*ATM{2};
    U = UTM;
    Vn = Vn_TM;
elseif(strcmp(mode,'TE'))
    An = n1.*ATE{1} + n2.*ATE{2};
    U = UTE;
    Vn = Vn_TE;
end

Fn=simplify(An*U);

%% Material interfaces
syms V1 V2 V3
Fn_of_Vn = [
    - n2 * V3;
    n1 * V3;
    n1 * V2 - n2 * V1;
    ];

Fn_altForm = simplify(subs(subs(subs(Fn_of_Vn,'V1',Vn(1)),'V2',Vn(2)),'V3',Vn(3)));

simplify(Fn-Fn_altForm)