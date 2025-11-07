import { copyFileSync, existsSync } from 'fs';
import { join } from 'path';
import { fileURLToPath } from 'url';
import { dirname } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const sourceFile = join(__dirname, '..', 'public', '.htaccess');
const destFile = join(__dirname, '..', 'dist', '.htaccess');

try {
  if (existsSync(sourceFile)) {
    copyFileSync(sourceFile, destFile);
    console.log('✓ Copiado .htaccess a dist/');
  } else {
    console.warn('⚠ .htaccess no encontrado en public/');
  }
} catch (error) {
  console.error('Error copiando .htaccess:', error);
  process.exit(1);
}









