import { useState } from 'react';
import { CheckCircle, XCircle, Loader2 } from 'lucide-react';
import { supabase } from './lib/supabase';

function App() {
  const [codigoPromocional, setCodigoPromocional] = useState('');
  const [dni, setDni] = useState('');
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<{ valid: boolean; message: string } | null>(null);

  const handleValidate = async () => {
    if (!codigoPromocional.trim() || !dni.trim()) {
      setResult({ valid: false, message: 'Por favor completa ambos campos' });
      return;
    }

    setLoading(true);
    setResult(null);

    try {
      const { data, error } = await supabase
        .from('codigos')
        .select('*')
        .eq('codigo', codigoPromocional.trim())
        .eq('usuario_dni', dni.trim())
        .maybeSingle();

      if (error) {
        throw error;
      }

      if (data) {
        setResult({ valid: true, message: 'Código promocional válido' });
      } else {
        setResult({ valid: false, message: 'Código promocional inválido para este DNI' });
      }
    } catch (error) {
      console.error('Error validating code:', error);
      setResult({ valid: false, message: 'Error al validar el código. Intenta nuevamente.' });
    } finally {
      setLoading(false);
    }
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleValidate();
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-900 via-purple-800 to-fuchsia-800 flex items-center justify-center px-4">
      <div className="w-full max-w-md">
        <div className="bg-black/40 backdrop-blur-md rounded-2xl p-8 shadow-2xl border border-purple-500/30">
          <h1 className="text-3xl font-bold text-white text-center mb-8">
            Lanzamiento CRUNCHY Validator
          </h1>

          <div className="space-y-6">
            <div>
              <label htmlFor="codigo" className="block text-white text-sm font-medium mb-2">
                Código Promocional
              </label>
              <input
                id="codigo"
                type="text"
                value={codigoPromocional}
                onChange={(e) => setCodigoPromocional(e.target.value)}
                onKeyPress={handleKeyPress}
                className="w-full px-4 py-3 rounded-lg bg-white/10 border border-purple-400/30 text-white placeholder-purple-300/50 focus:outline-none focus:ring-2 focus:ring-fuchsia-500 focus:border-transparent transition-all"
                placeholder="Ingresa tu código"
                disabled={loading}
              />
            </div>

            <div>
              <label htmlFor="dni" className="block text-white text-sm font-medium mb-2">
                DNI
              </label>
              <input
                id="dni"
                type="text"
                value={dni}
                onChange={(e) => setDni(e.target.value)}
                onKeyPress={handleKeyPress}
                className="w-full px-4 py-3 rounded-lg bg-white/10 border border-purple-400/30 text-white placeholder-purple-300/50 focus:outline-none focus:ring-2 focus:ring-fuchsia-500 focus:border-transparent transition-all"
                placeholder="Ingresa tu DNI"
                disabled={loading}
              />
            </div>

            <button
              onClick={handleValidate}
              disabled={loading}
              className="w-full py-3 px-6 bg-gradient-to-r from-fuchsia-500 to-pink-500 hover:from-fuchsia-600 hover:to-pink-600 text-white font-semibold rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              {loading ? (
                <>
                  <Loader2 className="w-5 h-5 animate-spin" />
                  Validando...
                </>
              ) : (
                'Validar'
              )}
            </button>
          </div>

          {result && (
            <div
              className={`mt-6 p-4 rounded-lg flex items-center gap-3 animate-fade-in ${
                result.valid
                  ? 'bg-green-500/20 border border-green-400/30'
                  : 'bg-red-500/20 border border-red-400/30'
              }`}
            >
              {result.valid ? (
                <CheckCircle className="w-6 h-6 text-green-400 flex-shrink-0" />
              ) : (
                <XCircle className="w-6 h-6 text-red-400 flex-shrink-0" />
              )}
              <p className={`font-medium ${result.valid ? 'text-green-100' : 'text-red-100'}`}>
                {result.message}
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default App;
