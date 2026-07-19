function y = tclabsim(t, x0, u, p)
% TCLABSIM Simula o modelo não-linear do TCLab a partir de parâmetros fornecidos.
%   y = tclabsim(t, x0, u, p) retorna a temperatura simulada do sensor TS em ºC.

% Despacotar os parâmetros do vetor 'p'
U     = p(1);    
alpha = p(2);    
tau   = p(3);    

% Definir as condições iniciais e parâmetros nominais restantes
TA_C = x0;          
TA   = TA_C + 273.15;

m     = 0.004;      
Cp    = 500;        
A     = 1e-3;      
eps   = 0.9;        
sigma = 5.67e-8;    

% Preparar as entradas para o Simulink
Q_input = [t(:), u(:)];
t_final = t(end);

% Executar a simulação no Workspace corrente
simOut = sim('tclab_model.slx', 'SrcWorkspace', 'current', 'StopTime', num2str(t_final));

% Extrair e tratar a saída do sensor (TS em ºC)
try
    y_sim = simOut.Ts_Celsius.Data;
catch
    y_sim = simOut.yout.get('Ts_Celsius').Values.Data;
end

% Interpola os dados para garantir o alinhamento perfeito com o vetor de tempo t
y_interp = interp1(simOut.tout, y_sim, t, 'linear', 'extrap');

% ATENÇÃO: Transforma o vetor em vetor LINHA para casar com o lsqcurvefit
y = y_interp(:)';
end