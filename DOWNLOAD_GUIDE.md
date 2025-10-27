# 📥 GUIA DE DOWNLOAD - FutApp

## 🎯 Opções de Download

Escolha uma das opções abaixo:

### **Opção 1 - TAR.GZ (Recomendado para Linux)** ⭐
- Arquivo: `futapp.tar.gz` (22 KB)
- Formato nativo Linux
- Preserva permissões

### **Opção 2 - ZIP**
- Arquivo: `futapp.zip` (36 KB)
- Universal
- Fácil de extrair

---

## 📦 Como Extrair

### TAR.GZ
```bash
# Extrair
tar -xzf futapp.tar.gz

# Navegar
cd futapp

# Dar permissão ao script
chmod +x setup.sh

# Executar setup
./setup.sh
```

### ZIP
```bash
# Extrair
unzip futapp.zip

# Navegar
cd futapp

# Dar permissão ao script
chmod +x setup.sh

# Executar setup
./setup.sh
```

---

## 🚀 Passos Completos (Depois de Extrair)

### 1. Verificar Flutter
```bash
flutter --version
# Se não tiver, instale: sudo snap install flutter --classic
```

### 2. Instalar Dependências
```bash
cd futapp
./setup.sh
```

### 3. Configurar Supabase

#### 3.1 Criar conta e projeto
1. Acesse: https://supabase.com
2. Crie conta gratuita
3. Clique em "New Project"
4. Nome: `futapp`
5. Senha: (escolha uma forte)
6. Região: South America (São Paulo)
7. Aguarde 2 minutos

#### 3.2 Copiar credenciais
1. Menu lateral → **Settings** (⚙️)
2. Clique em **API**
3. Copie:
   - **URL**: https://xxxxx.supabase.co
   - **anon public key**: (string longa)

#### 3.3 Colar no projeto
Edite: `lib/core/constants/api_constants.dart`

```dart
static const String supabaseUrl = 'COLE_SUA_URL_AQUI';
static const String supabaseAnonKey = 'COLE_SUA_KEY_AQUI';
```

### 4. Criar Banco de Dados

1. No Supabase → **SQL Editor** (menu lateral)
2. Clique em **New query**
3. Abra o arquivo: `database/create_tables.sql`
4. Copie TODO o conteúdo
5. Cole no SQL Editor do Supabase
6. Clique **RUN** (ou Ctrl+Enter)
7. Aguarde ~10 segundos
8. Deve aparecer: "Success. No rows returned"

### 5. Executar App

```bash
# Ver dispositivos disponíveis
flutter devices

# Rodar no emulador/device
flutter run

# Ou específico para Linux desktop
flutter run -d linux
```

---

## 📱 Testar o App

1. ✅ Splash screen aparece
2. ✅ Tela de login aparece
3. ✅ Clique em "Criar conta"
4. ✅ Preencha os dados
5. ⏳ Por enquanto só mostra mensagem (ainda não conecta com Supabase)
6. 👉 Para conectar, siga: `NEXT_STEPS.md`

---

## 🐛 Problemas Comuns

### "Flutter not found"
```bash
# Instalar Flutter
sudo snap install flutter --classic

# Ou manualmente
cd ~/
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.0-stable.tar.xz
tar xf flutter_linux_3.16.0-stable.tar.xz
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc
```

### "Permission denied" no setup.sh
```bash
chmod +x setup.sh
```

### Erro ao instalar dependências
```bash
flutter clean
flutter pub get
```

### "No devices found"
```bash
# Para Android físico
adb devices

# Para emulador
flutter emulators
flutter emulators --launch <emulator_id>

# Para Linux desktop
flutter config --enable-linux-desktop
```

---

## 📂 Estrutura do Projeto Extraído

```
futapp/
├── 📄 PROJECT_SUMMARY.md      ⭐ Leia primeiro!
├── 📄 QUICKSTART.md           Setup rápido
├── 📄 NEXT_STEPS.md           Roadmap desenvolvimento
├── 📄 README.md               Documentação completa
├── 📄 DOWNLOAD_GUIDE.md       Este arquivo
├── 🔧 setup.sh                Script automático
├── 📦 pubspec.yaml
├── 🗄️ database/
│   └── create_tables.sql
└── 💻 lib/
    ├── main.dart
    ├── app.dart
    ├── injection_container.dart
    ├── core/
    ├── domain/
    ├── data/
    └── presentation/
```

---

## ✅ Checklist Completo

- [ ] Baixei e extraí o projeto
- [ ] Instalei o Flutter
- [ ] Executei `./setup.sh`
- [ ] Criei conta no Supabase
- [ ] Criei projeto no Supabase
- [ ] Copiei URL e anon key
- [ ] Editei `api_constants.dart`
- [ ] Executei script SQL no Supabase
- [ ] Executei `flutter run`
- [ ] App está rodando! 🎉

---

## 🎯 Próximos Passos

Agora que o app está rodando, siga o arquivo **`NEXT_STEPS.md`** para:

1. **Sprint 1** - Implementar autenticação real
2. **Sprint 2** - Listar arenas
3. **Sprint 3** - Sistema de reservas
4. **Sprint 4** - Procurar parceiros

---

## 🆘 Ainda com Problemas?

1. Verifique os arquivos de documentação no projeto
2. Execute `flutter doctor` para diagnosticar
3. Leia os logs de erro com atenção
4. Consulte a documentação oficial:
   - Flutter: https://docs.flutter.dev/
   - Supabase: https://supabase.com/docs

---

## 💡 Dicas

- **Use VSCode ou Android Studio** - Melhor experiência
- **Instale extensões**: Flutter, Dart, BLoC
- **Use hot reload**: Pressione `r` no terminal
- **Debug com DevTools**: `flutter devtools`

---

**Projeto criado com ❤️ para a comunidade de futevôlei! ⚽🏐**

**BOA SORTE! 🚀**
