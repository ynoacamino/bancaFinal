Detalles al momento de probar:
1. Importar la base de datos en sql/bancafinal.sql
2. Istalar todos los modulos de perl que se usan (lo siento esto es raro):
    - Ejecutar el shell del servidor
    - Ejecutar los siguientes comandos:
        cpanm install CGI
        cpanm install CGI::Session
        cpanm install CGI::Cookie
        cpanm install DBI
        cpanm install DateTime
    - Copiar ambos archivos en perl-modules a XAMPP/perl/vendor/lib/CGI
3. Copiar todo el repositorio dentro de una carpeta dentro de htdocs
4. Rezar