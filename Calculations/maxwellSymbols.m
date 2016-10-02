clear all
syms E1L E2L E3L H1L H2L H3L real
syms E1R E2R E3R H1R H2R H3R real
EL = [E1L;E2L;E3L];
HL = [H1L;H2L;H3L];

ER = [E1R;E2R;E3R];
HR = [H1R;H2R;H3R];

syms n1 n2 n3 real
n = [n1;n2;n3];

%%
FnL = [ - cross(n,HL); cross(n,EL)];
FnR = [ - cross(n,HR); cross(n,ER)];
JumpFn = FnR - FnL;
FnL == FnR