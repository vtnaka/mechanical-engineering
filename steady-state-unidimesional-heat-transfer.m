%% Exercício: Aula 1 - Rede Nodal
clc;
clear;
%% Entrada de dados
qf = 5000; %[W/m²]
n = input('Número de nós:');
h = 150; %[W/m²K]
Tinf = 20; %[°C]
qd = 1.0e5; %[W/m³]
k = 15; %[W/mK]

T = zeros(n);
T1 = zeros(n);
r = 1;

X = 0.25; %[m]
Y = 0.25; %[m]
dx = X/(n-1);
e = 1.0e-16;
%% Chute inicial do campo de temperatura
for i = 1:n
    for j = 1:n
        T(i,j) = Tinf;
    end
end
%% Cálculo das temperaturas, atualização e armazenamento das temperaturas da iteração anterior
while r > e
    for i = 1:n
        for j = 1:n
            if i == 1 && j == 1 % Nó superior esquerdo
                T1(i,j) = (T(i+1,j) + T(i,j+1) + ((h*dx*Tinf)/k) + (qf*dx/k) + ((qd*dx^2)/(2*k)))/(2 + (h*dx/k));
            elseif i == 1 && j == n % Nó superior direito
                T1(i,j) = (T(i,j-1) + T(i+1,j) + (2*h*dx*Tinf/k) + ((qd*dx^2)/(2*k)))/(2 + (2*h*dx/k));
            elseif i == n && j == 1 % Nó inferior esquerdo
                T1(i,j) = (T(i-1,j) + T(i,j+1) + (h*dx*Tinf/k) + (qf*dx/k) + ((qd*dx^2)/(2*k)))/(2 + (h*dx/k));
            elseif i == n && j == n % Nó inferior direito
                T1(i,j) = (T(i,j-1) + T(i-1,j) + (2*h*dx*Tinf/k) + ((qd*(dx^2))/(2*k)))/(2 + (2*h*dx/k));
            elseif i == 1 && j ~= 1 && j <= (n-1) % Parede superior
                T1(i,j) = (T(i,j-1) + T(i,j+1) + (2*T(i+1,j)) + (2*h*dx*Tinf/k) + (qd*dx^2)/k)/(4 + (2*h*dx/k));
            elseif i == n && i ~= 1 && j ~= 1 && j <= n % Parede inferior
                T1(i,j) = (T(i,j-1) + T(i,j+1) + (2*T(i-1,j)) + (2*h*dx*Tinf/k) + (qd*dx^2)/k)/(4 + (2*h*dx/k));
            elseif i ~= 1 && i <= (n-1) && j == 1 % Parede esquerda
                T1(i,j) = (T(i-1,j) + T(i+1,j) + (2*T(i,j+1)) + (2*qf*dx/k) + (qd*dx^2)/k)/4;
            elseif i ~= 1 && i <= (n-1) && j == n % Parede direita
                T1(i,j) = (T(i-1,j) + T(i+1,j) + (2*T(i,j-1)) + (2*h*dx*Tinf/k) + (qd*dx^2)/k)/(4 + (2*h*dx/k));
            else % Nós interiores
                T1(i,j) = (T(i-1,j) + T(i+1,j) + T(i,j+1) + T(i,j-1) + ((qd*dx^2)/k))/4;
            end
        end
    end
    r = max(max(abs(T1 - T)));
    T = T1;
end
%% Saída de dados
a = 0:dx:Y;
b = 0:dx:X;
imagesc(a,b,T);
colormap(jet);
set(gca,'ydir','reverse');
colorbar
title('Temperatura [°C]');
xlabel('Posição em X [m]');
ylabel('Posição em Y [m]');
%% Balanço de energia
q1 = ((h*dx/2)*(Tinf - T(1,1))) + ((h*dx/2)*(Tinf - T(1,n))) + (h*dx*sum(Tinf - T(1,2:n-1)));
q2 = ((h*dx/2)*(Tinf - T(1,n))) + ((h*dx/2) * (Tinf - T(n,n))) + (h*dx*sum(Tinf - T(2:n-1,n)));
q3 = ((h*dx/2)*(Tinf - T(n,1))) + ((h*dx/2) * (Tinf - T(n,n))) + (h*dx*sum(Tinf - T(n,2:n-1)));
qfl = qf*Y;
qdt = qd*X*Y;
balanco = q1 + q2 + q3 + qfl + qdt;
display (balanco);
