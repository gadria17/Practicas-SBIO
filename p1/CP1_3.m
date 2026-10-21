% CASO PRÁCTICO 2 - TRATAMIENTO DE RUIDO
% CÓDIGO 3: FILTRADO ADAPTATIVO

% Establecemos la frecuencia de muestreo.
fs = 500;

% Cargamos la señal EEG.
[ data, header ] = readedf ( 'EEG_CP1.edf' );

% Mostramos la lista de canales.
header.channelname

% Seleccionamos los datos entre los segundos 22 y 32.
data = data ( :, 22 * fs + 1: 32 * fs );

% Filtramos la señal en la banda de 1 a 45 Hz.
[ b, a ] = butter ( 2, [ 1 45 ] / ( fs / 2 ) );
data = filtfilt ( b, a, data' )';

% Añadimos un nuevo canal, al final, con el promedio de Fp1 y Fp2.
data ( end + 1, : ) = mean ( data ( 1: 2, : ) );

% Mostramos la señal.
eegplot ( data, 'srate', fs, 'winlength', 10 )

% Esperamos a que el usuario cierre la figura.
uiwait

% Selecciona el número del canal de la matriz que corresponde al ruido.
noise = 20;

% Inicializamos los datos de salida.
clean = zeros ( size ( data ) );

% Eliminamos la proyección del ruido en cada canal.
for i = 1: size ( data, 1 )
    % Utiliza la funciÃ³n 'regress' para calcular la proyección del ruido.
    beta = regress(data(i,:)',data(noise,:)');
    % Sustrae la proyecciÃ³n del ruido del canal actual.
    clean ( i, : ) = data(i, :) - beta*data(noise,:);
end

% Comparamos los canales antes (rojo) y despuÃ©s (negro) del filtrado.
eegplot ( clean, 'data2', data, 'srate', fs )
