# 🚀 Instrucciones de Despliegue - Lanzamiento Crunchy Validator

## Configuración para migusto.com.ar/validacion

Este proyecto está configurado para funcionar en un subdirectorio: **migusto.com.ar/validacion**

### Pasos para desplegar:

1. **Crear archivo `.env`** con las credenciales de Supabase:
   ```
   VITE_SUPABASE_URL=tu_url_de_supabase
   VITE_SUPABASE_ANON_KEY=tu_clave_anonima_de_supabase
   ```

2. **Compilar el proyecto**:
   ```bash
   npm run build
   ```

3. **Subir los archivos** de la carpeta `dist/` a tu servidor en:
   ```
   migusto.com.ar/validacion/
   ```

   La estructura debe ser:
   ```
   /validacion/
   ├── .htaccess
   ├── index.html
   ├── CRUNCHY.png
   └── assets/
       ├── index-[hash].js
       └── index-[hash].css
   ```

### Archivos importantes incluidos:

- ✅ **`vite.config.ts`**: Configurado con `base: '/validacion/'`
- ✅ **`.htaccess`**: Configuración Apache para SPA routing
- ✅ **`CRUNCHY.png`**: Favicon de la aplicación
- ✅ **Scripts de build**: Automáticamente copia el .htaccess a dist/

### Notas importantes:

- El archivo `.htaccess` es **crítico** para que funcione correctamente
- Todas las rutas apuntan a `/validacion/` incluyendo assets y recursos
- Si ves la pantalla en blanco, verifica que el `.htaccess` esté en el directorio correcto

### Variables de entorno necesarias:

Las variables deben estar configuradas en:
- **Desarrollo**: Archivo `.env` en la raíz del proyecto
- **Producción**: Configúralas en el servidor antes del build o usa archivo `.env` en producción

### Troubleshooting:

**Pantalla en blanco al cargar:**
- Verifica que `.htaccess` esté en `/validacion/` en el servidor
- Verifica que las variables de entorno de Supabase estén configuradas
- Revisa la consola del navegador para errores de CORS o conexión

**Recursos no cargan:**
- Verifica que los archivos en `assets/` estén accesibles
- Verifica que `CRUNCHY.png` esté en `/validacion/`
- Limpia la caché del navegador









