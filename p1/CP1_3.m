% CASO PR罜TICO 2 - TRATAMIENTO DE RUIDO
% C覦IGO 3: FILTRADO ADAPTATIVO

% Establecemos la frecuencia de muestreo.
fs = 500;

% Cargamos la se馻l EEG.
[ data, header ] = readedf ( 'EEG_CP1.edf' );

% Mostramos la lista de canales.
header.channelname

% Seleccionamos los datos entre los segundos 22 y 32.
data = data ( :, 22 * fs + 1: 32 * fs );

% Filtramos la se馻l en la banda de 1 a 45 Hz.
[ b, a ] = butter ( 2, [ 1 45 ] / ( fs / 2 ) );
data = filtfilt ( b, a, data' )';

% A馻dimos un nuevo canal, al final, con el promedio de Fp1 y Fp2.
data ( end + 1, : ) = mean ( data ( 1: 2, : ) );

% Mostramos la se馻l.
eegplot ( data, 'srate', fs, 'winlength', 10 )

% Esperamos a que el usuario cierre la figura.
uiwait

% Selecciona el n鷐ero del canal de la matriz que corresponde al ruido.
noise = 20;

% Inicializamos los datos de salida.
clean = zeros ( size ( data ) );

% Eliminamos la proyecci贸n del ruido en cada canal.
for i = 1: size ( data, 1 )
    % Utiliza la funci贸n 'regress' para alcular la proyecci贸n del ruido.
    beta = regress(data(noise,:),data);
    
    % Sustrae la proyecci贸n del ruido del canal actual.
    clean ( i, : ) = data ( i, : ) - data(noise,:) ;
end

% Comparamos los canales antes (rojo) y despu茅s (negro) del filtrado.
eegplot ( clean, 'data2', data, 'srate', fs )
