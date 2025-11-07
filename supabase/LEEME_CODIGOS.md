# 📝 Generar Códigos Promocionales

Este directorio contiene scripts SQL para generar códigos promocionales en Supabase.

## 🎯 Objetivo

Generar **2148 códigos promocionales únicos** en la tabla `codigos` de tu base de datos.

## 📋 Scripts Disponibles

### 1. `quick_add_codes.sql` ⭐ RECOMENDADO

**Script más simple y directo**. Agrega automáticamente los códigos necesarios hasta llegar a 2148.

**Características:**
- ✅ Detecta automáticamente cuántos códigos ya tienes
- ✅ Genera solo los necesarios para llegar a 2148
- ✅ Muestra progreso cada 200 códigos
- ✅ Verifica que no haya duplicados
- ✅ No borra códigos existentes

**Cómo usarlo:**
1. Abre el **SQL Editor** en Supabase
2. Copia y pega el contenido completo de `quick_add_codes.sql`
3. Haz clic en **Run** (o presiona Ctrl+Enter)
4. Espera a que termine (puede tomar unos minutos)
5. Verifica el resultado en la última consulta

### 2. `generate_more_codes.sql`

Script más robusto con función reutilizable.

**Características:**
- ✅ Crea una función que puedes reutilizar
- ✅ Muestra progreso detallado
- ✅ Manejo de errores avanzado
- ✅ Puedes especificar un número objetivo diferente

**Cómo usarlo:**
```sql
-- Ejecutar todos los bloques del archivo
SELECT add_more_codes(2148);  -- Genera hasta 2148 códigos
```

## 📊 Estructura de la Tabla `codigos`

```sql
CREATE TABLE codigos (
  id UUID PRIMARY KEY,
  codigo VARCHAR(20) NOT NULL UNIQUE,  -- Código promocional de 8 caracteres
  usado BOOLEAN DEFAULT FALSE,         -- Si ya fue utilizado
  fecha_creacion TIMESTAMP,
  fecha_uso TIMESTAMP,                 -- Cuando se usó (si ya se usó)
  usuario_dni VARCHAR(20),             -- DNI del usuario que lo usó
  created_at TIMESTAMP
);
```

## 🔍 Verificar Códigos

Después de ejecutar cualquier script, puedes verificar con:

```sql
SELECT 
  COUNT(*) as total_codigos,
  COUNT(*) FILTER (WHERE usado = FALSE) as disponibles,
  COUNT(*) FILTER (WHERE usado = TRUE) as usados
FROM codigos;
```

## ⚠️ Importante

- Los códigos son de **8 caracteres alfanuméricos** en mayúsculas
- Cada código es **único** gracias a la verificación de duplicados
- Los códigos existentes **NO se borran**
- La generación puede tardar varios minutos (es normal)

## 🚀 Recomendación

Usa `quick_add_codes.sql` para la generación inicial. Es el más simple y eficiente.

