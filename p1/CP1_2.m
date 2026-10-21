% CASO PRÁCTICO 2 - TRATAMIENTO DE RUIDO
% CÓDIGO 2: PROMEDIADO SINCRONIZADO

clc
clear all
close all

% Cargamos la señal de MEG.
meg = importdata ( 'MEG_CP1.mat' );

% Definimos la frecuencia de muestreo y el vector de tiempos (en ms).
fs = 678.17;
t  = (-26:93);

% Selecciona únicamente el sensor 78.
s78 = squeeze(meg(78,:,:));

% Calcula el promedio de todas las épocas para el sensor seleccionado.
p78 = mean(transpose(s78));


% Dibujamos la señal de todas las épocas.
figure
subplot ( 1, 2, 1 )
hold on
plot ( t, s78, 'k' );
axis tight;

% Superponemos el promedio, en rojo.
plot ( t, p78', 'r', 'LineWidth', 2 );
title ( 'Épocas individuales y promedio' )

% Dibujamos una nueva figura mostrando únicamente el promedio.
subplot ( 1, 2, 2 )
plot ( t, p78', 'k', 'LineWidth', 2 )
title ( 'Campo evocado visual' )
axis tight;
grid
