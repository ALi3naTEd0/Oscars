# The 97th Academy Awards

## Descripción

Esta es una aplicación Flutter que permite explorar las nominaciones para los Premios de la Academia número 97. La aplicación muestra información detallada sobre las películas nominadas, incluyendo el título, la categoría, una sinopsis, la calificación de IMDb y enlaces directos a la página de IMDb de cada película.

## Características

- **Navegación Sencilla:** Explora las nominaciones utilizando los botones "Anterior" y "Siguiente", que permiten navegar secuencialmente por la lista.
- **Selección Aleatoria:** Utiliza el botón "Aleatorio" para descubrir películas nominadas al azar.
- **Información Detallada:** Visualiza el título, la categoría de nominación, la calificación de IMDb, la duración, los géneros y la sinopsis de cada película.
- **Enlaces a IMDb:** Accede directamente a la página de IMDb de cada película con un solo toque.
- **Imágenes de Póster:** Muestra las imágenes de los pósters de las películas para una experiencia visual atractiva.
- **Carga en Caché:** Optimiza la experiencia del usuario cargando la información de las películas en caché para un acceso más rápido.

## Capturas de Pantalla

![Captura de pantalla 1](url_de_la_captura_de_pantalla_1.png)
_Explora la lista de nominaciones._

![Captura de pantalla 2](url_de_la_captura_de_pantalla_2.png)
_Visualiza información detallada de cada película nominada._

## Cómo Empezar

### Requisitos

- Flutter SDK instalado en tu máquina. Puedes descargarlo desde [flutter.dev](https://flutter.dev/docs/get-started/install).
- Android Studio o VS Code con el plugin de Flutter para desarrollo.

### Instalación

1. Clona el repositorio:

`git clone https://github.com/ALi3naTEd0/oscars.git`
`cd oscars`

2. Obtén las dependencias:

`flutter pub get`

### Ejecución

1. Conecta un dispositivo Android o iOS, o utiliza un emulador.
2. Ejecuta la aplicación:

`flutter run`

## Estructura del Proyecto

```
movie_awards_app/
├── android/ # Archivos de configuración para Android
├── ios/ # Archivos de configuración para iOS
├── lib/ # Código fuente de la aplicación
│ ├── main.dart # Punto de entrada de la aplicación
│ └── ... # Otros archivos .dart
├── pubspec.yaml # Archivo de configuración de Flutter
└── README.md # Este archivo
```

## Dependencias

La aplicación utiliza las siguientes dependencias:

- `http`: Para realizar solicitudes HTTP a IMDb y obtener la información de las películas.
- `url_launcher`: Para abrir las URL de IMDb en el navegador.
- `cached_network_image`: Para cargar y almacenar en caché las imágenes de los pósters de las películas.
- `path_provider`: Para acceder a las ubicaciones de los directorios en el dispositivo.
- `path`: Para manipular las rutas de los archivos.

Puedes encontrar la lista completa de dependencias en el archivo `pubspec.yaml`.

## Contribución

¡Las contribuciones son bienvenidas! Si encuentras algún error o tienes alguna sugerencia de mejora, no dudes en abrir un "issue" o enviar un "pull request".

## Licencia

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See the LICENSE file for more details.
