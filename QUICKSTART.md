# ⚡ Quick Start - FutApp

Guia rápido para rodar o projeto em 5 minutos!

## 📦 1. Instalar Flutter (se ainda não tem)

### Ubuntu/Debian
```bash
sudo snap install flutter --classic
flutter doctor
```

### Outras distribuições Linux
```bash
# Download
cd ~/
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz

# Extract
tar xf flutter_linux_3.16.0-stable.tar.xz

# Add to PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Verify
flutter doctor
```

## 🚀 2. Setup do Projeto

```bash
# Navegar até a pasta do projeto
cd futapp

# Tornar script executável
chmod +x setup.sh

# Executar setup
./setup.sh
```

## 🔑 3. Configurar Supabase

### 3.1 Criar conta no Supabase
1. Acesse: https://supabase.com
2. Clique em "Start your project"
3. Crie uma conta (gratuita)

### 3.2 Criar novo projeto
1. Clique em "New Project"
2. Dê um nome (ex: futapp)
3. Crie uma senha forte
4. Escolha região: South America (São Paulo)
5. Aguarde 2 minutos (criação do banco)

### 3.3 Pegar credenciais
1. No menu lateral, clique em **Settings** (⚙️)
2. Clique em **API**
3. Copie:
   - **Project URL** (algo como: https://xxxxx.supabase.co)
   - **anon public** key (uma string longa)

### 3.4 Adicionar no projeto
Edite o arquivo: `lib/core/constants/api_constants.dart`

```dart
static const String supabaseUrl = 'https://xxxxx.supabase.co'; // Cole aqui
static const String supabaseAnonKey = 'sua-chave-aqui'; // Cole aqui
```

## 🗄️ 4. Criar Tabelas no Banco

1. No Supabase, clique em **SQL Editor** no menu lateral
2. Clique em **New query**
3. Copie TODO o conteúdo do arquivo `database/create_tables.sql`
4. Cole no editor SQL
5. Clique em **RUN** (ou Ctrl+Enter)
6. Aguarde ~10 segundos
7. Deve aparecer "Success. No rows returned"

## 📱 5. Executar o App

### Opção A - Android (Emulador)
```bash
# Listar emuladores
flutter emulators

# Iniciar emulador
flutter emulators --launch <emulator_id>

# Ou abrir Android Studio e iniciar pelo AVD Manager

# Rodar app
flutter run
```

### Opção B - Android (Dispositivo Físico)
```bash
# 1. Ativar modo desenvolvedor no Android
# 2. Ativar depuração USB
# 3. Conectar via USB

# Verificar dispositivo
adb devices

# Rodar app
flutter run
```

### Opção C - Linux Desktop
```bash
flutter run -d linux
```

## ✅ 6. Testar o App

1. O app deve abrir na tela de Splash
2. Depois ir para tela de Login
3. Clique em "Criar conta"
4. Preencha os dados
5. Clique em "Criar conta"
6. Veja no console se aparece erro ou sucesso

**Nota:** O login ainda não está funcional - isso será implementado na Sprint 1 seguindo o guia NEXT_STEPS.md

## 🐛 Problemas Comuns

### "Flutter command not found"
```bash
# Adicione Flutter ao PATH
export PATH="$PATH:$HOME/flutter/bin"
```

### "Unable to locate Android SDK"
```bash
flutter doctor --android-licenses
```

### "No devices found"
```bash
# Verificar se o device está conectado
adb devices

# Reiniciar adb
adb kill-server
adb start-server
```

### Erro ao instalar dependências
```bash
flutter clean
flutter pub get
```

## 📖 Próximos Passos

Agora que o projeto está rodando, siga o arquivo **NEXT_STEPS.md** para:
1. Implementar autenticação completa (Sprint 1)
2. Criar listagem de arenas (Sprint 2)
3. Sistema de reservas (Sprint 3)
4. Procurar parceiros/Racha (Sprint 4)

## 🎯 Estrutura Atual

```
✅ Setup do projeto
✅ Telas de Login e Registro (UI)
✅ Configuração do Supabase
✅ Banco de dados criado
✅ Arquitetura definida
⏳ BLoC de Auth (próximo passo)
⏳ Integração funcional (próximo passo)
```

## 🆘 Ajuda

Se tiver problemas:
1. Leia o README.md completo
2. Consulte NEXT_STEPS.md
3. Verifique os logs do console
4. Use `flutter doctor` para diagnosticar

---

**Pronto! Agora é só seguir o NEXT_STEPS.md para desenvolver as features! 🚀**
