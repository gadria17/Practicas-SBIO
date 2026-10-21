% CASO PRÁCTICO 1 - TRATAMIENTO DE RUIDO
% CÓDIGO 1: FILTRADO EN FRECUENCIA

clc
clear all
close all

%% Carga y representación de la señal 
load ('ECG_CP1');
s = val;
fs = 500;
t = (1:length(s))/fs;
% 
% % Calculamos la transformada de Fourier de la señal.
S  = periodogram (s, [], 2000, fs);
S  = S ( 1: 1000 );
S  = S / max ( S );
% Generamos el vector de frecuencias.
w  = linspace ( 0, pi, 1000 );
f  = w * ( fs / 2 ) / pi;
% % Representamos la señal en el tiempo
figure(1);
ax1 = subplot(2,1,1);
plot    ( ax1, t, s,  'k', 'LineWidth', 2 );
        xlabel  ( 'Tiempo (s)' )
        xlim    ( [ min( t ) max( t ) ] )
        ylabel  ( 'Amplitud' )
        title   ( 'Señal temporal' )
        legend  ( 'Señal original', 'Señal filtrada' )


% % Representamos el espectro de la señal
ax2 = subplot(2,1,2);
plot    ( ax2, f, S,  'k', 'LineWidth', 2 );
        xlabel  ( 'Frecuencia (Hz)' )
        xlim    ( [ 0 fs/2 ] )
        ylim    ( [ 0 .1 ] )
        ylabel  ( 'Magnitud' )
        title   ( 'Butterworth' )
        legend  ( 'Filtro', 'Señal original' );

%% Filtrado de la señal        
% Bucle infinito para seleccionar el filtro deseado.

while true
    
    clc;
    close all;
    
    % Inicializamos las variables.
    colors = [ 'g' 'b' 'k' 'r' ];
%     ftypes = { 'Butterworth' 'Chebyshev tipo 1' 'Chebyshev tipo 2' 'ElÃ­ptico' };
    
    
    fprintf ( 1, 'Tipos de filtro disponibles:\n\n' );
    fprintf ( 1, '  (1) Filtro paso-bajo.\n' );
    fprintf ( 1, '  (2) Filtro paso-alto.\n' );
    fprintf ( 1, '  (3) Filtro paso-banda.\n' );
    fprintf ( 1, '  (4) Filtro elimina-banda.\n\n' );
    
    nfilter = input ( 'Escriba el número del filtro deseado o cero (0) para salir: ' );
    
    % Comprobamos que el valor introducido es vÃ¡lido.
    if nfilter == 0
        fprintf ( 1, '\nEl programa ha finalizado.\n' );
        return
    end
    
    if nfilter ~= 1 && nfilter ~= 2 && nfilter ~= 3 && nfilter ~= 4
        fprintf ( 1, '\nHa seleccionado una opción no válida.\n' );
        continue
    end
    
    % Seleccionamos el filtro deseado.
    if nfilter == 1
        option = 'low';
        Filtro = 'paso-bajo';
        
    elseif nfilter == 2
        option = 'high';
        Filtro = 'paso-alto';
        
    elseif nfilter == 3
        option = 'bandpass';
        Filtro = 'paso-banda';
        
    elseif nfilter == 4
        option = 'stop';
        Filtro = 'elimina-banda';
    end
        
    % Obtenemos los parÃ¡metros comunes.
    fprintf ( 1, '\nEscriba las características del filtro a construir.\n' );
    N    = input ( '- Orden del filtro: ' );
%     fs   = input ( '- Frecuencia de muestreo: ' );
    
    % Obtenemos la(s) frecuencia(s) de corte del filtro.
    switch nfilter
        case { 1 2 }
            fc     = input ( ['- Frecuencia de corte (entre 0 y ', num2str( fs / 2 ),'): ' ] );
            
        case { 3 4 }
            fc (1) = input ( [ '- Frecuencia de corte inicial (entre 0 y ', num2str( fs / 2 ), '): ' ] );
            fc (2) = input ( [ '- Frecuencia de corte final (entre ', num2str(fc (1)), ' y ', num2str( fs / 2 ), '): ' ] );
    end
    
    % Obtenemos la frecuencia normalizada.
    wn = fc / ( fs / 2 );
    
    % Obtenemos los parÃ¡metros de rizado.
    disp ( '' )
%     R1p = input ( '- Rizado en la banda de paso (Chebyshev 1): ' );
%     R2s = input ( '- AtenuaciÃ³n en la banda eliminada (Chebyshev 2): ' );
%     Rp  = input ( '- Rizado en la banda de paso (ElÃ­ptico): ' );
%     Rs  = input ( [ '- AtenuaciÃ³n en la banda eliminada (ElÃ­ptico) (>', num2str(Rp), '): ' ] );
    
    
    % Creamos las figuras para cada tipo de filtro.
    for ftype = 1: 1
        
        % DiseÃ±amos el filtro.
        switch ftype
            case 1, [ b, a ] = butter ( N, wn, option );
            case 2, [ b, a ] = cheby1 ( N, R1p, wn, option );
            case 3, [ b, a ] = cheby2 ( N, R2s, wn, option );
            case 4, [ b, a ] = ellip  ( N, Rp, Rs, wn, option );
        end
        
        % Filtramos la seÃ±al con el filtro actual.
        sf = filter ( b, a, s );
        
        
        % Calculamos la respuesta del filtro.
        H  = freqz  ( b, a, w );
        
        % Obtenemos la respuesta en fase (p) y ganancia (g).
        p  = unwrap ( angle ( H ) ) / pi;
        g  = abs ( H );
        G  = 20 * log10 ( g );
              
        % Dibujamos la seÃ±al antes y despuÃ©s del filtro.
        ax1 = subplot(2,1,1);
        hold(ax1,'on')
        plot    ( ax1, t, s,  'k', 'LineWidth', 2 );
        xlabel  ( 'Tiempo (s)' )
        xlim    ( [ min( t ) max( t ) ] )
        ylabel  ( 'Amplitud' )
        title   ( 'Señal temporal' )
        legend  ( 'Señal original', 'Señal filtrada' )
        plot    ( ax1, t, sf, 'r', 'LineWidth', 2 );
        hold(ax1,'off')

        % Dibujamos el espctro de la seÃ±al y la respuesta del filtro.
        ax2 = subplot(2,1,2);
        hold(ax2,'on')
        plot    ( ax2, f, g,  'g', 'LineWidth', 2 );
        plot    ( ax2, f, S,  'k', 'LineWidth', 2 );
        xlabel  ( 'Frecuencia (Hz)' )
        xlim    ( [ 0 fs/2 ] )
        ylabel  ( 'Magnitud' )
        title   ( 'Butterworth' )
        legend  ( 'Respuesta filtro', 'DEP Señal original' );
        hold(ax2,'off')
        
    end
    
    figure(2); zplane(b, a); title   ( 'Diagrama polos-ceros' )
    
    fprintf ( 1, '\nPulse una tecla para continuar.' );
    
    % Actualizamos la señal de entrada
    s = sf;
    S  = abs ( fft ( s, 2000 ) );
    S  = S ( 1: 1000 );
    S  = S / max ( S );
    
    nchoice = input ( 'Escriba (1) para aplicar un nuevo filtro o cero (0) para salir: ' );
    
    % Seguir o terminar
    if nchoice == 0
        fprintf ( 1, '\nEl programa ha finalizado.\n' );
        return
    end
    
end
