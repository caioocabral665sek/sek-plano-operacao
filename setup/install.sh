#!/bin/bash
set -e

echo "════════════════════════════════════════════════════════════════════════════════"
echo "SEK Plano de Operação — Instalação Automática"
echo "════════════════════════════════════════════════════════════════════════════════"

# Verificar se está rodando como sudo
if [ "$EUID" -ne 0 ]; then
    echo "[ERRO] Este script precisa ser executado como root (sudo)"
    exit 1
fi

# Configuração
REPO_URL="https://github.com/caioocabral665sek/sek-plano-operacao.git"
INSTALL_DIR="/opt/sek-plano-operacao"
CONFIG_DIR="/etc/sek-plano-ops"
WEB_SENTINEL="/opt/sek-paloalto-agent/web_sentinel.py"
CACHE_DIR="/opt/sek-paloalto-agent/cache"

echo ""
echo "[1] Verificando pré-requisitos..."
command -v python3 >/dev/null 2>&1 || { echo "❌ Python3 não instalado"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "❌ Git não instalado"; exit 1; }
[ -f "$WEB_SENTINEL" ] || { echo "❌ web_sentinel.py não encontrado em $WEB_SENTINEL"; exit 1; }
echo "✅ Python3, Git, web_sentinel.py OK"

echo ""
echo "[2] Criando diretório de instalação..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$CONFIG_DIR"
mkdir -p "$CACHE_DIR/planos_operacao"
chmod 700 "$CONFIG_DIR"
echo "✅ Diretórios criados"

echo ""
echo "[3] Clonando repositório..."
if [ -d "$INSTALL_DIR/.git" ]; then
    cd "$INSTALL_DIR"
    git pull origin main
else
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi
echo "✅ Repositório pronto"

echo ""
echo "[4] Instalando dependências Python..."
pip3 install -q python-docx requests cryptography
echo "✅ Dependências instaladas"

echo ""
echo "[5] Verificando integração com web_sentinel.py..."
if grep -q "_PLANO_OPS_TTL" "$WEB_SENTINEL"; then
    echo "✅ Plano de Operação já integrado em web_sentinel.py"
else
    echo "⚠️  Plano de Operação ainda não integrado"
    echo "   Execute: python3 /tmp/patch_plano_ops.py (se já baixado)"
    echo "   Ou: ./setup/integrate.sh"
fi

echo ""
echo "[6] Configurando variáveis de ambiente..."
if [ ! -f "$CONFIG_DIR/config.env" ]; then
    cat > "$CONFIG_DIR/config.env" << 'EOF'
# SharePoint Graph API credentials
PLANO_OPS_SP_TENANT=""
PLANO_OPS_SP_CLI_ID=""
PLANO_OPS_SP_CLI_SEC=""
PLANO_OPS_CACHE_TTL=604800
EOF
    chmod 600 "$CONFIG_DIR/config.env"
    echo "✅ config.env criado (vazio — execute: sudo ./setup/configure-sharepoint.sh)"
else
    echo "✅ config.env já existe"
fi

echo ""
echo "[7] Criando symlink para fácil acesso..."
ln -sf "$INSTALL_DIR" /opt/sek-plano-ops
ln -sf "$CONFIG_DIR/config.env" "$INSTALL_DIR/.env"
echo "✅ Symlinks criados"

echo ""
echo "[8] Testando conexão com Flask (porta 5090)..."
if curl -s http://localhost:5090/portal >/dev/null 2>&1; then
    echo "✅ Flask acessível em http://localhost:5090"
else
    echo "⚠️  Flask pode não estar rodando — inicie com: python3 /opt/sek-paloalto-agent/web_sentinel.py"
fi

echo ""
echo "════════════════════════════════════════════════════════════════════════════════"
echo "✅ INSTALAÇÃO COMPLETA!"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Próximos passos:"
echo "  1️⃣  Configure credenciais SharePoint:"
echo "      sudo $INSTALL_DIR/setup/configure-sharepoint.sh"
echo ""
echo "  2️⃣  Acesse o portal:"
echo "      http://sekhealthcheck/portal/materdei"
echo ""
echo "  3️⃣  Clique em 'Analisar' na seção Plano de Operação"
echo ""
echo "📚 Documentação: $INSTALL_DIR/docs/"
echo ""
