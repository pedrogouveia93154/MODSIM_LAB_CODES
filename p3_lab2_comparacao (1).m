clear;
clc;

load('openloop_data_final.mat');

% Extração das matrizes guardadas pelo script do laboratório
Ts_real = y(1,:); % Temperatura do Sensor 1 [ºC]
Q_real  = u(1,:); % Sinal de Potência aplicado ao Aquecedor 1 [%]

TA_C = Ts_real(1);   % Deteta automaticamente a temperatura inicial (Ex: 27ºC)
TA = TA_C + 273.15;   % Conversão para Kelvin
x0 = TA;             % Condição inicial para T e Ts no Simulink

% Parâmetros Nominais Teóricos

m = 0.004; %massa em kg
Cp = 500; %Capacidade termica
A = 1e-3; %Area da superficie
U = 4.4; %Coeficiente de transferencia
eps = 0.9; %Emissividade
sigma = 5.67e-8; %cte. de boltzmann
alpha = 0.0131; %fator de aquecimento
tau = 21.1; %cte de atraso do sensor


% Alinha o vetor de entrada do Simulink com o tempo e perfil de degraus do lab[cite: 1]
Q_input = [t(:), Q_real(:)];


disp('A simular o modelo Simulink com o perfil real...');
out = sim('tclab_model');

% Tenta extrair a resposta do sensor calculada pelo Simulink
try
    sim_Ts = out.Ts_Celsius.Data;
catch
    sim_Ts = out.yout.get('Ts_Celsius').Values.Data;
end

%plot dos dois graficos, simulado e real
fig = figure;
fig.Color = 'w'; % Fundo branco limpo para impressão

% Curva 1: Dados Reais da bancada do laboratório[cite: 1]
plot(t, Ts_real, 'k-', 'LineWidth', 1.2);
hold on;

% Curva 2: A tua Simulação do Simulink
plot(out.tout, sim_Ts, 'b--', 'LineWidth', 2);

% Configurações estéticas e legendas
grid on;
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.4);
xlabel('Tempo [s]', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Temperatura [ºC]', 'FontSize', 11, 'FontWeight', 'bold');
title('Validação do Modelo: Perfil Dinâmico Real vs. Simulação Simulink', 'FontSize', 12, 'FontWeight', 'bold');
legend('Experimento Real (Bancada)', 'Simulação Teórica (Simulink)', 'Location', 'best');

% Exportar a imagem em alta resolução diretamente para o Word/PDF
exportgraphics(fig, 'tclab_validacao_final.png', 'Resolution', 300);
disp('Sucesso! O gráfico sobreposto foi guardado como "tclab_validacao_final.png".');