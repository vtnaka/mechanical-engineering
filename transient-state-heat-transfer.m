%% Exercicio 3: Regime transiente - Implementação das equações pelo método explícito
close all;
clc;
clear;
%% Dados de entrada
%Constantes do meio
p = 7900; %[kg/m³]
c = 477; %[J/kg*K]
k = 15; %[W/m*K]
h = 150; %[W/m²*K]
Tinf = 20; %[K]

%Fluxo de calor e calor gerado
qf = 5000; %[W/m²]
qd = 1.0e5; %[W/m³]

%Parâmetros temporais
t = input('Intervalo de tempo desejado: ');
dt = 0.1;

%Parâmetros da malha
n = input('Número de nós: ');
X = 0.25; %[m]
Y = 0.25; %[m]
dx = X/(n-1);

%Constantes tabeladas
Fo = dt*k/(p*c*dx^2);
Bi = h*dx/k;

%Erro
e = 1.0e-16;
r = 1;

%Parâmetros para o balanço
Eac = 0;
%% Inicialização das matrizes de temperatura
Tp = zeros(n);
Tpp = zeros(n);
%% Valor inicial para as temperaturas
for i = 1:n
    for j = 1:n
        Tp(i,j) = 25;
    end
end
%% Cálculo das temperaturas
if (1 - (4*Fo)) >= 0 && (1 - (Fo*(4 + (4*Bi)))) >= 0 && (1 - (Fo*(4 + (2*Bi)))) >= 0
    while r < t
        Eac = 0;
        for i = 1:n
            for j = 1:n
                if i == 1 && j == 1 %Nó superior esquerdo
                    Tpp(i,j) = (2*Fo)*(Tp(i+1,j) + Tp(i,j+1) + (Bi*Tinf) + (qf*dx/k) +(qd*dx^2/(2*k))) + (Tp(i,j)*(1 - (Fo*(4 + (2*Bi)))));
                    Eac = Eac + (p*c*(dx^2/4)*(Tpp(i,j) - Tp(i,j))/dt);
                elseif i == n && j == 1 %Nó inferior esquerdo
                    Tpp(i,j) = (2*Fo)*(Tp(i-1,j) + Tp(i,j+1) + (Bi*Tinf) + (qf*dx/k) + (qd*dx^2/(2*k))) + (Tp(i,j)*(1 - (Fo*(4 + (2*Bi)))));
                    Eac = Eac + (p*c*(dx^2/4)*(Tpp(i,j) - Tp(i,j))/dt);
                elseif i == 1 && j == n %Nó superior direito
                    Tpp(i,j) = (2*Fo)*(Tp(i,j-1) + Tp(i+1,j) + (2*Bi*Tinf) + (qd*dx^2/(2*k))) + (Tp(i,j)*(1 - (Fo*(4 + (4*Bi)))));
                    Eac = Eac + (p*c*(dx^2/4)*(Tpp(i,j) - Tp(i,j))/dt);
                elseif i == n && j == n %Nó inferior direito
                    Tpp(i,j) = (2*Fo)*(Tp(i,j-1) + Tp(i-1,j) + (2*Bi*Tinf) + (qd*dx^2/(2*k))) + (Tp(i,j)*(1 - (Fo*(4 + (4*Bi)))));
                    Eac = Eac + (p*c*(dx^2/4)*(Tpp(i,j) - Tp(i,j))/dt);
                elseif i ~= 1 && i <= n-1 && j == 1 %Parede esquerda
                    Tpp(i,j) = Fo*(Tp(i-1,j) + Tp(i+1,j) + (2*Tp(i,j+1)) + (2*qf*dx/k) + (qd*dx^2/k)) + (Tp(i,j)*(1 - (4*Fo)));
                    Eac = Eac + (p*c*(dx^2/2)*(Tpp(i,j) - Tp(i,j))/dt);
                elseif i ~= 1 && i <= n-1 && j == n %Parede direita
                    Tpp(i,j) = Fo*(Tp(i-1,j) + Tp(i+1,j) + (2*Tp(i,j-1)) + (2*Bi*Tinf) + (qd*dx^2/k)) + (Tp(i,j)*(1 - (Fo*(4 + (2*Bi)))));
                    Eac = Eac + (p*c*(dx^2/2)*(Tpp(i,j) - Tp(i,j))/dt);
                elseif i == 1 && j ~= 1 && j <= n-1 %Parede superior
                    Tpp(i,j) = Fo*(Tp(i,j-1) + Tp(i,j+1) + (2*Tp(i+1,j)) + (2*Bi*Tinf) + (qd*dx^2/k)) + (Tp(i,j)*(1 - (Fo*(4 + (2*Bi)))));
                    Eac = Eac + (p*c*(dx^2/2)*(Tpp(i,j) - Tp(i,j))/dt);
                elseif i == n && j ~= 1 && j <= n-1 %Parede inferior
                    Tpp(i,j) = Fo*(Tp(i,j-1) + Tp(i,j+1) + (2*Tp(i-1,j)) + (2*Bi*Tinf) + (qd*dx^2/k)) + (Tp(i,j)*(1 - (Fo*(4 + (2*Bi)))));
                    Eac = Eac + (p*c*(dx^2/2)*(Tpp(i,j) - Tp(i,j))/dt);
                else %Nós interiores
                    Tpp(i,j) = Fo*(Tp(i+1,j) + Tp(i-1,j) + Tp(i,j+1) + Tp(i,j-1) + (qd*dx^2/k)) + ((1 - (4*Fo))*Tp(i,j));
                    Eac = Eac + (p*c*(dx^2)*(Tpp(i,j) - Tp(i,j))/dt);
                end
            end
        end
        r = r + dt;
        %Balanço de energia
        q1 = ((h*dx/2)*(Tinf - Tp(1,1))) + ((h*dx/2)*(Tinf - Tp(1,n))) + (h*dx*sum(Tinf - Tp(1,2:n-1)));
        q2 = ((h*dx/2)*(Tinf - Tp(1,n))) + ((h*dx/2) * (Tinf - Tp(n,n))) + (h*dx*sum(Tinf - Tp(2:n-1,n)));
        q3 = ((h*dx/2)*(Tinf - Tp(n,1))) + ((h*dx/2) * (Tinf - Tp(n,n))) + (h*dx*sum(Tinf - Tp(n,2:n-1)));
        qfl = qf*Y;
        qdt = qd*X*Y;
        bl = q1 + q2 + q3 + qfl + qdt - Eac;
        display (bl);
        Tp = Tpp;
        %Saída de dados
        a = 0:dx:Y;
        b = 0:dx:X;
        imagesc(a, b, Tp);
        colormap(jet);
        set(gca,'ydir', 'reverse');
        colorbar
        title('Temperatura [°C]');
        xlabel('Posição em X [m]');
        ylabel('Posição em Y [m]');
        pause(1.0e-8);
    end
else
    fprintf('Restriçao numérica');
end
