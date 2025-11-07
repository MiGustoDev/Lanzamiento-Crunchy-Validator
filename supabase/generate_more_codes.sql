-- Script para generar códigos adicionales hasta llegar a 2148
-- Ejecutar en el SQL Editor de Supabase

-- Primero, verificar cuántos códigos tienes actualmente
SELECT 
  'Códigos actuales' as estado,
  COUNT(*) as total,
  COUNT(*) FILTER (WHERE usado = FALSE) as disponibles,
  COUNT(*) FILTER (WHERE usado = TRUE) as usados
FROM codigos;

-- Función para generar códigos adicionales
CREATE OR REPLACE FUNCTION add_more_codes(target_count INTEGER DEFAULT 2148)
RETURNS INTEGER AS $$
DECLARE
  current_count INTEGER;
  needed_codes INTEGER;
  codes_generated INTEGER := 0;
  code TEXT;
  exists_count INTEGER;
BEGIN
  -- Obtener el número actual de códigos
  SELECT COUNT(*) INTO current_count FROM codigos;
  
  -- Calcular cuántos códigos necesitamos
  needed_codes := GREATEST(0, target_count - current_count);
  
  RAISE NOTICE 'Códigos actuales: %, Objetivo: %, Necesarios: %', current_count, target_count, needed_codes;
  
  -- Si ya tenemos suficientes códigos
  IF needed_codes <= 0 THEN
    RAISE NOTICE 'Ya tienes suficientes códigos. Actual: %, Objetivo: %', current_count, target_count;
    RETURN 0;
  END IF;
  
  -- Generar códigos adicionales
  FOR i IN 1..needed_codes LOOP
    LOOP
      -- Generar código de 8 caracteres alfanuméricos
      code := upper(substring(md5(random()::text || current_count || i) from 1 for 8));
      
      -- Verificar si el código ya existe
      SELECT COUNT(*) INTO exists_count FROM codigos WHERE codigo = code;
      
      -- Si no existe, salir del loop
      IF exists_count = 0 THEN
        EXIT;
      END IF;
    END LOOP;
    
    -- Insertar el código único
    BEGIN
      INSERT INTO codigos (codigo, usado, fecha_creacion)
      VALUES (code, FALSE, NOW());
      codes_generated := codes_generated + 1;
      
      -- Mostrar progreso cada 100 códigos
      IF codes_generated % 100 = 0 THEN
        RAISE NOTICE 'Generados % códigos de % necesarios...', codes_generated, needed_codes;
      END IF;
      
    EXCEPTION WHEN unique_violation THEN
      -- Si por alguna razón hay duplicado, continuar
      CONTINUE;
    END;
  END LOOP;
  
  RAISE NOTICE '¡Generación completada! Total de códigos nuevos: %', codes_generated;
  RETURN codes_generated;
END;
$$ LANGUAGE plpgsql;

-- Ejecutar la función para generar hasta 2148 códigos totales
SELECT add_more_codes(2148) as codigos_generados;

-- Verificar el resultado final
SELECT 
  'Resumen final' as estado,
  COUNT(*) as total_codigos,
  COUNT(*) FILTER (WHERE usado = FALSE) as codigos_disponibles,
  COUNT(*) FILTER (WHERE usado = TRUE) as codigos_usados
FROM codigos;

-- Limpiar función temporal (opcional, comentado para mantenerla)
-- DROP FUNCTION IF EXISTS add_more_codes(INTEGER);








