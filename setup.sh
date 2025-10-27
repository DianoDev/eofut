#!/bin/bash

echo "========================================="
echo "   FutApp - Setup do Projeto"
echo "========================================="
echo ""

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter não está instalado!"
    echo "Instale o Flutter: https://docs.flutter.dev/get-started/install/linux"
    exit 1
fi

echo "✅ Flutter encontrado: $(flutter --version | head -n 1)"
echo ""

# Instalar dependências
echo "📦 Instalando dependências do Flutter..."
flutter pub get

if [ $? -eq 0 ]; then
    echo "✅ Dependências instaladas com sucesso!"
else
    echo "❌ Erro ao instalar dependências"
    exit 1
fi

echo ""

# Verificar se existe o arquivo de configuração
if [ ! -f "lib/core/constants/api_constants.dart" ]; then
    echo "⚠️  Arquivo api_constants.dart não encontrado!"
    echo ""
    echo "📝 Criando api_constants.dart a partir do exemplo..."
    cp lib/core/constants/api_constants.example.dart lib/core/constants/api_constants.dart
    echo "✅ Arquivo criado!"
    echo ""
    echo "⚠️  IMPORTANTE: Edite o arquivo lib/core/constants/api_constants.dart"
    echo "   e adicione suas credenciais do Supabase antes de executar o app!"
    echo ""
fi

# Verificar dispositivos conectados
echo "📱 Verificando dispositivos conectados..."
flutter devices

echo ""
echo "========================================="
echo "   ✨ Setup concluído!"
echo "========================================="
echo ""
echo "Próximos passos:"
echo "1. Configure suas credenciais do Supabase em:"
echo "   lib/core/constants/api_constants.dart"
echo ""
echo "2. Execute as queries SQL no Supabase:"
echo "   Copie o conteúdo do README.md (seção Scripts SQL)"
echo ""
echo "3. Execute o app:"
echo "   flutter run"
echo ""
echo "========================================="
