-- Script rápido para agregar códigos hasta llegar a 2148
-- Ejecutar en el SQL Editor de Supabase

-- Paso 1: Ver estado actual
SELECT 
  COUNT(*) as "Total Actual",
  COUNT(*) FILTER (WHERE usado = FALSE) as "Disponibles",
  COUNT(*) FILTER (WHERE usado = TRUE) as "Usados"
FROM codigos;

-- Paso 2: Función simple para generar códigos
DO $$
DECLARE
  current_count INTEGER;
  target_count INTEGER := 2148;
  i INTEGER;
  new_code TEXT;
  success INTEGER := 0;
BEGIN
  -- Contar códigos actuales
  SELECT COUNT(*) INTO current_count FROM codigos;
  
  RAISE NOTICE 'Códigos actuales: % de % necesarios', current_count, target_count;
  
  -- Generar códigos faltantes
  FOR i IN 1..(target_count - current_count) LOOP
    LOOP
      -- Generar código de 8 caracteres
      new_code := upper(substring(md5(random()::text || i || current_count) from 1 for 8));
      
      -- Verificar unicidad
      EXIT WHEN NOT EXISTS (SELECT 1 FROM codigos WHERE codigo = new_code);
    END LOOP;
    
    -- Insertar código
    INSERT INTO codigos (codigo, usado, fecha_creacion)
    VALUES (new_code, FALSE, NOW());
    
    success := success + 1;
    
    -- Progreso cada 200 códigos
    IF success % 200 = 0 THEN
      RAISE NOTICE 'Progreso: %/% códigos generados', success, (target_count - current_count);
    END IF;
  END LOOP;
  
  RAISE NOTICE '✅ Completado! Códigos generados: %', success;
END $$;

-- Paso 3: Verificar resultado
SELECT 
  COUNT(*) as "Total Final",
  COUNT(*) FILTER (WHERE usado = FALSE) as "Disponibles",
  COUNT(*) FILTER (WHERE usado = TRUE) as "Usados"
FROM codigos;








