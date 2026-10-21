% CASO PRÁCTICO 2 - TRATAMIENTO DE RUIDO
% CÓDIGO 4: BSS - ICA

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

% Selecciona el canal de la matriz que corresponde al ruido.
noise = #

% Utiliza la funciÃ³n 'sobi' para calcular la matriz de mezcla de ICA.
mixing = sobi ( # );

% Calculamos las componentes a partir de la inversa de la matriz de mezcla.
ICAs  = pinv ( mixing ) * data;

% Calculamos la correlaciÃ³n entre cada componente y el canal de ruido.
corrs = corr ( ICAs', data ( noise, : )' );

% Limpiamos la pantalla.
clc

% Ordenamos las correlaciones y las mostramos.
fprintf ( 1, 'Correlación entre el canal de ruido y las componentes calculadas:\n' );
[ corrs, chans ] = sort ( abs ( corrs ), 1, 'descend' );
for idx = 1: numel ( chans )
    fprintf ( 1, '  Componente %i: %.3f.\n', chans ( idx ), corrs ( idx ) );
end

% Esperamos a que el usuario pulse una tecla.
fprintf ( 1, 'Pulse una tecla para continuar.\n' );
pause

% Visualizamos las componentes junto con el canal de ruido.
eegplot ( ICAs, 'srate', fs )

% Preguntamos al usuario por la componente a eliminar.
ICAn = inputdlg ( 'Seleccione la componente a eliminar.', 'Número de componente:' );
ICAn = str2double ( ICAn );

close all

% Eliminamos la componente ruidosa y reconstruimos los datos.
ICAs ( # ) = 0;
clean = #

% Comparamos los canales antes (rojo) y despuÃ©s (negro) del filtrado.
eegplot ( clean, 'data2', data, 'srate', fs )
