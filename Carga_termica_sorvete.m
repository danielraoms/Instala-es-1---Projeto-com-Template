clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculando carga térmica de endurecimento do Sorvete de Bacuri         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% CARGA TÉRMICA DO PRODUTO ARMAZENADO

%Propriedades físicas
rho_sorv = 750; % massa específica média dos sorvetes [kg/m^3] 
c_sorv_solid = 1.67; %Calor específico após endurecimento [kJ/kg°C]
c_sorv_liq = 3.1; %Calor específico antes do endurecimento  [kJ/kg°C]


%Características da nossa produção
Vol_sorv_dia = 100; %Litros diários
m_sorv_dia = Vol_sorv_dia*(10^(-3))*rho_sorv; % Massa [kg] de sorvete
%admitida diariamente na câmara

Vol_sorv_tot = 1000; %Litros armazenados no total
m_sorv_tot = Vol_sorv_tot*(10^(-3))*rho_sorv; %Massa total [kg]


% Assumindo um congelador contínuo
T_e = -6; %°C na saída do congelador e entrando na etapa de endurecimento
T_s = -20; %°C temperatura de estabilização para distribuição do sorvete


% Calor que deve ser retirado dos 100L de sorvete [kJ]
Q_resf = m_sorv_dia*c_sorv_liq*(T_e - T_s); 
Q_resf = Q_resf*1000; % Convertentdo para [J]

% CALCULANDO TEMPO DE RESFRIAMENTO

%Dimensões da caixa
D_caixa = 0.23; %DiÂmetro das caixas [m]
h_caixa = 0.25; %Altura das caixas [m]
A_lat_caixa = h_caixa*pi*D_caixa; %Área lateral das caixas [m2]


% Assumindo ventilação com:
v = 5.77; % [m/s]
rho_ar = 1.447; % [kg/m3] a -30°C e 1atm
mi_ar = 15.88; %viscosidade dinâmica [Ns/m2*10^-6]
Re_Cil = rho_ar*v*D_caixa/(mi_ar/(10^(6))); %Reynolds do cilindro
T_ar = -30; %[ºC] ar de circulação na câmara fria


% Numero de Nusselt para Re_CiL ~ 20000
Pr = 0.717; %N# de Prandtl para o ar a 1atm e -30º
Nu_Cil = 0.193*(Re_Cil^0.618)*Pr^(1/3); %Número de nusselt no cilindro em 
%escoamento cruzado


% Coeficiente de Transferência de calor H
k_caixa = 0.21; % Condutividade térmica do papelão [W/mK]
k_plastic = 0.19; % Condutividade do PVC (filme plástico)
k_eq = (1/k_caixa + 1/k_plastic)^(-1); %Condutivdade equivalente
h_Cil = Nu_Cil*k_eq/D_caixa; %Coeficiente de transferência de calor por 
%convecção forçada [W/m2K]
q_flux = h_Cil*A_lat_caixa*2.5*abs(T_e-T_ar);%Fluxo de calor por 
%convecção [W]

t_resf = (Q_resf/q_flux)/3600; %Tempo de resfriamento [horas]

%% CARGA TÉRMICA DEVIDO A TRANSMISSÃO


%% CARGA TÉRMICA POR INFILTRAÇÃO
H_porta = 2; %altura da porta
A_porta = 2*1.7; %area da porta
h_i = 61; %kJ/kg
h_r = -29; %kJ/kg
g = 9.81; %Gravidade
rho_r = 1.447; %massa específica do ar refrigerado
rho_i = 1.2; %massa específica do ar de infiltração
F_m = (2/(1+(rho_r/rho_i)^(1/3)))^(1.5); %fator de densidade
q_inf = 0.221*A_porta*(h_i - h_r)*rho_r*((1-(rho_i/rho_r))^0.5)...
    *((g*H_porta)^0.5)*F_m;
P = 2; %
teta_p = 15; %tempo de abertura/fechamento
teta_o = 180; %tempo q a porta permanece aberta
Dt = P*(teta_p + teta_o)/(3600*24);
Df = 1;
E = 0.93; %cortina de plástico
Q_inf = q_inf*Dt*Df*(1-E) % [kW]

%% CARGA TÉRMICA POR ILUMINAÇÃO
W_i = 10; %[W/m2] taxa de iluminação padrão em câmaras frigoríficas
A_p = 1.85*3; % [m2] area do piso da câmara fria
Dto = 1/96; %tempo de utilização
Q_ilu = W_i*A_p*Dto % [W]

%% Carga por Ocupação

N_p = 2; %Pessoas dentro
T_i = -30; % temperatura interna[°C]
Q_eq = 272 - 6*(T_i); %Calor de equipamentos
Q_ocup= N_p*Q_eq*Dto % [W] calor total
