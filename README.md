# pbPdfExtractor — Extraer texto de PDFs 📄🔍

![PowerBuilder](https://img.shields.io/badge/PowerBuilder-2025-orange?style=flat-square)
![.NET](https://img.shields.io/badge/.NET-10-512BD4?style=flat-square&logo=dotnet&logoColor=white)
![itext7](https://img.shields.io/badge/itext7-9.6.0-2C8EBB?style=flat-square)
![Blog](https://img.shields.io/badge/blog-rsrsystem-FF5722?style=flat-square&logo=blogger&logoColor=white)

## 📋 ¿Qué es esto?

Un ejemplo de PowerBuilder para **extraer el texto de un PDF**. Le pasáis un fichero (y opcionalmente un rango de páginas) y os devuelve el texto, ya sea **volcado a un .txt** o **directamente en un blob** para tratarlo en memoria.

Lo interesante, como en el resto de ejemplos de esta serie, es el "cómo": el trabajo lo hace una **librería .NET** (`PdfExtractor`) que PowerBuilder 2025 importa con el **.NET DLL Importer** y consume como un `dotnetobject`. Instanciáis la clase `PdfExtractor` y llamáis a sus métodos como si fueran de PB:

- `PdfToTxt(string inputFile, string outputFile, int pageFrom, int pageTo)` → extrae el texto a un fichero de salida.
- `PdfToblob(string inputFile, int pageFrom, int pageTo)` → devuelve el texto como `byte[]` (blob) para usarlo sin tocar disco.
- `GetError()` → recupera el último mensaje de error si algo falla.

En la carpeta tenéis un `Test.pdf` y su resultado `Test.txt` para que comparéis de un vistazo.

## 🔗 Motor .NET

El motor es la librería **`PdfExtractor`**, desplegada en `DotNet\PdfExtractor\` y consumida desde PowerBuilder como `dotnetobject`.

- **Código fuente .NET:** `C:\proyecto pw2025\Blog\Net10\PdfExtractor` (antes en `Net8`).
- **Repo .NET (Visual Studio 2022):** <https://github.com/rasanfe/PdfExtractor>
- **Despliegue:** se publica y se copia a `DotNet\PdfExtractor\` con el script `desplegar_dotnet.bat` (hace `dotnet publish` y espeja las DLLs al ejemplo).

> 💡 **Dato didáctico:** este ejemplo nació usando **iTextSharp 5**, que lleva años **abandonada**. Al migrarlo a **.NET 10** se ha actualizado a **itext7 9.6.0**, la rama moderna y mantenida de la librería. Mismo objetivo (leer texto del PDF), pero sobre cimientos al día.

## 🛠️ Requisitos

- **PowerBuilder 2025** (con el .NET DLL Importer).
- **.NET 10 Runtime** instalado en la máquina que ejecuta el ejemplo.
- Las DLLs de `DotNet\PdfExtractor\` (itext7 y dependencias).

## ▶️ Cómo probarlo

1. Clona el repo "en modo solución" y abre el workspace en PowerBuilder 2025.
2. Compila y ejecuta `pbpdfextractor`.
3. Selecciona `Test.pdf` (incluido en la carpeta) e indica el rango de páginas.
4. Extrae a `.txt` o a blob y compara con el `Test.txt` de ejemplo.

## 🔗 Repo PowerBuilder

- **Ejemplo PB (modo solución):** <https://github.com/rasanfe/pbPdfExtractor>
- **Motor .NET:** <https://github.com/rasanfe/PdfExtractor>

---

> ¡Nos vemos en el próximo artículo! Y recuerda: en PowerBuilder, los límites solo están en nuestra imaginación. 🚀

📨 **Blog:** <https://rsrsystem.blogspot.com/>
