#!/bin/bash
set -e

CONFIG_FILE="/etc/sek-plano-ops/config.env"

echo "════════════════════════════════════════════════════════════════════════════════"
echo "SEK Plano de Operação — Configuração SharePoint (executa uma única vez)"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""

if [ "$EUID" -ne 0 ]; then
    echo "[ERRO] Execute com sudo: sudo $0"
    exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "[ERRO] config.env não encontrado em $CONFIG_FILE"
    echo "       Execute primeiro: sudo ./setup/install.sh"
    exit 1
fi

echo "Este script configura a autenticação com SharePoint (proofcrm.sharepoint.com)"
echo "Você precisa de credenciais de um App Registration Azure AD no tenant do proofcrm."
echo ""
echo "Para criar o App Registration, consulte: docs/SHAREPOINT_CONFIG.md"
echo ""

# Verificar se já está configurado
TENANT=$(grep "PLANO_OPS_SP_TENANT=" "$CONFIG_FILE" | cut -d= -f2)
CLI_ID=$(grep "PLANO_OPS_SP_CLI_ID=" "$CONFIG_FILE" | cut -d= -f2)

if [ -n "$TENANT" ] && [ -n "$CLI_ID" ]; then
    echo "⚠️  Credenciais já configuradas!"
    echo "   Tenant: ${TENANT:0:8}...${TENANT: -8}"
    echo "   Client ID: ${CLI_ID:0:8}...${CLI_ID: -8}"
    echo ""
    read -p "Sobrescrever? (s/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Abortado."
        exit 0
    fi
fi

echo ""
echo "Preencha os seguintes dados:"
echo ""

# Tenant ID
read -p "Tenant ID do proofcrm (UUID): " TENANT_ID
if [ -z "$TENANT_ID" ]; then
    echo "[ERRO] Tenant ID não pode ser vazio"
    exit 1
fi

# Client ID
read -p "Client ID do App Registration: " CLIENT_ID
if [ -z "$CLIENT_ID" ]; then
    echo "[ERRO] Client ID não pode ser vazio"
    exit 1
fi

# Client Secret (escondido)
read -sp "Client Secret (não será exibido): " CLIENT_SECRET
echo ""
if [ -z "$CLIENT_SECRET" ]; then
    echo "[ERRO] Client Secret não pode ser vazio"
    exit 1
fi

echo ""
echo "Testando autenticação..."

# Teste simples: tentar obter token
TOKEN_RESPONSE=$(python3 << 'PYEOF'
import urllib.request, json, sys, urllib.parse
tenant = sys.argv[1]
client_id = sys.argv[2]
client_secret = sys.argv[3]

try:
    url = f"https://login.microsoftonline.com/{tenant}/oauth2/v2.0/token"
    body = urllib.parse.urlencode({
        "client_id": client_id,
        "client_secret": client_secret,
        "grant_type": "client_credentials",
        "scope": "https://graph.microsoft.com/.default",
    }).encode()
    req = urllib.request.Request(url, body, {"Content-Type": "application/x-www-form-urlencoded"})
    with urllib.request.urlopen(req, timeout=10) as r:
        resp = json.loads(r.read())
    if "access_token" in resp:
        print("OK")
    else:
        print("ERROR:" + resp.get("error_description", str(resp)))
except Exception as e:
    print("ERROR:" + str(e))
PYEOF
python3 - "$TENANT_ID" "$CLIENT_ID" "$CLIENT_SECRET"
)

if [[ "$TOKEN_RESPONSE" == "OK" ]]; then
    echo "✅ Autenticação com sucesso!"
else
    echo "❌ Falha na autenticação:"
    echo "   $TOKEN_RESPONSE"
    exit 1
fi

echo ""
echo "Salvando configuração em $CONFIG_FILE..."

# Atualizar config.env
sed -i "s|^PLANO_OPS_SP_TENANT=.*|PLANO_OPS_SP_TENANT=\"$TENANT_ID\"|" "$CONFIG_FILE"
sed -i "s|^PLANO_OPS_SP_CLI_ID=.*|PLANO_OPS_SP_CLI_ID=\"$CLIENT_ID\"|" "$CONFIG_FILE"
sed -i "s|^PLANO_OPS_SP_CLI_SEC=.*|PLANO_OPS_SP_CLI_SEC=\"$CLIENT_SECRET\"|" "$CONFIG_FILE"

chmod 600 "$CONFIG_FILE"
echo "✅ Configuração salva e protegida (chmod 600)"

echo ""
echo "════════════════════════════════════════════════════════════════════════════════"
echo "✅ CONFIGURAÇÃO COMPLETA!"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""
echo "O sistema agora tem acesso automático ao SharePoint."
echo ""
echo "Próximo passo:"
echo "  Reinicie Flask: systemctl restart sek-paloalto-agent"
echo "  Ou: pkill -f 'python3 web_sentinel.py' && (cd /opt/sek-paloalto-agent && python3 web_sentinel.py &)"
echo ""
echo "Depois acesse:"
echo "  http://sekhealthcheck/portal/materdei"
echo ""
