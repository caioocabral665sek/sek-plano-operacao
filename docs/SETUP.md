# Guia de Instalação — Plano de Operação

## Instalação Rápida (5 minutos)

```bash
# Clone o repo
git clone https://github.com/caioocabral665sek/sek-plano-operacao.git
cd sek-plano-operacao

# Execute instalação
sudo ./setup/install.sh

# Configure credenciais SharePoint (interativo)
sudo ./setup/configure-sharepoint.sh

# Reinicie Flask
sudo systemctl restart sek-paloalto-agent
# Ou manualmente:
# pkill -f 'python3 web_sentinel.py'
# cd /opt/sek-paloalto-agent && python3 web_sentinel.py &
```

Pronto! Acesse `http://sekhealthcheck/portal/materdei` e clique em **"Analisar"**.

---

## Instalação Detalhada

### 1. Pré-requisitos

- Linux (Ubuntu 20.04+, Debian 11+)
- Python 3.8+
- Git
- sudo access
- `web_sentinel.py` rodando em `http://localhost:5090`

### 2. Clone do Repositório

```bash
git clone https://github.com/caioocabral665sek/sek-plano-operacao.git /opt/sek-plano-operacao
cd /opt/sek-plano-operacao
```

### 3. Instalação de Dependências

```bash
# Automático (recomendado):
sudo ./setup/install.sh

# Ou manual:
pip3 install python-docx requests cryptography
mkdir -p /etc/sek-plano-ops
mkdir -p /opt/sek-paloalto-agent/cache/planos_operacao
chmod 700 /etc/sek-plano-ops
```

### 4. Configuração SharePoint

Este é o único passo que **requer input manual** (uma única vez).

#### 4a. Criar App Registration no Azure AD

Consulte [`docs/SHAREPOINT_CONFIG.md`](SHAREPOINT_CONFIG.md) para:
- Criar App Registration no tenant `proofcrm`
- Dar permissão `Sites.Read.All`
- Obter Client ID + Secret

#### 4b. Configurar no sistema

```bash
sudo ./setup/configure-sharepoint.sh
```

O script:
- [ ] Pede Tenant ID, Client ID, Client Secret
- [ ] Testa autenticação com Graph API
- [ ] Armazena em `/etc/sek-plano-ops/config.env` (permissões 600)

**Isso é feito uma única vez.** O sistema lê as credenciais automaticamente daí em diante.

### 5. Integração com web_sentinel.py

O patch já foi aplicado no servidor em **2026-05-26**. Se precisar reaplicar:

```bash
python3 /tmp/patch_plano_ops.py
```

Ou via script deste repo:

```bash
./setup/integrate.sh
```

Isso:
- Adiciona constantes + funções backend
- Adiciona seção no portal `/portal/<slug>`
- Adiciona CSS + JavaScript
- Verifica sintaxe

### 6. Iniciar Flask

```bash
# Se usar systemd:
sudo systemctl restart sek-paloalto-agent

# Se rodar manualmente:
cd /opt/sek-paloalto-agent
nohup python3 web_sentinel.py > /tmp/sentinel.log 2>&1 &

# Verificar:
curl http://localhost:5090/portal | head -20
```

### 7. Testar

```bash
# Acesse no browser:
# http://sekhealthcheck/portal/materdei

# Ou teste via API:
curl -X POST http://localhost:5090/api/plano-ops/materdei
# Retorna: {"status":"running"}

# Depois:
curl http://localhost:5090/api/plano-ops/materdei/status
# Retorna: {"status":"done","data":{...}} ou {"status":"running"}
```

---

## Troubleshooting

### Erro: "credenciais_nao_configuradas"

**Causa:** `/etc/sek-plano-ops/config.env` está vazio.

**Solução:**
```bash
sudo ./setup/configure-sharepoint.sh
```

### Erro: "Plano não encontrado em SharePoint"

**Possíveis causas:**
1. Cliente não está em `_PLANO_OPS_CLIENT_MAP`
2. Arquivo `.docx` não existe em SharePoint
3. Credenciais não têm acesso ao site SOCPROOF

**Solução:**
```bash
# Verificar config
cat /etc/sek-plano-ops/config.env

# Reconfigure se necessário
sudo ./setup/configure-sharepoint.sh

# Ou use arquivo local (fallback):
mkdir -p /opt/sek-paloalto-agent/planos_operacao
# Coloque arquivo em: /opt/sek-paloalto-agent/planos_operacao/materdei.docx
```

### Erro: "Claude análise falhou"

**Causa:** Claude CLI não disponível ou timeout.

**Solução:**
```bash
# Verificar Claude disponível:
/usr/local/bin/claude --model claude-sonnet-4-6 -p "test"

# Se falhar, instale Claude Code:
# https://claude.com/claude-code
```

### Cache muito antigo

A análise é cacheada por 7 dias. Para forçar nova análise:
- Clique no botão ♻ no portal, ou
- Delete o arquivo cache:
  ```bash
  rm /opt/sek-paloalto-agent/cache/plano_ops_materdei.json
  ```

---

## Atualizações

Para puxar atualizações do repo:

```bash
cd /opt/sek-plano-operacao
git pull origin main
# Se houver mudanças em requirements:
pip3 install -r setup/requirements.txt
# Reinicie Flask
sudo systemctl restart sek-paloalto-agent
```

---

## Suporte

- Docs: `/opt/sek-plano-operacao/docs/`
- Issues: https://github.com/caioocabral665sek/sek-plano-operacao/issues
- Email: `caio.cabral@sek.io`

---

**Última atualização:** 2026-05-26
